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

require "cgi"
require "stringio"

require "groonga/command"

module GroongaCommandTestUtils
  module CommandParser
    private
    def command(name, arguments)
      Groonga::Command.find(name).new(name, arguments)
    end

    def parse_http_path(command, arguments, options={})
      path = "/d/#{command}"
      case options[:output_type]
      when false
      when nil
        path << ".json"
      else
        path << ".#{options[:output_type]}"
      end

      unless arguments.empty?
        uri_arguments = arguments.collect do |key, value|
          [CGI.escape(key.to_s), CGI.escape(value.to_s)].join("=")
        end
        path << "?"
        path << uri_arguments.join("&")
      end

      Groonga::Command::Parser.parse(path)
    end

    def parse_command_line(command, arguments, options={})
      command_line = "#{command}"
      case options[:output_type]
      when false
      when nil
        command_line << " --output_type json"
      else
        command_line << " --output_type #{options[:output_type]}"
      end

      if arguments.is_a?(Hash)
        arguments.each do |key, value|
          escaped_value = escape_command_line_value(value)
          command_line << " --#{key} #{escaped_value}"
        end
      else
        arguments.each do |argument|
          command_line << " #{escape_command_line_value(argument)}"
        end
      end

      Groonga::Command::Parser.parse(command_line)
    end

    def escape_command_line_value(value)
      if /"| / =~ value
        '"' + value.gsub(/"/, '\"') + '"'
      else
        value
      end
    end
  end

  module HTTPCommandParser
    include CommandParser

    private
    def parse(command, arguments={}, options={})
      parse_http_path(command, arguments, options)
    end
  end

  module CommandLineCommandParser
    include CommandParser

    private
    def parse(command, arguments={}, options={})
      parse_command_line(command, arguments, options)
    end
  end
end
