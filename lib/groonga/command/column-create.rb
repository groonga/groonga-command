# Copyright (C) 2012-2020  Sutou Kouhei <kou@clear-code.com>
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
    class ColumnCreate < Base
      class << self
        def command_name
          "column_create"
        end

        def parameter_names
          [
            :table,
            :name,
            :flags,
            :type,
            :source,
            :path,
          ]
        end
      end

      Command.register(command_name, self)

      # @return [String] table name.
      # @since 1.0.7
      def table
        self[:table]
      end

      # @return [String] The column name.
      #
      # @since 1.2.4
      def name
        self[:name]
      end

      def flags
        @flags ||= flags_value(:flags)
      end

      # @return [String] value type name of the column.
      # @since 1.0.7
      def type
        self[:type]
      end

      # @return [Boolean] true if "COLUMN_SCALAR" is specified in {#flags},
      #   false otherwise.
      # @since 1.0.3
      def column_scalar?
        flags.include?("COLUMN_SCALAR")
      end

      # @return [Boolean] true if "COLUMN_VECTOR" is specified in {#flags},
      #   false otherwise.
      # @since 1.0.3
      def column_vector?
        flags.include?("COLUMN_VECTOR")
      end

      # @return [Boolean] true if "COLUMN_INDEX" is specified in {#flags},
      #   false otherwise.
      # @since 1.0.3
      def column_index?
        flags.include?("COLUMN_INDEX")
      end

      # @return [Boolean] true if "WITH_SECTION" is specified in {#flags},
      #   false otherwise.
      # @since 1.0.3
      def with_section?
        flags.include?("WITH_SECTION")
      end

      # @return [Boolean] true if "WITH_WEIGHT" is specified in {#flags},
      #   false otherwise.
      # @since 1.0.3
      def with_weight?
        flags.include?("WITH_WEIGHT")
      end

      # @return [Boolean] true if "WITH_POSITION" is specified in {#flags},
      #   false otherwise.
      # @since 1.0.3
      def with_position?
        flags.include?("WITH_POSITION")
      end

      # @return [::Array<String>] an array of index sources. If
      #   `source` parameter value is empty or nil, this method
      #   returns an empty array.
      #
      # @since 1.0.7
      def sources
        @sources ||= array_value(:source)
      end

      # @return [String, nil] Path or nil
      # @since 1.5.0
      def path
        self[:path]
      end
    end
  end
end
