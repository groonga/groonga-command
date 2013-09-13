# -*- coding: utf-8 -*-
#
# Copyright (C) 2013  Kouhei Sutou <kou@clear-code.com>
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

class CommandFormatTest < Test::Unit::TestCase
  class EscapeValueTest < self
    test '\n' do
      assert_equal('"\\n"', escape_value("\n"))
    end

    test '"' do
      assert_equal('"\\""', escape_value("\""))
    end

    test "\\" do
      assert_equal('"\\\\"', escape_value("\\"))
    end

    def escape_value(value)
      Groonga::Command::Format::Command.escape_value(value)
    end
  end
end
