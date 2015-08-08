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

class ThreadCountCommandTest < Test::Unit::TestCase
  private
  def thread_count_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::ThreadCount.new("thread_count",
                                      pair_arguments,
                                      ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      new_count = "1"

      command = thread_count_command({}, [new_count])
      assert_equal({
                     :new_count => new_count,
                   },
                   command.arguments)
    end
  end

  class NewCountTest < self
    def test_reader
      command = thread_count_command(:new_count => "1")
      assert_equal(1, command.new_count)
    end
  end
end
