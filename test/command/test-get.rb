# -*- coding: utf-8 -*-
#
# Copyright (C) 2012  Haruka Yoshihara <yoshihara@clear-code.com>
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

class GetCommandTest < Test::Unit::TestCase
  class CommandLineTest < self
    include GroongaCommandTestUtils::CommandLineCommandParser

    def test_ordered_arguments
      table          = "Users"
      key            = "Alice"
      output_columns = "name, address"

      command = parse(table, key, output_columns)
      assert_instance_of(Groonga::Command::Get, command)

      expected_arguments = {
        :table          => table,
        :key            => key,
        :output_columns => output_columns,
      }
      assert_equal(expected_arguments, command.arguments)
    end

    private
    def parse(*arguments)
      super("get", arguments, :output_type => false)
    end
  end
end
