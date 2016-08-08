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
    # A command class that represents `reindex` command.
    #
    # @since 1.1.4
    class Reindex < Base
      class << self
        def command_name
          "reindex"
        end

        def parameter_names
          [
            :target_name,
          ]
        end
      end

      Command.register(command_name, self)

      # @return [String] `target_name` parameter value.
      #
      # @since 1.1.4
      def target_name
        self[:target_name]
      end
    end
  end
end
