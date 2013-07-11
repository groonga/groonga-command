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

class TableCreateCommandTest < Test::Unit::TestCase
  class CommandLineTest < self
    include GroongaCommandTestUtils::CommandLineCommandParser

    def test_ordered_arguments
      name              = "Users"
      flags             = "TABLE_PAT_KEY"
      key_type          = "ShortText"
      value_type        = "UInt32"
      default_tokenizer = "TokenBigram"

      command = parse([name, flags, key_type, value_type, default_tokenizer])
      assert_instance_of(Groonga::Command::TableCreate, command)
      assert_equal({
                     :name              => name,
                     :flags             => flags,
                     :key_type          => key_type,
                     :value_type        => value_type,
                     :default_tokenizer => default_tokenizer,
                   },
                   command.arguments)
    end

    private
    def parse(arguments)
      super("table_create", arguments, :output_type => false)
    end

    class FlagsTest < self
      def test_multiple
        command = parse({"flags" => "TABLE_PAT_KEY|KEY_WITH_SIS"})
        assert_equal(["TABLE_PAT_KEY", "KEY_WITH_SIS"],
                     command.flags)
      end

      def test_one
        command = parse({"flags" => "TABLE_NO_KEY"})
        assert_equal(["TABLE_NO_KEY"],
                     command.flags)
      end

      def test_no_flags
        command = parse({})
        assert_equal([], command.flags)
      end

      class PredicateTest < self
        class TableNoKeyTest < self
          data({
              "TABLE_NO_KEY" => {
                :expected => true,
                :flags    => "TABLE_NO_KEY",
              },
              "other flag"   => {
                :expected => false,
                :flags    => "TABLE_HASH_KEY",
              }
            })
          def test_table_no_key?(data)
            command = parse({"flags" => data[:flags]})
            assert_equal(data[:expected], command.table_no_key?)
          end
        end

        class TableHashKeyTest < self
          data({
              "TABLE_HASH_KEY" => {
                :expected => true,
                :flags    => "TABLE_HASH_KEY",
              },
              "other flag"   => {
                :expected => false,
                :flags    => "TABLE_PAT_KEY",
              }
            })
          def test_table_hash_key?(data)
            command = parse({"flags" => data[:flags]})
            assert_equal(data[:expected], command.table_hash_key?)
          end
        end
      end
    end
  end
end
