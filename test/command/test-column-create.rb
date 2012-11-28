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

class ColumnCreateCommandTest < Test::Unit::TestCase
  class CommandLineTest < self
    include GroongaCommandTestUtils::CommandLineCommandParser

    def test_ordered_arguments
      table    = "Lexicon"
      name     = "content_index"
      flags    = "COLUMN_INDEX"
      type     = "Posts"
      source   = "content"

      command = parse(table, name, flags, type, source)
      assert_instance_of(Groonga::Command::ColumnCreate, command)
      assert_equal({
                     :table    => table,
                     :name     => name,
                     :flags    => flags,
                     :type     => type,
                     :source   => source,
                   },
                   command.arguments)
    end

    private
    def parse(*arguments)
      super("column_create", arguments, :output_type => false)
    end
  end
end
