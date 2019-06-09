# Copyright (C) 2015-2019  Sutou Kouhei <kou@clear-code.com>
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

class PluginUnregisterCommandTest < Test::Unit::TestCase
  private
  def plugin_unregister_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::PluginUnregister.new(pair_arguments,
                                           ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      name = "query_expanders/tsv"

      ordered_arguments = [
        name,
      ]
      command = plugin_unregister_command({}, ordered_arguments)
      assert_equal({
                     :name => name,
                   },
                   command.arguments)
    end
  end

  class NameTest < self
    def test_reader
      command = plugin_unregister_command(:name => "query_expanders/tsv")
      assert_equal("query_expanders/tsv", command.name)
    end
  end

  class EqualTest < self
    def test_equal
      command1 = plugin_unregister_command(:name => "query_expanders/tsv")
      command2 = plugin_unregister_command(:name => "query_expanders/tsv")
      assert do
        command1 == command2
      end
    end

    def test_not_equal
      command1 = plugin_unregister_command(:name => "query_expanders/tsv")
      command2 = plugin_unregister_command(:name => "functions/vector")
      assert do
        command1 != command2
      end
    end
  end
end
