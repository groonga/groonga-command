# Copyright (C) 2012-2017  Kouhei Sutou <kou@clear-code.com>
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
      def all
        @@registered_commands
      end

      def register(name, klass)
        @@registered_commands[normalize_name(name)] = klass
      end

      def find(name)
        @@registered_commands[normalize_name(name)] || Base
      end

      private
      def normalize_name(name)
        case name
        when String
          name.to_sym
        else
          name
        end
      end
    end

    class Base
      class << self
        def parameter_names
          []
        end
      end

      # @return [String] The command name.
      #
      # @since 1.1.8
      attr_reader :command_name
      attr_reader :arguments
      attr_accessor :original_format, :original_source, :path_prefix

      # @overload initialize(pair_arguments, ordered_arguments={})
      #   Initializes a new known command. The command class must implement
      #   {.command_name} method.
      #
      #   @param pair_arguments [::Hash<String, String>] The list of
      #     pair arguments.
      #
      #   @param ordered_arguments [::Array<String>] The list of
      #     ordered arguments.
      #
      #   @since 1.2.3
      #
      # @overload initialize(command_name, pair_arguments, ordered_arguments={})
      #   Initializes a new unknown command.
      #
      #   @param command_name [String] The command name.
      #
      #   @param pair_arguments [::Hash<String, String>] The list of
      #     pair arguments.
      #
      #   @param ordered_arguments [::Array<String>] The list of
      #     ordered arguments.
      def initialize(arg1=nil, arg2=nil, arg3=nil)
        case arg1
        when String, Symbol
          command_name = arg1.to_s
          pair_arguments = arg2
          ordered_arguments = arg3
        else
          command_name = self.class.command_name
          pair_arguments = arg1
          ordered_arguments = arg2
        end
        pair_arguments ||= {}
        ordered_arguments ||= []

        @command_name = command_name
        @arguments = construct_arguments(pair_arguments, ordered_arguments)
        @original_format = nil
        @original_source = nil
        @path_prefix = "/d/"
      end

      # @deprecated since 1.1.8. Use {#command_name} instead.
      def name
        command_name
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
          @command_name == other.name and
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

      # @return [String, nil] `request_id` parameter value.
      #
      # @since 1.1.8
      def request_id
        self[:request_id]
      end

      def to_uri_format
        Format::URI.new(@path_prefix, @command_name, normalized_arguments).path
      end

      def to_command_format(options={})
        format = Format::Command.new(@command_name, normalized_arguments)
        format.command_line(options)
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

      def integer_value(name)
        parse_integer_value(self[name])
      end

      def parse_integer_value(value)
        return value if value.nil?
        return nil if value.empty?

        begin
          Integer(value)
        rescue ArgumentError
          value
        end
      end

      def array_value(name)
        parse_array_value(self[name] || "")
      end

      def parse_array_value(value)
        return nil if value.nil?
        value.strip.split(/\s*,\s*/)
      end

      def flags_value(name)
        parse_flags_value(self[name] || "")
      end

      def parse_flags_value(value)
        return nil if value.nil?
        value.strip.split(/\s*[| ]\s*/)
      end
    end
  end
end
