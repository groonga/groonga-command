# Copyright (C) 2012-2018  Kouhei Sutou <kou@clear-code.com>
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

class TruncateCommandTest < Test::Unit::TestCase
  private
  def truncate_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::Truncate.new(pair_arguments,
                                   ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      target_name = "Users"

      command = truncate_command([], [target_name])
      assert_equal({
                     :target_name => target_name,
                   },
                   command.arguments)
    end
  end

  class TargetNameTest < self
    def test_nil
      command = truncate_command
      assert_nil(command.target_name)
    end

    def test_specified
      command = truncate_command(:target_name => "Users")
      assert_equal("Users", command.target_name)
    end

    def test_table
      command = truncate_command(:table => "Users")
      assert_equal("Users", command.target_name)
    end
  end
end
