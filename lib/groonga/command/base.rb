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

require "groonga/command/format/uri"
require "groonga/command/format/command"

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

      def key?(name)
        @arguments.key?(normalize_name(name))
      end
      alias_method :has_key?, :key?

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
        Format::URI.new(@name, normalized_arguments).path
      end

      def to_command_format
        Format::Command.new(@name, normalized_arguments).command_line
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

      def normalized_arguments
        @arguments.reject do |_, value|
          value.nil?
        end
      end
    end
  end
end
