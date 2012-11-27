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

class ParserTest < Test::Unit::TestCase
  module ParseTests
    def test_parameters
      select = parse("select",
                     :table => "Users",
                     :filter => "age<=30")
      assert_equal(command("select",
                           "table" => "Users",
                           "filter" => "age<=30",
                           "output_type" => "json"),
                   select)
    end
  end

  class HTTPTest < self
    include GroongaCommandTestUtils::HTTPCommandParser

    def test_uri_format?
      command = parse("status")
      assert_predicate(command, :uri_format?)
    end

    def test_command_format?
      command = parse("status")
      assert_not_predicate(command, :command_format?)
    end

    class ParseTest < self
      include ParseTests
    end
  end

  class CommandLineTest < self
    include GroongaCommandTestUtils::CommandLineCommandParser

    def test_uri_format?
      command = parse("status")
      assert_not_predicate(command, :uri_format?)
    end

    def test_command_format?
      command = parse("status")
      assert_predicate(command, :command_format?)
    end

    class ParseTest < self
      include ParseTests
    end

    class EventTest < self
      def setup
        @parser = Groonga::Command::Parser.new
      end

      class CommandTest < self
        def test_newline
          parsed_command = nil
          @parser.on_command do |command|
            parsed_command = command
          end

          @parser << "status"
          assert_nil(parsed_command)
          @parser << "\n"
          assert_equal("status", parsed_command.name)
        end

        def test_finish
          parsed_command = nil
          @parser.on_command do |command|
            parsed_command = command
          end

          @parser << "status"
          assert_nil(parsed_command)
          @parser.finish
          assert_equal("status", parsed_command.name)
        end
      end

      class LoadTest < self
        def setup
          super
          @events = []
          @parser.on_load_start do |command|
            @events << [:load_start, command.original_source.dup]
          end
          @parser.on_load_value do |command, value|
            @events << [:load_value, command.original_source.dup, value]
          end
          @parser.on_load_complete do |command|
            @events << [:load_complete, command.original_source.dup]
          end
        end

        def test_inline
          command_line = "load --values '[{\"_key\": 1}]' --table IDs"
          @parser << command_line
          assert_equal([], @events)
          @parser << "\n"
          assert_equal([
                         [:load_start, command_line],
                         [:load_value, command_line, {"_key" => 1}],
                         [:load_complete, command_line],
                       ],
                       @events)
        end

        def test_bracket
          @parser << <<-EOC
load --table Users
[
["_key", "name"],
["alice", "Alice"]
]
EOC
          expected_events = []
          expected_events << [:load_start, <<-EOC.chomp]
load --table Users
EOC
          # FIXME: It should be stored into command[:columns].
          expected_events << [:load_value, <<-EOC.chomp, ["_key", "name"]]
load --table Users
[
["_key", "name"]
EOC
          expected_events << [:load_value, <<-EOC.chomp, ["alice", "Alice"]]
load --table Users
[
["_key", "name"],
["alice", "Alice"]
EOC
          expected_events << [:load_complete, <<-EOC.chomp]
load --table Users
[
["_key", "name"],
["alice", "Alice"]
]
EOC
          assert_equal(expected_events, @events)
        end

        def test_brace
          @parser << <<-EOC
load --table Users
[
{"_key": "alice", "name": "Alice"},
{"_key": "bob",   "name": "Bob"}
]
EOC
          expected_events = []
          expected_events << [:load_start, <<-EOC.chomp]
load --table Users
EOC
          value = {"_key" => "alice", "name" => "Alice"}
          expected_events << [:load_value, <<-EOC.chomp, value]
load --table Users
[
{"_key": "alice", "name": "Alice"}
EOC
          value = {"_key" => "bob", "name" => "Bob"}
          expected_events << [:load_value, <<-EOC.chomp, value]
load --table Users
[
{"_key": "alice", "name": "Alice"},
{"_key": "bob",   "name": "Bob"}
EOC
          expected_events << [:load_complete, <<-EOC.chomp]
load --table Users
[
{"_key": "alice", "name": "Alice"},
{"_key": "bob",   "name": "Bob"}
]
EOC
          assert_equal(expected_events, @events)
        end
      end

      class CommentTest < self
        def test_newline
          parsed_comment = nil
          @parser.on_comment do |comment|
            parsed_comment = comment
          end

          @parser << "# status"
          assert_nil(parsed_comment)
          @parser << "\n"
          assert_equal(" status", parsed_comment)
        end

        def test_finish
          parsed_comment = nil
          @parser.on_comment do |comment|
            parsed_comment = comment
          end

          @parser << "# status"
          assert_nil(parsed_comment)
          @parser.finish
          assert_equal(" status", parsed_comment)
        end
      end
    end
  end
end
