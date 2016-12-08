# Copyright (C) 2016  Kouhei Sutou <kou@clear-code.com>
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

require "groonga/command/base"

module Groonga
  module Command
    # A command class that represents `query_expand` command.
    #
    # @since 1.2.1
    class QueryExpand < Base
      class << self
        def command_name
          "query_expand"
        end

        def parameter_names
          [
            :expander,
            :query,
            :flags,
          ]
        end
      end

      Command.register(command_name, self)

      # @return [String] `expander` parameter value.
      #
      # @since 1.2.1
      def expander
        self[:expander]
      end

      # @return [String] `query` parameter value.
      #
      # @since 1.2.1
      def query
        self[:query]
      end

      # @return [Array<String>] `flags` parameter value.
      #
      # @since 1.2.1
      def flags
        @flags ||= flags_value(:flags)
      end

      # @return [Boolean] `true` if `"ALLOW_PRAGMA"` is specified in
      #   {#flags}, `false` otherwise.
      #
      # @since 1.2.1
      def allow_pragma?
        flags.include?("ALLOW_PRAGMA")
      end

      # @return [Boolean] `true` if `"ALLOW_COLUMN"` is specified in
      #   {#flags}, `false` otherwise.
      #
      # @since 1.2.1
      def allow_column?
        flags.include?("ALLOW_COLUMN")
      end

      # @return [Boolean] `true` if `"ALLOW_UPDATE"` is specified in
      #   {#flags}, `false` otherwise.
      #
      # @since 1.2.1
      def allow_update?
        flags.include?("ALLOW_UPDATE")
      end

      # @return [Boolean] `true` if `"ALLOW_LEADING_NOT"` is specified in
      #   {#flags}, `false` otherwise.
      #
      # @since 1.2.1
      def allow_leading_not?
        flags.include?("ALLOW_LEADING_NOT")
      end

      # @return [Boolean] `true` if `"NONE"` is specified in {#flags},
      #   `false` otherwise.
      #
      # @since 1.2.1
      def none?
        flags.include?("NONE")
      end
    end
  end
end
