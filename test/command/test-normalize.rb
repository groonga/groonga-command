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

class NormalizeCommandTest < Test::Unit::TestCase
  private
  def normalize_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::Normalize.new(pair_arguments,
                                    ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      normalizer = "NormalizerAuto"
      string     = "AbcDef"
      flags      = "REMOVE_BLANK"

      ordered_arguments = [
        normalizer,
        string,
        flags,
      ]
      command = normalize_command({}, ordered_arguments)
      assert_equal({
                     :normalizer => normalizer,
                     :string     => string,
                     :flags      => flags,
                   },
                   command.arguments)
    end
  end

  class NormalizerTest < self
    def test_reader
      command = normalize_command(:normalizer => "NormalizerAuto")
      assert_equal("NormalizerAuto", command.normalizer)
    end
  end

  class StringTest < self
    def test_reader
      command = normalize_command(:string => "Hello World")
      assert_equal("Hello World", command.string)
    end
  end

  class FlagsTest < self
    def test_nil
      command = normalize_command
      assert_equal([], command.flags)
    end

    def test_empty
      command = normalize_command(:flags => "")
      assert_equal([], command.flags)
    end

    def test_pipe_separator
      command = normalize_command(:flags => "REMOVE_BLANK|WITH_TYPES")
      assert_equal(["REMOVE_BLANK", "WITH_TYPES"], command.flags)
    end

    def test_space_separator
      command = normalize_command(:flags => "REMOVE_BLANK WITH_TYPES")
      assert_equal(["REMOVE_BLANK", "WITH_TYPES"], command.flags)
    end

    def test_spaces_around_separator
      command = normalize_command(:flags => "REMOVE_BLANK | WITH_TYPES")
      assert_equal(["REMOVE_BLANK", "WITH_TYPES"], command.flags)
    end
  end
end
