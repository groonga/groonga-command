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

class TableRemoveCommandTest < Test::Unit::TestCase
  class CommandLineTest < self
    def test_ordered_arguments
      name = "Users"

      command = parse("table_remove", name)
      assert_instance_of(Groonga::Command::TableRemove, command)
      assert_equal({
                     :name => name,
                   },
                   command.arguments)
    end

    private
    def parse(command, *parameters)
      command_line = "#{command} " + parameters.join(" ")
      Groonga::Command::Parser.parse(command_line)
    end
  end
end
