# Copyright (C) 2016-2023  Sutou Kouhei <kou@clear-code.com>
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

class ObjectRemoveCommandTest < Test::Unit::TestCase
  private
  def object_remove_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::ObjectRemove.new(pair_arguments,
                                       ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      name = "Users"
      force = "yes"

      command = object_remove_command({}, [name, force])
      assert_equal({
                     :name  => name,
                     :force => force,
                   },
                   command.arguments)
    end
  end

  class NameTest < self
    def test_reader
      command = object_remove_command(:name => "Users")
      assert_equal("Users", command.name)
    end
  end

  class ForceTest < self
    def test_reader_yes
      command = object_remove_command(:force => "yes")
      assert_true(command.force?)
    end

    def test_reader_true
      command = object_remove_command(force: "true")
      assert_true(command.force?)
    end
  end
end
