# Copyright (C) 2017  Kouhei Sutou <kou@clear-code.com>
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
    # A command class that represents `query_log_flags_remove` command.
    #
    # @since 1.3.3
    class QueryLogFlagsRemove < Base
      class << self
        def command_name
          "query_log_flags_remove"
        end

        def parameter_names
          [
            :flags
          ]
        end
      end

      Command.register(command_name, self)

      # @return [Array<String>] An array of flags specified in `flags`
      #   parameter value. This array is extracted by parsing `flags`
      #   parameter value. If `flags` parameter value is nil or empty,
      #   an empty array is returned.
      #
      # @since 1.3.3
      def flags
        @flags ||= flags_value(:flags)
      end
    end
  end
end
