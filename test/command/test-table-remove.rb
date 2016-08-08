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

class TableRemoveCommandTest < Test::Unit::TestCase
  private
  def table_remove_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::TableRemove.new(pair_arguments,
                                      ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      name = "Users"
      dependent = "yes"

      command = table_remove_command({}, [name, dependent])
      assert_equal({
                     :name => name,
                     :dependent => dependent,
                   },
                   command.arguments)
    end
  end

  class NameTest < self
    def test_reader
      command = table_remove_command(:name => "Users")
      assert_equal("Users", command.name)
    end
  end

  class DependentTest < self
    class ReaderTest < self
      def test_default
        command = table_remove_command
        assert do
          command.dependent?
        end
      end

      def test_no
        command = table_remove_command(:dependent => "no")
        assert do
          not command.dependent?
        end
      end
    end
  end
end
