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

class RubyLoadCommandTest < Test::Unit::TestCase
  private
  def ruby_load_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::RubyLoad.new(pair_arguments,
                                   ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      path = "my-library.rb"

      ordered_arguments = [
        path,
      ]
      command = ruby_load_command({}, ordered_arguments)
      assert_equal({
                     :path => path,
                   },
                   command.arguments)
    end
  end

  class PathTest < self
    def test_reader
      command = ruby_load_command(:path => "my-library.rb")
      assert_equal("my-library.rb", command.path)
    end
  end
end
