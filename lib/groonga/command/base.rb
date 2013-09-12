# -*- coding: utf-8 -*-
#
# Copyright (C) 2012-2013  Kouhei Sutou <kou@clear-code.com>
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

require "English"
require "cgi"

module Groonga
  module Command
    class << self
      @@registered_commands = {}
      def register(name, klass)
        @@registered_commands[name] = klass
      end

      def find(name)
        @@registered_commands[name] || Base
      end
    end

    class Base
      class << self
        def parameter_names
          []
        end
      end

      attr_reader :name, :arguments
      attr_accessor :original_format, :original_source
      def initialize(name, pair_arguments, ordered_arguments=[])
        @name = name
        @arguments = construct_arguments(pair_arguments, ordered_arguments)
        @original_format = nil
        @original_source = nil
      end

      def [](name)
        @arguments[normalize_name(name)]
      end

      def []=(name, value)
        @arguments[normalize_name(name)] = value
      end

      def has_key?(name)
        @arguments.has_key?(normalize_name(name))
      end

      def ==(other)
        other.is_a?(self.class) and
          @name == other.name and
          @arguments == other.arguments
      end

      def uri_format?
        @original_format == :uri
      end

      def command_format?
        @original_format == :command
      end

      def output_type
        (self[:output_type] || :json).to_sym
      end

      def to_uri_format
        path = "/d/#{@name}"
        arguments = @arguments.dup
        output_type = arguments.delete(:output_type)
        path << ".#{output_type}" if output_type
        unless arguments.empty?
          sorted_arguments = arguments.sort_by do |name, _|
            name.to_s
          end
          uri_arguments = sorted_arguments.collect do |name, value|
            "#{CGI.escape(name.to_s)}=#{CGI.escape(value)}"
          end
          path << "?"
          path << uri_arguments.join("&")
        end
        path
      end

      def to_command_format
        command_line = [@name]
        sorted_arguments = @arguments.sort_by do |name, _|
          name.to_s
        end
        sorted_arguments.each do |name, value|
          escaped_value = value.gsub(/[\n"\\]/) do
            special_character = $MATCH
            case special_character
            when "\n"
              "\\n"
            else
              "\\#{special_character}"
            end
          end
          command_line << "--#{name}"
          command_line << "\"#{escaped_value}\""
        end
        command_line.join(" ")
      end

      def to_hash
        converted_hash = {}
        self.class.parameter_names.each do |parameter|
          unless self[parameter].nil?
            converted_hash[parameter] = self[parameter]
          end
        end
        converted_hash
      end

      private
      def construct_arguments(pair_arguments, ordered_arguments)
        arguments = {}

        pair_arguments.each do |key, value|
          key = key.to_sym if key.is_a?(String)
          arguments[key] = value
        end

        names = self.class.parameter_names
        ordered_arguments.each_with_index do |argument, i|
          name = names[i]
          break if name.nil?
          name = name.to_sym if name.is_a?(String)
          arguments[name] = argument
        end

        arguments
      end

      def normalize_name(name)
        name = name.to_sym if name.is_a?(String)
        name
      end
    end
  end
end
