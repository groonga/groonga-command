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

class ColumnRenameCommandTest < Test::Unit::TestCase
  private
  def column_rename_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::ColumnRename.new(pair_arguments,
                                       ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      table    = "Users"
      name     = "name"
      new_name = "nick"

      command = column_rename_command({}, [table, name, new_name])
      assert_equal({
                     :table    => table,
                     :name     => name,
                     :new_name => new_name,
                   },
                   command.arguments)
    end
  end

  class TableTest < self
    def test_reader
      command = column_rename_command({"table" => "Logs"})
      assert_equal("Logs",
                   command.table)
    end
  end

  class NameTest < self
    def test_reader
      command = column_rename_command({"name" => "message"})
      assert_equal("message",
                   command.name)
    end
  end

  class NewNameTest < self
    def test_reader
      command = column_rename_command({"new_name" => "content"})
      assert_equal("content",
                   command.new_name)
    end
  end
end
