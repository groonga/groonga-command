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

class RangeFilterCommandTest < Test::Unit::TestCase
  private
  def range_filter_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::RangeFilter.new(pair_arguments,
                                      ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      table          = "Logs"
      column         = "timestamp",
      min            = "2015-01-26 00:00:00"
      min_border     = "include"
      max            = "2015-01-27 00:00:00"
      max_border     = "exclude"
      offset         = "10"
      limit          = "20"
      filter         = "value == 10"
      output_columns = "_key, timestamp"

      ordered_arguments = [
        table,
        column,
        min,
        min_border,
        max,
        max_border,
        offset,
        limit,
        filter,
        output_columns,
      ]
      command = range_filter_command({}, ordered_arguments)
      assert_equal({
                     :table          => table,
                     :column         => column,
                     :min            => min,
                     :min_border     => min_border,
                     :max            => max,
                     :max_border     => max_border,
                     :offset         => offset,
                     :limit          => limit,
                     :filter         => filter,
                     :output_columns => output_columns,
                   },
                   command.arguments)
    end
  end

  class TableTest < self
    def test_reader
      command = range_filter_command(:table => "Logs")
      assert_equal("Logs", command.table)
    end
  end

  class ColumnTest < self
    def test_reader
      command = range_filter_command(:column => "timestamp")
      assert_equal("timestamp", command.column)
    end
  end

  class MinTest < self
    def test_reader
      command = range_filter_command(:min => "2015-01-26 00:00:00")
      assert_equal("2015-01-26 00:00:00", command.min)
    end
  end

  class MinBorderTest < self
    def test_reader
      command = range_filter_command(:min_border => "include")
      assert_equal("include", command.min_border)
    end
  end

  class MaxTest < self
    def test_reader
      command = range_filter_command(:max => "2015-01-26 00:00:00")
      assert_equal("2015-01-26 00:00:00", command.max)
    end
  end

  class MaxBorderTest < self
    def test_reader
      command = range_filter_command(:max_border => "include")
      assert_equal("include", command.max_border)
    end
  end

  class OffsetTest < self
    def test_reader
      command = range_filter_command(:offset => "10")
      assert_equal(10, command.offset)
    end
  end

  class LimitTest < self
    def test_reader
      command = range_filter_command(:limit => "20")
      assert_equal(20, command.limit)
    end
  end

  class FilterTest < self
    def test_reader
      command = range_filter_command(:filter => "value == 10")
      assert_equal("value == 10", command.filter)
    end
  end

  class OutputColumnsTest < self
    def test_reader
      command = range_filter_command(:output_columns => "_key, timestamp")
      assert_equal("_key, timestamp", command.output_columns)
    end
  end
end
