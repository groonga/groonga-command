# Copyright (C) 2020  Sutou Kouhei <kou@clear-code.com>
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
    # A command class that represents `reference_acquire` command.
    #
    # @since 1.4.9
    class ReferenceAcquire < Base
      class << self
        def command_name
          "reference_acquire"
        end

        def parameter_names
          [
            :target_name,
            :recursive,
          ]
        end
      end

      Command.register(command_name, self)

      # @return [String] `target_name` parameter value.
      #
      # @since 1.4.9
      def target_name
        self[:target_name]
      end

      # @return [String] `recursive` parameter value.
      #
      # @since 1.4.9
      def recursive
        self[:recursive]
      end

      # @return [Boolean] Whether `recursive` parameter value isn't `no`.
      #
      # @since 1.4.9
      def recursive?
        recursive != "no"
      end

      # @return [Boolean] `recursive` parameter value.
      #
      # @since 1.4.9
      def recursive_dependent?
        recursive == "dependent"
      end
    end
  end
end
