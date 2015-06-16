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

class LogicalTableRemoveCommandTest < Test::Unit::TestCase
  private
  def logical_table_remove_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::LogicalTableRemove.new("logical_table_remove",
                                             pair_arguments,
                                             ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      logical_table  = "Logs"
      shard_key      = "timestamp",
      min            = "2015-02-12 00:00:00"
      min_border     = "include"
      max            = "2015-02-13 00:00:00"
      max_border     = "exclude"

      ordered_arguments = [
        logical_table,
        shard_key,
        min,
        min_border,
        max,
        max_border,
      ]
      command = logical_table_remove_command({}, ordered_arguments)
      assert_equal({
                     :logical_table  => logical_table,
                     :shard_key      => shard_key,
                     :min            => min,
                     :min_border     => min_border,
                     :max            => max,
                     :max_border     => max_border,
                   },
                   command.arguments)
    end
  end

  class LogicalTableTest < self
    def test_reader
      command = logical_table_remove_command(:logical_table => "Logs")
      assert_equal("Logs", command.logical_table)
    end
  end

  class ShardKeyTest < self
    def test_reader
      command = logical_table_remove_command(:shard_key => "timestamp")
      assert_equal("timestamp", command.shard_key)
    end
  end

  class MinTest < self
    def test_reader
      command = logical_table_remove_command(:min => "2015-02-13 00:00:00")
      assert_equal("2015-02-13 00:00:00", command.min)
    end
  end

  class MaxTest < self
    def test_reader
      command = logical_table_remove_command(:max => "2015-01-26 00:00:00")
      assert_equal("2015-01-26 00:00:00", command.max)
    end
  end

  class MaxBorderTest < self
    def test_reader
      command = logical_table_remove_command(:max_border => "include")
      assert_equal("include", command.max_border)
    end
  end
end
