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

class TableListCommandTest < Test::Unit::TestCase
  private
  def table_list_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::TableList.new("table_list",
                                    pair_arguments,
                                    ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      prefix = "Logs_2015"

      command = table_list_command({}, [prefix])
      assert_equal({
                     :prefix => prefix,
                   },
                   command.arguments)
    end
  end

  class PrefixTest < self
    def test_reader
      command = table_list_command(:prefix => "Logs_2015")
      assert_equal("Logs_2015", command.prefix)
    end
  end
end
