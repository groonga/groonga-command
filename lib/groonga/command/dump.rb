# Copyright (C) 2013-2017  Kouhei Sutou <kou@clear-code.com>
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
    class Dump < Base
      class << self
        def command_name
          "dump"
        end

        def parameter_names
          [
            :tables,
            :dump_plugins,
            :dump_schema,
            :dump_records,
            :dump_indexes,
            :dump_configs,
            :sort_hash_table,
          ]
        end
      end

      Command.register(command_name, self)

      def output_type
        :none
      end

      # @return [Boolean] `true` if `sort_hash_table` value is `"yes"`.
      #
      # @since 1.3.4
      def sort_hash_table?
        boolean_value(:sort_hash_table, false)
      end
    end
  end
end
