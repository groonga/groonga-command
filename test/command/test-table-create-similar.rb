# Copyright (C) 2021  Sutou Kouhei <kou@clear-code.com>
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

class TableCreateSimilarCommandTest < Test::Unit::TestCase
  private
  def table_create_similar_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::TableCreateSimilar.new(pair_arguments,
                                             ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      name       = "UsersSimilar"
      base_table = "Users"

      ordered_arguments = [
        name,
        base_table,
      ]
      command = table_create_similar_command({}, ordered_arguments)
      assert_equal({
                     name:       name,
                     base_table: base_table,
                   },
                   command.arguments)
    end
  end

  class NameTest < self
    def test_reader
      command = table_create_similar_command({"name" => "UsersSimilar"})
      assert_equal("UsersSimilar", command.name)
    end
  end

  class BaseTableTest < self
    def test_reader
      command = table_create_similar_command({"base_table" => "Users"})
      assert_equal("Users", command.base_table)
    end
  end
end
