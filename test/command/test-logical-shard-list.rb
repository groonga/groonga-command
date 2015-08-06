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

class LogicalShardListCommandTest < Test::Unit::TestCase
  private
  def logical_shard_list_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::LogicalShardList.new("logical_shard_list",
                                           pair_arguments,
                                           ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      logical_table = "Logs"

      ordered_arguments = [
        logical_table,
      ]
      command = logical_shard_list_command({}, ordered_arguments)
      assert_equal({
                     :logical_table => logical_table,
                   },
                   command.arguments)
    end
  end

  class LogicalTableTest < self
    def test_reader
      command = logical_shard_list_command(:logical_table => "Logs")
      assert_equal("Logs", command.logical_table)
    end
  end
end
