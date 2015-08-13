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

class ColumnCopyCommandTest < Test::Unit::TestCase
  private
  def column_copy_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::ColumnCopy.new("column_copy",
                                     pair_arguments,
                                     ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      from_table = "Users"
      from_name  = "age_text"
      to_table   = "TypesUsers"
      to_name    = "age_uint8"

      command = column_copy_command({},
                                    [
                                      from_table,
                                      from_name,
                                      to_table,
                                      to_name,
                                    ])
      assert_equal({
                     :from_table => from_table,
                     :from_name  => from_name,
                     :to_table   => to_table,
                     :to_name    => to_name,
                   },
                   command.arguments)
    end
  end

  class FromTableTest < self
    def test_reader
      command = column_copy_command(:from_table => "Users")
      assert_equal("Users", command.from_table)
    end
  end

  class FromNameTest < self
    def test_reader
      command = column_copy_command(:from_name => "age_text")
      assert_equal("age_text", command.from_name)
    end
  end

  class ToTableTest < self
    def test_reader
      command = column_copy_command(:to_table => "TypedUsers")
      assert_equal("TypedUsers", command.to_table)
    end
  end

  class ToNameTest < self
    def test_reader
      command = column_copy_command(:to_name => "age_uint8")
      assert_equal("age_uint8", command.to_name)
    end
  end
end
