# Copyright (C) 2012-2016  Kouhei Sutou <kou@clear-code.com>
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
    class TableRemove < Base
      Command.register("table_remove", self)

      class << self
        def parameter_names
          [
            :name,
            :recursive,
          ]
        end
      end

      # @return [String] `name` parameter value.
      #
      # @since 1.1.8
      def name
        self[:name]
      end

      # @return [Boolean] `recursive` parameter value.
      #
      # @since 1.1.8
      def recursive?
        self[:recursive] != "no"
      end
    end
  end
end
