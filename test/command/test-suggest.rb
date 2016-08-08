# -*- coding: utf-8 -*-
#
# Copyright (C) 2013  Kouhei Sutou <kou@clear-code.com>
# Copyright (C) 2012  Haruka Yoshihara <yoshihara@clear-code.com>
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

class SuggestCommandTest < Test::Unit::TestCase
  private
  def suggest_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::Suggest.new(pair_arguments,
                                  ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      types                             = "complete"
      table                             = "Users"
      column                            = "name"
      query                             = "name:@ Ali"
      sortby                            = "_score"
      output_columns                    = "name"
      offset                            = "0"
      limit                             = "5"
      frequency_threshold               = "120"
      conditional_probability_threshold = "0.3"
      prefix_search                     = "yes"
      similar_search                    = "yes"

      ordered_arguments = [
        types,
        table,
        column,
        query,
        sortby,
        output_columns,
        offset,
        limit,
        frequency_threshold,
        conditional_probability_threshold,
        prefix_search,
        similar_search
      ]
      command = suggest_command({}, ordered_arguments)

      expected_arguments = {
        :types                             => types,
        :table                             => table,
        :column                            => column,
        :query                             => query,
        :sortby                            => sortby,
        :output_columns                    => output_columns,
        :offset                            => offset,
        :limit                             => limit,
        :frequency_threshold               => frequency_threshold,
        :conditional_probability_threshold => conditional_probability_threshold,
        :prefix_search                     => prefix_search,
        :similar_search                    => similar_search
      }
      assert_equal(expected_arguments, command.arguments)
    end
  end
end
