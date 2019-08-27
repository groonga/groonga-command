# Copyright (C) 2015  Hiroshi Hatake <hatake@clear-code.com>
# Copyright (C) 2018  Kouhei Sutou <kou@clear-code.com>
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
require "groonga/command/searchable"

module Groonga
  module Command
    # A command class that represents `logical_range_filter` command.
    #
    # @since 1.1.1
    class LogicalRangeFilter < Base
      include Searchable

      class << self
        def command_name
          "logical_range_filter"
        end

        def parameter_names
          [
            :logical_table,
            :shard_key,
            :min,
            :min_border,
            :max,
            :max_border,
            :order,
            :offset,
            :limit,
            :filter,
            :output_columns,
            :sort_keys,
          ]
        end
      end

      Command.register(command_name, self)

      # @return [String] `logical_table` parameter value.
      #
      # @since 1.1.1
      def logical_table
        self[:logical_table]
      end

      # @return [String] `shard_key` parameter value.
      #
      # @since 1.1.1
      def shard_key
        self[:shard_key]
      end

      # @return [String] `min` parameter value.
      #
      # @since 1.1.1
      def min
        self[:min]
      end

      # @return [String] `min_border` parameter value.
      #
      # @since 1.1.1
      def min_border
        self[:min_border]
      end

      # @return [String] `max` parameter value.
      #
      # @since 1.1.1
      def max
        self[:max]
      end

      # @return [String] `max_border` parameter value.
      #
      # @since 1.1.1
      def max_border
        self[:max_border]
      end

      # @return [String] `order` parameter value.
      #
      # @since 1.1.1
      def order
        self[:order]
      end

      # @return [Integer] `offset` parameter value.
      #
      # @since 1.1.1
      def offset
        value = self[:offset]
        value = value.to_i unless value.nil?
        value
      end

      # @return [Integer] `limit` parameter value.
      #
      # @since 1.1.1
      def limit
        value = self[:limit]
        value = value.to_i unless value.nil?
        value
      end

      # @return [String] `filter` parameter value.
      #
      # @since 1.1.1
      def filter
        self[:filter]
      end

      # @return [String] `output_columns` parameter value.
      #
      # @since 1.1.1
      def output_columns
        self[:output_columns]
      end

      # @return [::Array<String>] The sort keys.
      #
      # @since 1.4.3
      def sort_keys
        parse_array_value(self[:sort_keys] || "")
      end
    end
  end
end
