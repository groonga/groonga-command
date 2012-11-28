# -*- coding: utf-8 -*-
#
# Copyright (C) 2012  Kouhei Sutou <kou@clear-code.com>
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
    class Load < Base
      Command.register("load", self)

      class << self
        def parameter_names
          [
            :values,
            :table,
            :columns,
            :ifexists,
            :input_type,
            :each,
          ]
        end
      end

      attr_writer :columns
      def initialize(*argumetns)
        super
        @columns = nil
      end

      def columns
        @columns ||= parse_columns(self[:columns])
      end

      private
      def parse_columns(columns)
        return columns if columns.nil?
        columns.split(/\s*,\s*/)
      end
    end
  end
end
