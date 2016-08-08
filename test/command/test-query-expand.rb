# Copyright (C) 2016  Kouhei Sutou <kou@clear-code.com>
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

class QueryExpandCommandTest < Test::Unit::TestCase
  private
  def query_expand_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::QueryExpand.new(pair_arguments,
                                      ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      expander = "QueryExpanderTSV"
      query    = "Rroonga"
      flags    = "ALLOW_PRAGMA|ALLOW_COLUMN"

      command = query_expand_command({},
                                     [
                                       expander,
                                       query,
                                       flags,
                                     ])
      assert_equal({
                     :expander => expander,
                     :query    => query,
                     :flags    => flags,
                   },
                   command.arguments)
    end
  end

  class ExpanderTest < self
    def test_reader
      command = query_expand_command(:expander => "QueryExpanderTSV")
      assert_equal("QueryExpanderTSV", command.expander)
    end
  end

  class QueryTest < self
    def test_reader
      command = query_expand_command(:query => "Rroonga")
      assert_equal("Rroonga", command.query)
    end
  end

  class FlagsTest < self
    def test_omitted
      command = query_expand_command
      assert_equal([],
                   command.flags)
    end

    def test_one
      command = query_expand_command(:flags => "ALLOW_COLUMN")
      assert_equal(["ALLOW_COLUMN"],
                   command.flags)
    end

    def test_pipe_separator
      command = query_expand_command(:flags => "ALLOW_UPDATE|ALLOW_COLUMN")
      assert_equal(["ALLOW_UPDATE", "ALLOW_COLUMN"],
                   command.flags)
    end

    def test_pipe_separator_with_space
      command = query_expand_command(:flags => "ALLOW_UPDATE | ALLOW_COLUMN")
      assert_equal(["ALLOW_UPDATE", "ALLOW_COLUMN"],
                   command.flags)
    end

    def test_space_separator
      command = query_expand_command(:flags => "ALLOW_UPDATE ALLOW_COLUMN")
      assert_equal(["ALLOW_UPDATE", "ALLOW_COLUMN"],
                   command.flags)
    end
  end

  class AllowPragmaTest < self
    def test_true
      command = query_expand_command(:flags => "ALLOW_PRAGMA")
      assert do
        command.allow_pragma?
      end
    end

    def test_false
      command = query_expand_command(:flags => "ALLOW_COLUMN")
      assert do
        not command.allow_pragma?
      end
    end
  end

  class AllowColumnTest < self
    def test_true
      command = query_expand_command(:flags => "ALLOW_COLUMN")
      assert do
        command.allow_column?
      end
    end

    def test_false
      command = query_expand_command(:flags => "ALLOW_PRAGMA")
      assert do
        not command.allow_column?
      end
    end
  end

  class AllowUpdateTest < self
    def test_true
      command = query_expand_command(:flags => "ALLOW_UPDATE")
      assert do
        command.allow_update?
      end
    end

    def test_false
      command = query_expand_command(:flags => "ALLOW_PRAGMA")
      assert do
        not command.allow_update?
      end
    end
  end

  class AllowLeadingNotTest < self
    def test_true
      command = query_expand_command(:flags => "ALLOW_LEADING_NOT")
      assert do
        command.allow_leading_not?
      end
    end

    def test_false
      command = query_expand_command(:flags => "ALLOW_PRAGMA")
      assert do
        not command.allow_leading_not?
      end
    end
  end

  class NoneTest < self
    def test_true
      command = query_expand_command(:flags => "NONE")
      assert do
        command.none?
      end
    end

    def test_false
      command = query_expand_command(:flags => "ALLOW_PRAGMA")
      assert do
        not command.none?
      end
    end
  end
end
