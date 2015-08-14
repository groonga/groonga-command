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

require "groonga/command/base"

module Groonga
  module Command
    class Select < Base
      Command.register("select", self)

      class << self
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
    end
  end
end
