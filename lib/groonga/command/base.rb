# -*- coding: utf-8 -*-
#
# Copyright (C) 2012  Kouhei Sutou <kou@clear-code.com>
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
      attr_reader :name, :parameters
      attr_accessor :original_format
      def initialize(name, parameters)
        @name = name
        @parameters = parameters
        @original_format = nil
      end

      def ==(other)
        other.is_a?(self.class) and
          @name == other.name and
          @parameters == other.parameters
      end

      def uri_format?
        @original_format == :uri
      end

      def command_format?
        @original_format == :command
      end

      def to_uri_format
        path = "/d/#{@name}"
        parameters = @parameters.dup
        output_type = parameters.delete("output_type")
        path << ".#{output_type}" if output_type
        unless parameters.empty?
          sorted_parameters = parameters.sort_by do |name, _|
            name.to_s
          end
          uri_parameters = sorted_parameters.collect do |name, value|
            "#{CGI.escape(name)}=#{CGI.escape(value)}"
          end
          path << "?"
          path << uri_parameters.join("&")
        end
        path
      end

      def to_command_format
        command_line = [@name]
        sorted_parameters = @parameters.sort_by do |name, _|
          name.to_s
        end
        sorted_parameters.each do |name, value|
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
    end
  end
end
