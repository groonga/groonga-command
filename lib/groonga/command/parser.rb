# -*- coding: utf-8 -*-
#
# Copyright (C) 2011-2012  Kouhei Sutou <kou@clear-code.com>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

require "shellwords"
require "cgi"

require "yajl"

require "groonga/command/error"

require "groonga/command/base"
require "groonga/command/get"
require "groonga/command/select"
require "groonga/command/suggest"
require "groonga/command/load"
require "groonga/command/table-create"
require "groonga/command/table-remove"
require "groonga/command/table-rename"
require "groonga/command/column-create"
require "groonga/command/column-remove"
require "groonga/command/column-rename"
require "groonga/command/delete"
require "groonga/command/truncate"

module Groonga
  module Command
    class ParseError < Error
    end

    class Parser
      class << self
        def parse(data, &block)
          if block_given?
            event_parse(data, &block)
          else
            stand_alone_parse(data)
          end
        end

        private
        def event_parse(data)
          parser = new

          parser.on_command do |command|
            yield(:on_command, command)
          end
          parser.on_load_start do |command|
            yield(:on_load_start, command)
          end
          parser.on_load_value do |command, value|
            yield(:on_load_value, command, value)
          end
          parser.on_load_complete do |command|
            yield(:on_load_complete, command)
          end
          parser.on_comment do |comment|
            yield(:on_comment, comment)
          end

          consume_data(parser, data)
        end

        def stand_alone_parse(data)
          parsed_command = nil

          parser = new
          parser.on_command do |command|
            parsed_command = command
          end
          parser.on_load_complete do |command|
            parsed_command = command
          end

          consume_data(parser, data)
          if parsed_command.nil?
            raise ParseError, "not completed: <#{data.inspect}>"
          end

          parsed_command
        end

        def consume_data(parser, data)
          if data.respond_to?(:each)
            data.each do |chunk|
              parser << chunk
            end
          else
            parser << data
          end
          parser.finish
        end
      end

      def initialize
        reset
        initialize_hooks
      end

      def <<(chunk)
        @buffer << chunk
        consume_buffer
      end

      def finish
        if @loading
          raise ParseError, "not completed"
        else
          catch do |tag|
            parse_line(@buffer)
          end
        end
      end

      # @overload on_command(command)
      # @overload on_command {|command| }
      def on_command(*arguments, &block)
        if block_given?
          @on_command_hook = block
        else
          @on_command_hook.call(*arguments) if @on_command_hook
        end
      end

      # @overload on_load_start(command)
      # @overload on_load_start {|command| }
      def on_load_start(*arguments, &block)
        if block_given?
          @on_load_start_hook = block
        else
          @on_load_start_hook.call(*arguments) if @on_load_start_hook
        end
      end

      # @overload on_load_value(command)
      # @overload on_load_value {|command| }
      def on_load_value(*arguments, &block)
        if block_given?
          @on_load_value_hook = block
        else
          @on_load_value_hook.call(*arguments) if @on_load_value_hook
        end
      end

      # @overload on_load_complete(command)
      # @overload on_load_complete(command) { }
      def on_load_complete(*arguments, &block)
        if block_given?
          @on_load_complete_hook = block
        else
          @on_load_complete_hook.call(*arguments) if @on_load_complete_hook
        end
      end

      # @overload on_comment(comment)
      # @overload on_comment {|comment| }
      def on_comment(*arguments, &block)
        if block_given?
          @on_comment_hook = block
        else
          @on_comment_hook.call(*arguments) if @on_comment_hook
        end
      end

      private
      def consume_buffer
        catch do |tag|
          loop do
            if @loading
              consume_load_values(tag)
            else
              parse_line(consume_line(tag))
            end
          end
        end
      end

      def consume_load_values(tag)
        if @in_load_values
          json, separator, rest = @buffer.partition(/[\]},]/)
          if @load_value_completed
            throw(tag) if separator.empty?
            if separator == ","
              if /\A\s*\z/ =~ json
                @command.original_source << json << separator
                @buffer = rest
                @load_value_completed = false
                return
              else
                raise ParseError, "garbage before value"
              end
            elsif separator == "]"
              if /\A\s*\z/ =~ json
                @command.original_source << json << separator
                @buffer = rest
                on_load_complete(@command)
                reset
                return
              end
            end
            unless /\A\s*[\[\{]/ =~ json
              raise ParseError, "garbage before value"
            end
          end
          @buffer = rest
          parse_json(json)
          if separator.empty?
            throw(tag)
          else
            @load_value_completed = false
            parse_json(separator)
          end
        else
          spaces, start_json, rest = @buffer.partition("[")
          unless /\A\s*\z/ =~ spaces
            raise ParseError, "garbage before JSON"
          end
          if start_json.empty?
            @command.original_source << @buffer
            @buffer.clear
            throw(tag)
          else
            @command.original_source << spaces << start_json
            @buffer = rest
            @json_parser = Yajl::Parser.new
            @json_parser.on_parse_complete = lambda do |value|
              on_load_value(@command, value)
              @load_value_completed = true
            end
            @in_load_values = true
          end
        end
      end

      def parse_json(json)
        @command.original_source << json
        begin
          @json_parser << json
        rescue Yajl::ParseError
          message = "Invalid JSON: #{$!.message}: <#{json}>:\n"
          message << @command.original_source
          raise ParseError.new(message)
        else
        end
      end

      def consume_line(tag)
        current_line, separator, rest = @buffer.partition(/\r?\n/)
        throw(tag) if separator.empty?

        if current_line.end_with?("\\")
          @buffer.sub!(/\\\r?\n/, "")
          consume_line(tag)
        else
          @buffer = rest
          current_line
        end
      end

      def parse_line(line)
        case line
        when /\A\s*\z/
        when /\A\#/
          on_comment($POSTMATCH)
        else
          @command = parse_command(line)
          @command.original_source = line
          process_command
        end
      end

      def process_command
        if @command.name == "load"
          on_load_start(@command)
          if @command[:values]
            values = Yajl::Parser.parse(@command[:values])
            values.each do |value|
              on_load_value(@command, value)
            end
            on_load_complete(@command)
            reset
          else
            @command.original_source << "\n"
            @loading = true
          end
        else
          on_command(@command)
          reset
        end
      end

      def parse_command(input)
        if input.start_with?("/d/")
          parse_uri_path(input)
        else
          parse_command_line(input)
        end
      end

      def parse_uri_path(path)
        name, arguments_string = path.split(/\?/, 2)
        arguments = {}
        if arguments_string
          arguments_string.split(/&/).each do |argument_string|
            key, value = argument_string.split(/\=/, 2)
            arguments[key] = CGI.unescape(value)
          end
        end
        name = name.gsub(/\A\/d\//, '')
        name, output_type = name.split(/\./, 2)
        arguments["output_type"] = output_type if output_type
        command_class = Command.find(name)
        command = command_class.new(name, arguments)
        command.original_format = :uri
        command
      end

      def parse_command_line(command_line)
        name, *arguments = Shellwords.shellwords(command_line)
        pair_arguments = {}
        ordered_arguments = []
        until arguments.empty?
          argument = arguments.shift
          if argument.start_with?("--")
            pair_arguments[argument.sub(/\A--/, "")] = arguments.shift
          else
            ordered_arguments << argument
          end
        end
        command_class = Command.find(name)
        command = command_class.new(name, pair_arguments, ordered_arguments)
        command.original_format = :command
        command
      end

      private
      def reset
        @command = nil
        @loading = false
        @in_load_values = false
        @load_value_completed = false
        @buffer = "".force_encoding("ASCII-8BIT")
      end

      def initialize_hooks
        @on_command_hook = nil
        @on_load_start_hook = nil
        @on_load_value_hook = nil
        @on_load_complete_hook = nil
      end
    end
  end
end
