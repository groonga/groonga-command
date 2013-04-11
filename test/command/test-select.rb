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
  include GroongaCommandTestUtils::CommandLineCommandParser

  def test_ordered_argument
    table = "Users"
    command = parse("select", [table], :output_type => false)

    assert_instance_of(Groonga::Command::Select, command)
    assert_equal({:table => table}, command.arguments)
  end

  def test_scorer
    select = command(:table => "Users",
                     :filter => "age<=30",
                     :scorer => "_score = random()")
    assert_equal("_score = random()", select.scorer)
  end

  private
  def command(arguments)
    Groonga::Command::Select.new("select", arguments)
  end

  class FilterTest < self
    def test_parenthesis
      filter = 'geo_in_rectangle(location,' +
                                '"35.73360x139.7394","62614x139.7714") && ' +
                '((type == "たいやき" || type == "和菓子")) && ' +
                 'keyword @ "たいやき" &! keyword @ "白" &! keyword @ "養殖"'
      select = command(:table => "Users",
                       :filter => filter)
      assert_equal(['geo_in_rectangle(location,' +
                                     '"35.73360x139.7394","62614x139.7714")',
                     'type == "たいやき"',
                     'type == "和菓子"',
                     'keyword @ "たいやき"',
                     'keyword @ "白"',
                     'keyword @ "養殖"'],
                   select.conditions)
    end

    def test_omitted
      select = command(:table => "Users",
                       :filter => nil)
      assert_equal([],
                   select.conditions)
    end
  end
end
