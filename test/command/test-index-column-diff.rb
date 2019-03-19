# Copyright (C) 2019  Kouhei Sutou <kou@clear-code.com>
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

class IndexColumnDiffCommandTest < Test::Unit::TestCase
  private
  def index_column_diff_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::IndexColumnDiff.new(pair_arguments,
                                          ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      table    = "Lexicon"
      name     = "content_index"

      command = index_column_diff_command({}, [table, name])
      assert_equal({
                     :table    => table,
                     :name     => name,
                   },
                   command.arguments)
    end
  end

  class TableTest < self
    def test_reader
      command = index_column_diff_command({"table" => "Lexicon"})
      assert_equal("Lexicon",
                   command.table)
    end
  end

  class NameTest < self
    def test_reader
      command = index_column_diff_command({"name" => "index"})
      assert_equal("index",
                   command.name)
    end
  end
end
