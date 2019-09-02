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

class LogicalRangeFilterCommandTest < Test::Unit::TestCase
  private
  def logical_range_filter_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::LogicalRangeFilter.new(pair_arguments,
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
      order          = "ascending"
      offset         = "10"
      limit          = "20"
      filter         = "value == 10"
      output_columns = "_key, timestamp"
      sort_keys      = "timestamp, -_score"

      ordered_arguments = [
        logical_table,
        shard_key,
        min,
        min_border,
        max,
        max_border,
        order,
        offset,
        limit,
        filter,
        output_columns,
        sort_keys,
      ]
      command = logical_range_filter_command({}, ordered_arguments)
      assert_equal({
                     :logical_table  => logical_table,
                     :shard_key      => shard_key,
                     :min            => min,
                     :min_border     => min_border,
                     :max            => max,
                     :max_border     => max_border,
                     :order          => order,
                     :offset         => offset,
                     :limit          => limit,
                     :filter         => filter,
                     :output_columns => output_columns,
                     :sort_keys      => sort_keys,
                   },
                   command.arguments)
    end
  end

  class LogicalTableTest < self
    def test_reader
      command = logical_range_filter_command(:logical_table => "Logs")
      assert_equal("Logs", command.logical_table)
    end
  end

  class ShardKeyTest < self
    def test_reader
      command = logical_range_filter_command(:shard_key => "timestamp")
      assert_equal("timestamp", command.shard_key)
    end
  end

  class MinTest < self
    def test_reader
      command = logical_range_filter_command(:min => "2015-02-13 00:00:00")
      assert_equal("2015-02-13 00:00:00", command.min)
    end
  end

  class MaxTest < self
    def test_reader
      command = logical_range_filter_command(:max => "2015-01-26 00:00:00")
      assert_equal("2015-01-26 00:00:00", command.max)
    end
  end

  class MaxBorderTest < self
    def test_reader
      command = logical_range_filter_command(:max_border => "include")
      assert_equal("include", command.max_border)
    end
  end

  class OrderTest < self
    def test_reader
      command = logical_range_filter_command(:order => "descending")
      assert_equal("descending", command.order)
    end
  end

  class OffsetTest < self
    def test_reader
      command = logical_range_filter_command(:offset => "10")
      assert_equal(10, command.offset)
    end
  end

  class LimitTest < self
    def test_reader
      command = logical_range_filter_command(:limit => "20")
      assert_equal(20, command.limit)
    end
  end

  class FilterTest < self
    def test_reader
      command = logical_range_filter_command(:filter => "value == 10")
      assert_equal("value == 10", command.filter)
    end
  end

  class OutputColumnsTest < self
    def test_reader
      command = logical_range_filter_command(:output_columns => "_key, timestamp")
      assert_equal("_key, timestamp", command.output_columns)
    end
  end

  class SortKeysTest < self
    def test_reader
      command = logical_range_filter_command(:sort_keys => "timestamp, -_score")
      assert_equal(["timestamp", "-_score"], command.sort_keys)
    end
  end
end
