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

require "groonga/command/base"
require "groonga/command/select"
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
    class Parser
      class << self
        def parse(input)
          new.parse(input)
        end
      end

      def initialize
      end

      def parse(input)
        if input.start_with?("/d/")
          parse_uri_path(input)
        else
          parse_command_line(input)
        end
      end

      private
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
    end
  end
end
