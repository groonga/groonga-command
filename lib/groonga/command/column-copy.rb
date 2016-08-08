# Copyright (C) 2015-2016  Kouhei Sutou <kou@clear-code.com>
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
    # A command class that represents `column_copy` command.
    #
    # @since 1.1.3
    class ColumnCopy < Base
      class << self
        def command_name
          "column_copy"
        end

        def parameter_names
          [
            :from_table,
            :from_name,
            :to_table,
            :to_name,
          ]
        end
      end

      Command.register(command_name, self)

      # @return [String] `from_table` parameter value.
      #
      # @since 1.1.3
      def from_table
        self[:from_table]
      end

      # @return [String] `from_name` parameter value.
      #
      # @since 1.1.3
      def from_name
        self[:from_name]
      end

      # @return [String] `to_table` parameter value.
      #
      # @since 1.1.3
      def to_table
        self[:to_table]
      end

      # @return [String] `to_name` parameter value.
      #
      # @since 1.1.3
      def to_name
        self[:to_name]
      end
    end
  end
end
