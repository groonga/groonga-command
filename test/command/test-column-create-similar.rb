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

class ColumnCreateSimilarCommandTest < Test::Unit::TestCase
  private
  def column_create_similar_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::ColumnCreateSimilar.new(pair_arguments,
                                              ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      table       = "LexiconSimilar"
      name        = "content_index"
      base_column = "Lexicon.content_index"

      command = column_create_similar_command({},
                                              [
                                                table,
                                                name,
                                                base_column,
                                              ])
      assert_equal({
                     table:       table,
                     name:        name,
                     base_column: base_column,
                   },
                   command.arguments)
    end
  end

  class TableTest < self
    def test_reader
      command = column_create_similar_command({"table" => "LogsSimilar"})
      assert_equal("LogsSimilar", command.table)
    end
  end

  class NameTest < self
    def test_reader
      command = column_create_similar_command({"name" => "message"})
      assert_equal("message", command.name)
    end
  end

  class BaseColumnTest < self
    def test_reader
      command = column_create_similar_command({"base_column" => "Logs.message"})
      assert_equal("Logs.message", command.base_column)
    end
  end
end
