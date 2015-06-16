# Copyright (C) 2015  Kouhei Sutou <kou@clear-code.com>
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
    # A command class that represents `logical_table_remove` command.
    #
    # @since 1.1.3
    class LogicalTableRemove < Base
      Command.register("logical_table_remove", self)

      class << self
        def parameter_names
          [
            :logical_table,
            :shard_key,
            :min,
            :min_border,
            :max,
            :max_border,
          ]
        end
      end

      # @return [String] `logical_table` parameter value.
      #
      # @since 1.1.3
      def logical_table
        self[:logical_table]
      end

      # @return [String] `shard_key` parameter value.
      #
      # @since 1.1.3
      def shard_key
        self[:shard_key]
      end

      # @return [String] `min` parameter value.
      #
      # @since 1.1.3
      def min
        self[:min]
      end

      # @return [String] `min_border` parameter value.
      #
      # @since 1.1.3
      def min_border
        self[:min_border]
      end

      # @return [String] `max` parameter value.
      #
      # @since 1.1.3
      def max
        self[:max]
      end

      # @return [String] `max_border` parameter value.
      #
      # @since 1.1.3
      def max_border
        self[:max_border]
      end
    end
  end
end
