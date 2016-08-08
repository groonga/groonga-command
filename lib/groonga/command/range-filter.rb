# Copyright (C) 2015  Kouhei Sutou <kou@clear-code.com>
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
    # A command class that represents `range_filter` command.
    #
    # @since 1.1.0
    class RangeFilter < Base
      class << self
        def command_name
          "range_filter"
        end

        def parameter_names
          [
            :table,
            :column,
            :min,
            :min_border,
            :max,
            :max_border,
            :offset,
            :limit,
            :filter,
            :output_columns,
          ]
        end
      end

      Command.register(command_name, self)

      # @return [String] `table` parameter value.
      #
      # @since 1.1.0
      def table
        self[:table]
      end

      # @return [String] `column` parameter value.
      #
      # @since 1.1.0
      def column
        self[:column]
      end

      # @return [String] `min` parameter value.
      #
      # @since 1.1.0
      def min
        self[:min]
      end

      # @return [String] `min_border` parameter value.
      #
      # @since 1.1.0
      def min_border
        self[:min_border]
      end

      # @return [String] `max` parameter value.
      #
      # @since 1.1.0
      def max
        self[:max]
      end

      # @return [String] `max_border` parameter value.
      #
      # @since 1.1.0
      def max_border
        self[:max_border]
      end

      # @return [Integer] `offset` parameter value.
      #
      # @since 1.1.0
      def offset
        value = self[:offset]
        value = value.to_i unless value.nil?
        value
      end

      # @return [Integer] `limit` parameter value.
      #
      # @since 1.1.0
      def limit
        value = self[:limit]
        value = value.to_i unless value.nil?
        value
      end

      # @return [String] `filter` parameter value.
      #
      # @since 1.1.0
      def filter
        self[:filter]
      end

      # @return [String] `output_columns` parameter value.
      #
      # @since 1.1.0
      def output_columns
        self[:output_columns]
      end
    end
  end
end
