# Copyright (C) 2012-2017  Kouhei Sutou <kou@clear-code.com>
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

require "json"

require "groonga/command/base"

module Groonga
  module Command
    class Load < Base
      class << self
        def command_name
          "load"
        end

        def parameter_names
          [
            :values,
            :table,
            :columns,
            :ifexists,
            :input_type,
            :each,
            :output_ids,
          ]
        end
      end

      Command.register(command_name, self)

      attr_writer :table
      attr_writer :values
      attr_writer :columns
      def initialize(*argumetns)
        super
        @table = nil
        @values = nil
        @columns = nil
      end

      # @return [String] The table name to be loaded.
      #
      # @since 1.3.5
      def table
        @table ||= self[:table]
      end

      def values
        @values ||= parse_values(self[:values])
      end

      def columns
        @columns ||= parse_columns(self[:columns])
      end

      # @return [Boolean] `true` if `output_ids` value is `"yes"`.
      #
      # @since 1.3.0
      def output_ids?
        boolean_value(:output_ids, false)
      end

      private
      def parse_values(values)
        return values if values.nil?
        JSON.parse(values)
      end

      def parse_columns(columns)
        return columns if columns.nil?
        columns.split(/\s*,\s*/)
      end
    end
  end
end
