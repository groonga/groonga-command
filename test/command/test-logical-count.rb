# Copyright (C) 2015  Hiroshi Hatake <hatake@clear-code.com>
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

class LogicalCountCommandTest < Test::Unit::TestCase
  private
  def logical_count_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::LogicalCount.new("logical_count",
                                       pair_arguments,
                                       ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      logical_table  = "Logs"
      shard_key      = "timestamp"
      min            = "2015-02-12 00:00:00"
      min_border     = "include"
      max            = "2015-02-13 00:00:00"
      max_border     = "exclude"
      filter         = "message == \"Shutdown\""

      ordered_arguments = [
        logical_table,
        shard_key,
        min,
        min_border,
        max,
        max_border,
        filter,
      ]
      command = logical_count_command({}, ordered_arguments)
      assert_equal({
                     :logical_table  => logical_table,
                     :shard_key      => shard_key,
                     :min            => min,
                     :min_border     => min_border,
                     :max            => max,
                     :max_border     => max_border,
                     :filter         => filter,
                   },
                   command.arguments)
    end
  end

  class TableTest < self
    def test_reader
      command = logical_count_command(:logical_table => "Logs")
      assert_equal("Logs", command.logical_table)
    end
  end

  class ColumnTest < self
    def test_reader
      command = logical_count_command(:shard_key => "timestamp")
      assert_equal("timestamp", command.shard_key)
    end
  end

  class MinTest < self
    def test_reader
      command = logical_count_command(:min => "2015-02-13 00:00:00")
      assert_equal("2015-02-13 00:00:00", command.min)
    end
  end

  class MinBorderTest < self
    def test_reader
      command = logical_count_command(:min_border => "include")
      assert_equal("include", command.min_border)
    end
  end

  class MaxTest < self
    def test_reader
      command = logical_count_command(:max => "2015-02-13 00:00:00")
      assert_equal("2015-02-13 00:00:00", command.max)
    end
  end

  class FilterTest < self
    def test_reader
      command = logical_count_command(:filter => "message == \"Shutdown\"")
      assert_equal("message == \"Shutdown\"", command.filter)
    end
  end
end
