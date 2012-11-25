# -*- coding: utf-8 -*-
#
# Copyright (C) 2012  Kouhei Sutou <kou@clear-code.com>
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

class LoadCommandTest < Test::Unit::TestCase
  class CommandLineTest < self
    include GroongaCommandTestUtils::CommandLineCommandParser

    def test_ordered_arguments
      values     = "[[\"Alice\"], [\"Bob\"]]"
      table      = "Users"
      columns    = "_key"
      ifexists   = "_key == \"Alice\""
      input_type = "json"
      each       = "strlen(_key)"

      command = parse(values, table, columns, ifexists, input_type, each)
      assert_instance_of(Groonga::Command::Load, command)
      assert_equal({
                     :values     => values,
                     :table      => table,
                     :columns    => columns,
                     :ifexists   => ifexists,
                     :input_type => input_type,
                     :each       => each,
                   },
                   command.arguments)
    end

    private
    def parse(*arguments)
      super("load", arguments, :output_type => false)
    end
  end
end
