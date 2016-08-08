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
    # A command class that represents `thread_limit` command.
    #
    # @since 1.1.3
    class ThreadLimit < Base
      class << self
        def command_name
          "thread_limit"
        end

        def parameter_names
          [
            :max,
          ]
        end
      end

      Command.register(command_name, self)

      # @return [Integer] `max` parameter value.
      #
      # @since 1.1.3
      def max
        integer_value(:max)
      end
    end
  end
end
