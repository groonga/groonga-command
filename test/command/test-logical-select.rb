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

class LogicalSelectCommandTest < Test::Unit::TestCase
  private
  def logical_select_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::LogicalSelect.new("logical_select",
                                        pair_arguments,
                                        ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      logical_table              = "Logs"
      shard_key                  = "timestamp",
      min                        = "2015-02-12 00:00:00"
      min_border                 = "include"
      max                        = "2015-02-13 00:00:00"
      max_border                 = "exclude"
      filter                     = "action == 'Shutdown'"
      sortby                     = "_score"
      output_columns             = "_key, name"
      offset                     = "10"
      limit                      = "20"
      drilldown                  = "name"
      drilldown_sortby           = "_nsubrecs"
      drilldown_output_columns   = "name, _nsubrecs"
      drilldown_offset           = "5"
      drilldown_limit            = "10"
      drilldown_calc_types       = "MIN,AVG"
      drilldown_calc_target      = "n_occurred"

      ordered_arguments = [
        logical_table,
        shard_key,
        min,
        min_border,
        max,
        max_border,
        filter,
        sortby,
        output_columns,
        offset,
        limit,
        drilldown,
        drilldown_sortby,
        drilldown_output_columns,
        drilldown_offset,
        drilldown_limit,
        drilldown_calc_types,
        drilldown_calc_target,
      ]
      command = logical_select_command({}, ordered_arguments)
      assert_equal({
                     :logical_table            => logical_table,
                     :shard_key                => shard_key,
                     :min                      => min,
                     :min_border               => min_border,
                     :max                      => max,
                     :max_border               => max_border,
                     :filter                   => filter,
                     :sortby                   => sortby,
                     :output_columns           => output_columns,
                     :offset                   => offset,
                     :limit                    => limit,
                     :drilldown                => drilldown,
                     :drilldown_sortby         => drilldown_sortby,
                     :drilldown_output_columns => drilldown_output_columns,
                     :drilldown_offset         => drilldown_offset,
                     :drilldown_limit          => drilldown_limit,
                     :drilldown_calc_types     => drilldown_calc_types,
                     :drilldown_calc_target    => drilldown_calc_target,
                   },
                   command.arguments)
    end
  end

  class LogicalTableTest < self
    def test_reader
      command = logical_select_command(:logical_table => "Logs")
      assert_equal("Logs", command.logical_table)
    end
  end

  class ShardKeyTest < self
    def test_reader
      command = logical_select_command(:shard_key => "timestamp")
      assert_equal("timestamp", command.shard_key)
    end
  end

  class MinTest < self
    def test_reader
      command = logical_select_command(:min => "2015-02-13 00:00:00")
      assert_equal("2015-02-13 00:00:00", command.min)
    end
  end

  class MaxTest < self
    def test_reader
      command = logical_select_command(:max => "2015-01-26 00:00:00")
      assert_equal("2015-01-26 00:00:00", command.max)
    end
  end

  class MaxBorderTest < self
    def test_reader
      command = logical_select_command(:max_border => "include")
      assert_equal("include", command.max_border)
    end
  end

  class FilterTest < self
    def test_reader
      command = logical_select_command(:filter => "action == 'Shutdown'")
      assert_equal("action == 'Shutdown'", command.filter)
    end
  end

  class SortbyTest < self
    def test_reader
      command = logical_select_command(:sortby => "_score")
      assert_equal("_score", command.sortby)
    end
  end

  class OutputColumnsTest < self
    def test_reader
      command = logical_select_command(:output_columns => "_key, name")
      assert_equal("_key, name", command.output_columns)
    end
  end

  class OffsetTest < self
    def test_reader
      command = logical_select_command(:offset => "10")
      assert_equal(10, command.offset)
    end
  end

  class LimitTest < self
    def test_reader
      command = logical_select_command(:limit => "20")
      assert_equal(20, command.limit)
    end
  end

  class DrilldownTest < self
    def test_reader
      command = logical_select_command(:drilldown => "name")
      assert_equal("name", command.drilldown)
    end
  end

  class DrilldownSortbyTest < self
    def test_reader
      command = logical_select_command(:drilldown_sortby => "_nsubrecs")
      assert_equal("_nsubrecs", command.drilldown_sortby)
    end
  end

  class DrilldownOutputColumnsTest < self
    def test_reader
      command = logical_select_command(:drilldown_output_columns => "name, _nsubrecs")
      assert_equal("name, _nsubrecs", command.drilldown_output_columns)
    end
  end

  class DrilldownOffsetTest < self
    def test_reader
      command = logical_select_command(:drilldown_offset => "5")
      assert_equal(5, command.drilldown_offset)
    end
  end

  class DrilldownLimitTest < self
    def test_reader
      command = logical_select_command(:drilldown_limit => "10")
      assert_equal(10, command.drilldown_limit)
    end
  end

  class DrilldownCalcTypesTest < self
    def test_reader
      command = logical_select_command(:drilldown_calc_types => "MIN,AVG")
      assert_equal("MIN,AVG", command.drilldown_calc_types)
    end
  end

  class DrilldownCalcTargetTest < self
    def test_reader
      command = logical_select_command(:drilldown_calc_target => "n_occurred")
      assert_equal("n_occurred", command.drilldown_calc_target)
    end
  end
end
