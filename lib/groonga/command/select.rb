# Copyright (C) 2012-2016  Kouhei Sutou <kou@clear-code.com>
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

module Groonga
  module Command
    class Select < Base
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

      def conditions
        @conditions ||= split_filter_conditions
      end

      def drilldowns
        @drilldowns ||= array_value(:drilldown)
      end

      # @return [::Array<String>] The sort keys for drilldowns.
      #
      # @since 1.2.8
      def drilldown_sort_keys
        value = self[:drilldown_sort_keys] || self[:drilldown_sortby] || ""
        parse_array_value(value)
      end

      # @return [::Hash<String, Drilldown>] The labeled drilldowns.
      #
      # @since 1.2.8
      def labeled_drilldowns
        @labeled_drilldowns ||= parse_labeled_drilldowns
      end

      # @return [::Hash<String, Slice>] The slices.
      #
      # @since 1.3.0
      def slices
        @slices ||= parse_slices
      end

      def output_columns
        self[:output_columns]
      end

      private
      def split_filter_conditions
        (filter || "").split(/(?:&&|&!|\|\|)/).collect do |condition|
          condition = condition.strip
          condition = condition.gsub(/\A[\s\(]*/, '')
          condition = condition.gsub(/[\s\)]*\z/, '') unless /\(/ =~ condition
          condition
        end
      end

      def parse_labeled_drilldowns
        raw_labeled_drilldowns = {}
        @arguments.each do |name, value|
          case name.to_s
          when /\Adrilldowns?\[(.+?)\]\.(.+?)\z/
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
          drilldown = Drilldown.new(keys,
                                    sort_keys,
                                    output_columns,
                                    offset,
                                    limit,
                                    calc_types,
                                    calc_target)
          labeled_drilldowns[label] = drilldown
        end
        labeled_drilldowns
      end

      def parse_slices
        raw_slices = {}
        @arguments.each do |name, value|
          case name.to_s
          when /\Aslices?\[(.+?)\]\.(.+?)\z/
            label = $1
            parameter_name = $2
            raw_slices[label] ||= {}
            raw_slices[label][parameter_name] = value
          end
        end
        build_slices(raw_slices)
      end

      def build_slices(raw_slices)
        slices = {}
        raw_slices.each do |label, raw_slice|
          match_columns = raw_slice["match_columns"]
          query = raw_slice["query"]
          query_expander = raw_slice["query_expander"]
          query_flags = parse_flags_value(raw_slice["query_flags"])
          filter = raw_slice["filter"]
          sort_keys = parse_array_value(raw_slice["sort_keys"])
          output_columns = parse_array_value(raw_slice["output_columns"])
          offset = parse_integer_value(raw_slice["offset"])
          limit = parse_integer_value(raw_slice["limit"])
          slices[label] = Slice.new(match_columns,
                                    query,
                                    query_expander,
                                    query_flags,
                                    filter,
                                    sort_keys,
                                    output_columns,
                                    offset,
                                    limit)
        end
        slices
      end

      class Drilldown < Struct.new(:keys,
                                   :sort_keys,
                                   :output_columns,
                                   :offset,
                                   :limit,
                                   :calc_types,
                                   :calc_target)
      end

      # @since 1.3.1
      class Slice < Struct.new(:match_columns,
                               :query,
                               :query_expander,
                               :query_flags,
                               :filter,
                               :sort_keys,
                               :output_columns,
                               :offset,
                               :limit)
      end
    end
  end
end
