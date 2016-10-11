# Copyright (C) 2012-2016  Kouhei Sutou <kou@clear-code.com>
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
          ]
        end
      end

      Command.register(command_name, self)

      def sortby
        self[:sortby]
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

      def labeled_drilldowns
        @labeled_drilldowns ||= parse_labeled_drilldowns
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

      class Drilldown < Struct.new(:keys,
                                   :sort_keys,
                                   :output_columns,
                                   :offset,
                                   :limit,
                                   :calc_types,
                                   :calc_target)
      end
    end
  end
end
