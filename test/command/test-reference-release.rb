# Copyright (C) 2020  Sutou Kouhei <kou@clear-code.com>
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

class ReferenceReleaseCommandTest < Test::Unit::TestCase
  private
  def reference_release_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::ReferenceRelease.new(pair_arguments,
                                           ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      target_name = "Users"
      recursive = "no"

      ordered_arguments = [
        target_name,
        recursive,
      ]
      command = reference_release_command({}, ordered_arguments)
      assert_equal({
                     :target_name => target_name,
                     :recursive   => recursive,
                   },
                   command.arguments)
    end
  end

  class TargetNameTest < self
    def test_reader
      command = reference_release_command(:target_name => "Users")
      assert_equal("Users", command.target_name)
    end
  end

  class RecursiveTest < self
    class ReaderTest < self
      def test_default
        command = reference_release_command
        assert do
          command.recursive?
        end
        assert do
          not command.recursive_dependent?
        end
      end

      def test_no
        command = reference_release_command(:recursive => "no")
        assert do
          not command.recursive?
        end
        assert do
          not command.recursive_dependent?
        end
      end

      def test_dependent
        command = reference_release_command(:recursive => "dependent")
        assert do
          command.recursive?
        end
        assert do
          command.recursive_dependent?
        end
      end
    end
  end
end
