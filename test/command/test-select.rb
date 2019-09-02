# Copyright (C) 2011-2017  Kouhei Sutou <kou@clear-code.com>
# Copyright (C) 2016  Masafumi Yokoyama <yokoyama@clear-code.com>
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

class SelectCommandTest < Test::Unit::TestCase
  private
  def select_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::Select.new(pair_arguments, ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_argument
      table                      = "Users"
      match_columns              = "name * 10 || description"
      query                      = "groonga"
      filter                     = "age >= 18"
      scorer                     = "_score = age"
      sortby                     = "_score"
      output_columns             = "_key, name"
      offset                     = "10"
      limit                      = "20"
      drilldown                  = "name"
      drilldown_sortby           = "_nsubrecs"
      drilldown_output_columns   = "name, _nsubrecs"
      drilldown_offset           = "5"
      drilldown_limit            = "10"
      cache                      = "no"
      match_escalation_threshold = "-1"
      query_expansion            = "deprecated"
      query_flags                = "ALLOW_LEADING_NOT"
      query_expander             = "Terms.synonym"
      adjuster                   = "tag * 10"
      drilldown_calc_types       = "MIN, MAX"
      drilldown_calc_target      = "age"
      drilldown_filter           = "_nsubrecs > 1"
      sort_keys                  = "-_score"
      drilldown_sort_keys        = "-_nsubrecs"

      ordered_arguments = [
        table,
        match_columns,
        query,
        filter,
        scorer,
        sortby,
        output_columns,
        offset,
        limit,
        drilldown,
        drilldown_sortby,
        drilldown_output_columns,
        drilldown_offset,
        drilldown_limit,
        cache,
        match_escalation_threshold,
        query_expansion,
        query_flags,
        query_expander,
        adjuster,
        drilldown_calc_types,
        drilldown_calc_target,
        drilldown_filter,
        sort_keys,
        drilldown_sort_keys,
      ]
      command = select_command({}, ordered_arguments)

      assert_equal({
                     :table                      => table,
                     :match_columns              => match_columns,
                     :query                      => query,
                     :filter                     => filter,
                     :scorer                     => scorer,
                     :sortby                     => sortby,
                     :output_columns             => output_columns,
                     :offset                     => offset,
                     :limit                      => limit,
                     :drilldown                  => drilldown,
                     :drilldown_sortby           => drilldown_sortby,
                     :drilldown_output_columns   => drilldown_output_columns,
                     :drilldown_offset           => drilldown_offset,
                     :drilldown_limit            => drilldown_limit,
                     :cache                      => cache,
                     :match_escalation_threshold => match_escalation_threshold,
                     :query_expansion            => query_expansion,
                     :query_flags                => query_flags,
                     :query_expander             => query_expander,
                     :adjuster                   => adjuster,
                     :drilldown_calc_types       => drilldown_calc_types,
                     :drilldown_calc_target      => drilldown_calc_target,
                     :drilldown_filter           => drilldown_filter,
                     :sort_keys                  => sort_keys,
                     :drilldown_sort_keys        => drilldown_sort_keys,
                   },
                   command.arguments)
    end
  end

  class ScorerTest < self
    def test_reader
      command = select_command(:table  => "Users",
                               :filter => "age<=30",
                               :scorer => "_score = random()")
      assert_equal("_score = random()", command.scorer)
    end
  end

  class FilterTest < self
    def test_parenthesis
      filter = 'geo_in_rectangle(location,' +
                                '"35.73360x139.7394","62614x139.7714") && ' +
                '((type == "たいやき" || type == "和菓子")) && ' +
                 'keyword @ "たいやき" &! keyword @ "白" &! keyword @ "養殖"'
      command = select_command(:table => "Users",
                               :filter => filter)
      assert_equal(['geo_in_rectangle(location,' +
                                     '"35.73360x139.7394","62614x139.7714")',
                     'type == "たいやき"',
                     'type == "和菓子"',
                     'keyword @ "たいやき"',
                     'keyword @ "白"',
                     'keyword @ "養殖"'],
                   command.conditions)
    end

    def test_omitted
      command = select_command(:table => "Users",
                               :filter => nil)
      assert_equal([],
                   command.conditions)
    end
  end

  class SortKeysTest < self
    def test_reader
      command = select_command(:sort_keys => "-_score,_key")
      assert_equal(["-_score", "_key"],
                   command.sort_keys)
    end

    def test_sortby
      command = select_command(:sortby => "-_score,_key")
      assert_equal(["-_score", "_key"],
                   command.sort_keys)
    end
  end

  class DrilldownTest < self
    def test_reader
      command = select_command(:drilldown => "name")
      assert_equal("name", command.drilldown)
    end
  end

  class DrilldownSortbyTest < self
    def test_reader
      command = select_command(:drilldown_sortby => "_nsubrecs")
      assert_equal("_nsubrecs", command.drilldown_sortby)
    end
  end

  class DrilldownOutputColumnsTest < self
    def test_reader
      command = select_command(:drilldown_output_columns => "name, _nsubrecs")
      assert_equal("name, _nsubrecs", command.drilldown_output_columns)
    end
  end

  class DrilldownOffsetTest < self
    def test_reader
      command = select_command(:drilldown_offset => "5")
      assert_equal(5, command.drilldown_offset)
    end
  end

  class DrilldownLimitTest < self
    def test_reader
      command = select_command(:drilldown_limit => "10")
      assert_equal(10, command.drilldown_limit)
    end
  end

  class DrilldownCalcTypesTest < self
    def test_reader
      command = select_command(:drilldown_calc_types => "MIN,AVG")
      assert_equal("MIN,AVG", command.drilldown_calc_types)
    end
  end

  class DrilldownCalcTargetTest < self
    def test_reader
      command = select_command(:drilldown_calc_target => "n_occurred")
      assert_equal("n_occurred", command.drilldown_calc_target)
    end
  end

  class DrilldownFilterTest < self
    def test_reader
      command = select_command(:drilldown_filter => "_nsubrecs > 1")
      assert_equal("_nsubrecs > 1",
                   command.drilldown_filter)
    end
  end

  class DrilldownSortKeysTest < self
    def test_reader
      command = select_command(:drilldown_sort_keys => "-_nsubrecs,_key")
      assert_equal(["-_nsubrecs", "_key"],
                   command.drilldown_sort_keys)
    end

    def test_sortby
      command = select_command(:drilldown_sortby => "-_nsubrecs,_key")
      assert_equal(["-_nsubrecs", "_key"],
                   command.drilldown_sort_keys)
    end
  end

  class LabeledDrilldownsTest < self
    def test_multiple
      parameters = {
        "drilldowns[tag].keys" => "tag",
        "drilldowns[tag].sort_keys" => "-_nsubrecs,_key",
        "drilldowns[tag].output_columns" => "_key,_nsubrecs,_min,_max",
        "drilldowns[tag].offset" => "1",
        "drilldowns[tag].limit" => "10",
        "drilldowns[tag].calc_types" => "MIN,MAX",
        "drilldowns[tag].calc_target" => "_nsubrecs",
        "drilldowns[tag].filter" => "_nsubrecs > 1",

        "drilldowns[author_tag].keys" => "author,tag",
        "drilldowns[author_tag].sort_keys" => "_value.author",
        "drilldowns[author_tag].output_columns" => "_value.author,_nsubrecs",
      }
      command = select_command(parameters)
      drilldowns = {
        "author_tag" => drilldown(:label => "author_tag",
                                  :keys => ["author", "tag"],
                                  :sort_keys => ["_value.author"],
                                  :output_columns => [
                                    "_value.author",
                                    "_nsubrecs",
                                  ]),
        "tag" => drilldown(:label => "tag",
                           :keys => ["tag"],
                           :sort_keys => ["-_nsubrecs", "_key"],
                           :output_columns => [
                             "_key",
                             "_nsubrecs",
                             "_min",
                             "_max",
                           ],
                           :offset => 1,
                           :limit => 10,
                           :calc_types => ["MIN", "MAX"],
                           :calc_target => "_nsubrecs",
                           :filter => "_nsubrecs > 1"),
      }
      assert_equal(drilldowns,
                   command.labeled_drilldowns)
    end

    def drilldown(parameters)
      drilldown = Groonga::Command::Select::Drilldown.new
      parameters.each do |key, value|
        drilldown[key] = value
      end
      drilldown
    end
  end

  class SlicesTest < self
    def test_full
      parameters = {
        "slices[book_alice].match_columns"  => "tag",
        "slices[book_alice].query"          => "Book",
        "slices[book_alice].query_expander" => "Synonyms.tag",
        "slices[book_alice].query_flags"    => "ALLOW_COLUMN|ALLOW_LEADING_NOT",
        "slices[book_alice].filter"         => "user == \"alice\"",
        "slices[book_alice].sort_keys"      => "_score, user",
        "slices[book_alice].offset"         => "10",
        "slices[book_alice].limit"          => "25",
      }
      command = select_command(parameters)

      slices = {
        "book_alice" => slice(:label => "book_alice",
                              :match_columns => "tag",
                              :query => "Book",
                              :query_expander => "Synonyms.tag",
                              :query_flags => [
                                "ALLOW_COLUMN",
                                "ALLOW_LEADING_NOT",
                              ],
                              :filter => "user == \"alice\"",
                              :sort_keys => ["_score", "user"],
                              :offset => 10,
                              :limit => 25),
      }
      assert_equal(slices, command.slices)
    end

    def test_multiple
      parameters = {
        "slices[groonga].query" => "tag:Groonga",
        "slices[rroonga].filter" => "tag == Rroonga",
        "slices[rroonga].sort_keys" => "date",
        "slices[rroonga].output_columns" => "_key, date",
      }
      command = select_command(parameters)

      slices = {
        "groonga" => slice(:label => "groonga",
                           :query => "tag:Groonga"),
        "rroonga" => slice(:label => "rroonga",
                           :filter => "tag == Rroonga",
                           :sort_keys => ["date"],
                           :output_columns => ["_key", "date"]),
      }
      assert_equal(slices, command.slices)
    end

    def slice(parameters)
      slice = Groonga::Command::Select::Slice.new
      slice.labeled_drilldowns = {}
      parameters.each do |key, value|
        slice[key] = value
      end
      slice
    end
  end
end
