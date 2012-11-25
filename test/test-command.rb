# -*- coding: utf-8 -*-
#
# Copyright (C) 2011-2012  Kouhei Sutou <kou@clear-code.com>
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

class CommandTest < Test::Unit::TestCase
  class ConvertTest < self
    def test_to_uri_format
      select = Groonga::Command::Base.new("select",
                                          :table => "Users",
                                          :filter => "age<=30")
      assert_equal("/d/select.json?filter=age%3C%3D30&table=Users",
                   select.to_uri_format)
    end

    def test_to_command_format
      select = Groonga::Command::Base.new("select",
                                          :table => "Users",
                                          :filter => "age<=30")
      assert_equal("select --filter \"age<=30\" " +
                     "--output_type \"json\" --table \"Users\"",
                   select.to_command_format)
    end
  end
end
