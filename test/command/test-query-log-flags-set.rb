# Copyright (C) 2017  Kouhei Sutou <kou@clear-code.com>
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

class QueryLogFlagsSetCommandTest < Test::Unit::TestCase
  private
  def query_log_flags_set_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::QueryLogFlagsSet.new(pair_arguments,
                                           ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      flags = "COMMAND|RESULT_CODE"

      command = query_log_flags_set_command({},
                                            [
                                              flags,
                                            ])
      assert_equal({
                     :flags => flags,
                   },
                   command.arguments)
    end
  end

  class FlagsTest < self
    def test_reader
      command = query_log_flags_set_command(:flags => "COMMAND|RESULT_CODE")
      assert_equal(["COMMAND", "RESULT_CODE"], command.flags)
    end
  end
end
