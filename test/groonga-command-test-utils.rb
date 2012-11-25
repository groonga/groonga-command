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

    def parse_http_path(command, arguments)
      path = "/d/#{command}.json"
      unless arguments.empty?
        uri_arguments = arguments.collect do |key, value|
          [CGI.escape(key.to_s), CGI.escape(value.to_s)].join("=")
        end
        path << "?"
        path << uri_arguments.join("&")
      end
      Groonga::Command::Parser.parse(path)
    end

    def parse_command_line(command, arguments)
      command_line = "#{command} --output_type json"
      arguments.each do |key, value|
        if /"| / =~ value
          escaped_value = '"' + value.gsub(/"/, '\"') + '"'
        else
          escaped_value = value
        end
        command_line << " --#{key} #{escaped_value}"
      end
      Groonga::Command::Parser.parse(command_line)
    end
  end

  module HTTPCommandParser
    include CommandParser

    private
    def parse(command, arguments={})
      parse_http_path(command, arguments)
    end
  end

  module CommandLineCommandParser
    include CommandParser

    private
    def parse(command, arguments={})
      parse_command_line(command, arguments)
    end
  end
end
