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

class TableTokenizeCommandTest < Test::Unit::TestCase
  private
  def table_tokenize_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::TableTokenize.new(pair_arguments,
                                        ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      table  = "Lexicon"
      string = "groonga ruby linux"
      flags  = "NONE"
      mode   = "ADD"

      ordered_arguments = [
        table,
        string,
        flags,
        mode,
      ]
      command = table_tokenize_command({}, ordered_arguments)
      assert_equal({
                     :table  => table,
                     :string => string,
                     :flags  => flags,
                     :mode   => mode,
                   },
                   command.arguments)
    end
  end

  class TableTest < self
    def test_reader
      command = table_tokenize_command(:table => "Lexicon")
      assert_equal("Lexicon", command.table)
    end
  end

  class StringTest < self
    def test_reader
      command = table_tokenize_command(:string => "Hello World")
      assert_equal("Hello World", command.string)
    end
  end

  class FlagsTest < self
    def test_nil
      command = table_tokenize_command
      assert_equal([], command.flags)
    end

    def test_empty
      command = table_tokenize_command(:flags => "")
      assert_equal([], command.flags)
    end

    def test_pipe_separator
      flags = "NONE|ENABLE_TOKENIZED_DELIMITER"
      command = table_tokenize_command(:flags => flags)
      assert_equal(["NONE", "ENABLE_TOKENIZED_DELIMITER"], command.flags)
    end

    def test_space_separator
      flags = "NONE ENABLE_TOKENIZED_DELIMITER"
      command = table_tokenize_command(:flags => flags)
      assert_equal(["NONE", "ENABLE_TOKENIZED_DELIMITER"], command.flags)
    end

    def test_spaces_around_separator
      flags = "NONE | ENABLE_TOKENIZED_DELIMITER"
      command = table_tokenize_command(:flags => flags)
      assert_equal(["NONE", "ENABLE_TOKENIZED_DELIMITER"], command.flags)
    end
  end

  class ModeTest < self
    def test_reader
      command = table_tokenize_command(:mode => "ADD")
      assert_equal("ADD", command.mode)
    end
  end
end
