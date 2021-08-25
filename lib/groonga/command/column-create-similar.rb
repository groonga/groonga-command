# Copyright (C) 2021  Sutou Kouhei <kou@clear-code.com>
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
    class ColumnCreateSimilar < Base
      class << self
        def command_name
          "column_create_similar"
        end

        def parameter_names
          [
            :table,
            :name,
            :base_column,
          ]
        end
      end

      Command.register(command_name, self)

      # @return [String] table name.
      #
      # @since 1.5.2
      def table
        self[:table]
      end

      # @return [String] The column name.
      #
      # @since 1.5.2
      def name
        self[:name]
      end

      # @return [String] The base column name.
      #
      # @since 1.5.2
      def base_column
        self[:base_column]
      end
    end
  end
end
