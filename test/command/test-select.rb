# -*- coding: utf-8 -*-
#
# Copyright (C) 2011-2013  Kouhei Sutou <kou@clear-code.com>
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
    Groonga::Command::Select.new("select", pair_arguments, ordered_arguments)
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
end
