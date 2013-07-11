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
    class TableCreate < Base
      Command.register("table_create", self)

      class << self
        def parameter_names
          [
            :name,
            :flags,
            :key_type,
            :value_type,
            :default_tokenizer,
          ]
        end
      end

      def flags
        @flags ||= (self[:flags] || "").split(/\s*\|\s*/)
      end

      def table_no_key?
        flags.include?("TABLE_NO_KEY")
      end

      def table_hash_key?
        flags.include?("TABLE_HASH_KEY")
      end

      def table_pat_key?
        flags.include?("TABLE_PAT_KEY")
      end

      def table_dat_key?
        flags.include?("TABLE_DAT_KEY")
      end

      def key_with_sis?
        flags.include?("KEY_WITH_SIS")
      end
    end
  end
end
