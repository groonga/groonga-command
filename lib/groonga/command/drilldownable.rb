# Copyright (C) 2019  Sutou Kouhei <kou@clear-code.com>
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

module Groonga
  module Command
    module Drilldownable
      # @return [String] `drilldown` parameter value.
      #
      # @since 1.1.3
      def drilldown
        self[:drilldown]
      end

      def drilldowns
        @drilldowns ||= array_value(:drilldown)
      end

      # @return [String, nil] The filter for the drilled down result.
      #
      # @since 1.3.3
      def drilldown_filter
        self[:drilldown_filter]
      end

      # @return [String] `drilldown_sortby` parameter value.
      #
      # @since 1.1.3
      #
      # @deprecated since 1.4.4. Use `drilldown_sort_keys` instead.
      def drilldown_sortby
        self[:drilldown_sortby]
      end

      # @return [::Array<String>] The sort keys for drilldowns.
      #
      # @since 1.2.8
      def drilldown_sort_keys
        value = self[:drilldown_sort_keys] || self[:drilldown_sortby] || ""
        parse_array_value(value)
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

      # @return [::Hash<String, Drilldown>] The labeled drilldowns.
      #
      # @since 1.2.8
      def labeled_drilldowns
        @labeled_drilldowns ||= parse_labeled_drilldowns("")
      end

      private
      def parse_labeled_drilldowns(prefix)
        raw_labeled_drilldowns = {}
        @arguments.each do |name, value|
          case name.to_s
          when /\A#{Regexp.escape(prefix)}drilldowns?\[(.+?)\]\.(.+?)\z/
            label = $1
            parameter_name = $2
            raw_labeled_drilldowns[label] ||= {}
            raw_labeled_drilldowns[label][parameter_name] = value
          end
        end
        build_labeled_drilldowns(raw_labeled_drilldowns)
      end

      def build_labeled_drilldowns(raw_labeled_drilldowns)
        labeled_drilldowns = {}
        raw_labeled_drilldowns.each do |label, raw_drilldown|
          keys = parse_array_value(raw_drilldown["keys"])
          sort_keys = raw_drilldown["sort_keys"] || raw_drilldown["sortby"]
          sort_keys = parse_array_value(sort_keys)
          output_columns = parse_array_value(raw_drilldown["output_columns"])
          offset = parse_integer_value(raw_drilldown["offset"])
          limit = parse_integer_value(raw_drilldown["limit"])
          calc_types = parse_array_value(raw_drilldown["calc_types"])
          calc_target = raw_drilldown["calc_target"]
          filter = raw_drilldown["filter"]
          drilldown = Drilldown.new(keys,
                                    sort_keys,
                                    output_columns,
                                    offset,
                                    limit,
                                    calc_types,
                                    calc_target,
                                    filter,
                                    label)
          labeled_drilldowns[label] = drilldown
        end
        labeled_drilldowns
      end

      class Drilldown < Struct.new(:keys,
                                   :sort_keys,
                                   :output_columns,
                                   :offset,
                                   :limit,
                                   :calc_types,
                                   :calc_target,
                                   :filter,
                                   :label)
      end
    end
  end
end
