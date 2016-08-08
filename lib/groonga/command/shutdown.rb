# Copyright (C) 2016  Kouhei Sutou <kou@clear-code.com>
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
    # A command class that represents `shutdown` command.
    #
    # @since 1.1.8
    class Shutdown < Base
      class << self
        def command_name
          "shutdown"
        end

        def parameter_names
          [
            :mode,
          ]
        end
      end

      Command.register(command_name, self)

      # @return [String] `mode` parameter value.
      #
      # @since 1.1.8
      def mode
        self[:mode]
      end
    end
  end
end
