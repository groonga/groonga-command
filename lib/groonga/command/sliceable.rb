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
    module Sliceable
      # @return [::Hash<String, Slice>] The slices.
      #
      # @since 1.3.0
      def slices
        @slices ||= parse_slices
      end

      private
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
          labeled_drilldowns = parse_labeled_drilldowns("slices[#{label}].")
          slices[label] = Slice.new(label,
                                    match_columns,
                                    query,
                                    query_expander,
                                    query_flags,
                                    filter,
                                    sort_keys,
                                    output_columns,
                                    offset,
                                    limit,
                                    labeled_drilldowns)
        end
        slices
      end

      # @since 1.3.1
      class Slice < Struct.new(:label,
                               :match_columns,
                               :query,
                               :query_expander,
                               :query_flags,
                               :filter,
                               :sort_keys,
                               :output_columns,
                               :offset,
                               :limit,
                               :labeled_drilldowns)
      end
    end
  end
end
