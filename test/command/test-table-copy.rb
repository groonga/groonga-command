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

class TableCopyCommandTest < Test::Unit::TestCase
  private
  def table_copy_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::TableCopy.new(pair_arguments,
                                    ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      from_name = "Users"
      to_name   = "TypesUsers"

      command = table_copy_command({},
                                    [
                                      from_name,
                                      to_name,
                                    ])
      assert_equal({
                     :from_name => from_name,
                     :to_name   => to_name,
                   },
                   command.arguments)
    end
  end

  class FromNameTest < self
    def test_reader
      command = table_copy_command(:from_name => "Users")
      assert_equal("Users", command.from_name)
    end
  end

  class ToNameTest < self
    def test_reader
      command = table_copy_command(:to_name => "TypedUsers")
      assert_equal("TypedUsers", command.to_name)
    end
  end
end
