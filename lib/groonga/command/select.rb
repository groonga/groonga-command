# Copyright (C) 2012-2019  Sutou Kouhei <kou@clear-code.com>
# Copyright (C) 2016  Masafumi Yokoyama <yokoyama@clear-code.com>
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
require "groonga/command/drilldownable"
require "groonga/command/searchable"
require "groonga/command/sliceable"

module Groonga
  module Command
    class Select < Base
      include Drilldownable
      include Searchable
      include Sliceable

      class << self
        def command_name
          "select"
        end

        def parameter_names
          [
            :table,
            :match_columns,
            :query,
            :filter,
            :scorer,
            :sortby,
            :output_columns,
            :offset,
            :limit,
            :drilldown,
            :drilldown_sortby,
            :drilldown_output_columns,
            :drilldown_offset,
            :drilldown_limit,
            :cache,
            :match_escalation_threshold,
            :query_expansion,
            :query_flags,
            :query_expander,
            :adjuster,
            :drilldown_calc_types,
            :drilldown_calc_target,
            :drilldown_filter,
            :sort_keys,
            :drilldown_sort_keys,
          ]
        end
      end

      Command.register(command_name, self)

      # @return [String] The sort keys as String. Each key is
      #   separated by "," or spaces.
      #
      # @deprecated since 1.2.8. Use {#sort_keys} instead.
      def sortby
        self[:sortby]
      end

      # @return [::Array<String>] The sort keys.
      #
      # @since 1.2.8
      def sort_keys
        parse_array_value(self[:sort_keys] || self[:sortby] || "")
      end

      def scorer
        self[:scorer]
      end

      def query
        self[:query]
      end

      def filter
        self[:filter]
      end

      # TODO: We should return `::Array` instead of raw
      #   `output_columns` value. But it breaks backward
      #   compatibility...
      def output_columns
        self[:output_columns]
      end
    end
  end
end
