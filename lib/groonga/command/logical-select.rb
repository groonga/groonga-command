# Copyright (C) 2015-2018  Kouhei Sutou <kou@clear-code.com>
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
    # A command class that represents `logical_select` command.
    #
    # @since 1.1.3
    class LogicalSelect < Base
      include Searchable

      class << self
        def command_name
          "logical_select"
        end

        def parameter_names
          [
            :logical_table,
            :shard_key,
            :min,
            :min_border,
            :max,
            :max_border,
            :filter,
            :sortby,
            :output_columns,
            :offset,
            :limit,
            :drilldown,
            :drilldown_sortby,
            :drilldown_output_columns,
            :drilldown_offset,
            :drilldown_limit,
            :drilldown_calc_types,
            :drilldown_calc_target,
          ]
        end
      end

      Command.register(command_name, self)

      # @return [String] `logical_table` parameter value.
      #
      # @since 1.1.3
      def logical_table
        self[:logical_table]
      end

      # @return [String] `shard_key` parameter value.
      #
      # @since 1.1.3
      def shard_key
        self[:shard_key]
      end

      # @return [String] `min` parameter value.
      #
      # @since 1.1.3
      def min
        self[:min]
      end

      # @return [String] `min_border` parameter value.
      #
      # @since 1.1.3
      def min_border
        self[:min_border]
      end

      # @return [String] `max` parameter value.
      #
      # @since 1.1.3
      def max
        self[:max]
      end

      # @return [String] `max_border` parameter value.
      #
      # @since 1.1.3
      def max_border
        self[:max_border]
      end

      # @return [String] `filter` parameter value.
      #
      # @since 1.1.3
      def filter
        self[:filter]
      end

      # @return [String] `sortby` parameter value.
      #
      # @since 1.1.3
      def sortby
        self[:sortby]
      end

      # @return [String] `output_columns` parameter value.
      #
      # @since 1.1.3
      def output_columns
        self[:output_columns]
      end

      # @return [Integer] `offset` parameter value.
      #
      # @since 1.1.3
      def offset
        integer_value(:offset)
      end

      # @return [Integer] `limit` parameter value.
      #
      # @since 1.1.3
      def limit
        integer_value(:limit)
      end

      # @return [String] `drilldown` parameter value.
      #
      # @since 1.1.3
      def drilldown
        self[:drilldown]
      end

      # @return [Array<String>] drilldown keys.
      #
      # @since 1.1.3
      def drilldowns
        @drilldowns ||= array_value(:drilldown)
      end

      # @return [String] `drilldown_sortby` parameter value.
      #
      # @since 1.1.3
      def drilldown_sortby
        self[:drilldown_sortby]
      end

      # @return [String] `drilldown_output_columns` parameter value.
      #
      # @since 1.1.3
      def drilldown_output_columns
        self[:drilldown_output_columns]
      end

      # @return [String] `drilldown_offset` parameter value.
      #
      # @since 1.1.3
      def drilldown_offset
        integer_value(:drilldown_offset)
      end

      # @return [String] `drilldown_limit` parameter value.
      #
      # @since 1.1.3
      def drilldown_limit
        integer_value(:drilldown_limit)
      end

      # @return [String] `drilldown_calc_types` parameter value.
      #
      # @since 1.1.3
      def drilldown_calc_types
        self[:drilldown_calc_types]
      end

      # @return [String] `drilldown_calc_target` parameter value.
      #
      # @since 1.1.3
      def drilldown_calc_target
        self[:drilldown_calc_target]
      end
    end
  end
end
