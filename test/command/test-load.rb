# Copyright (C) 2012-2020  Sutou Kouhei <kou@clear-code.com>
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

class LoadCommandTest < Test::Unit::TestCase
  private
  def load_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::Load.new(pair_arguments,
                               ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      values     = "[[\"Alice\"], [\"Bob\"]]"
      table      = "Users"
      columns    = "_key"
      ifexists   = "_key == \"Alice\""
      input_type = "json"
      each       = "strlen(_key)"
      output_ids = "no"

      ordered_arguments = [
        values,
        table,
        columns,
        ifexists,
        input_type,
        each,
        output_ids,
      ]
      command = load_command({}, ordered_arguments)
      assert_equal({
                     :values     => values,
                     :table      => table,
                     :columns    => columns,
                     :ifexists   => ifexists,
                     :input_type => input_type,
                     :each       => each,
                     :output_ids => output_ids,
                   },
                   command.arguments)
    end
  end

  class TableTest < self
    def test_nil
      command = load_command
      assert_nil(command.table)
    end

    def test_specified
      command = load_command(:table => "Users")
      assert_equal("Users", command.table)
    end
  end

  class ValuesTest < self
    def test_nil
      command = load_command
      assert_nil(command.values)
    end

    def test_empty
      command = load_command(:values => "[]")
      assert_equal([], command.values)
    end

    def test_array
      command = load_command(:values => "[[\"Alice\"]]")
      assert_equal([["Alice"]], command.values)
    end

    def test_object_literal
      command = load_command(:values => "[{\"key\": \"Alice\"}]")
      assert_equal([{"key" => "Alice"}], command.values)
    end

    def test_writer
      command = load_command(:values => "[{\"key\": \"Alice\"}]")
      command.values = [["Alice"]]
      assert_equal({
                     :reader          => [["Alice"]],
                     :array_reference => "[{\"key\": \"Alice\"}]",
                   },
                   {
                     :reader          => command.values,
                     :array_reference => command[:values],
                   })
    end
  end

  class OutputIDsTest < self
    def test_specified
      command = load_command({"output_ids" => "yes"})
      assert do
        command.output_ids?
      end
    end

    def test_omitted
      command = load_command
      assert do
        not command.output_ids?
      end
    end
  end

  sub_test_case("#build_arrow_table") do
    def setup
      omit("red-arrow is needed") unless defined?(Arrow)
    end

    sub_test_case("Array") do
      def test_no_columns_argument
        command = load_command({"values" => [
                                  ["column1", "column2"],
                                  ["value1", "value2"],
                                ].to_json})
        assert_equal(Arrow::Table.new({
                                        "column1" => ["value1"],
                                        "column2" => ["value2"],
                                      }),
                     command.build_arrow_table)
      end

      def test_columns_argument
        command = load_command({"columns" => ["column1", "column2"].join(", "),
                                "values" => [
                                  ["value1", "value2"],
                                ].to_json})
        assert_equal(Arrow::Table.new({
                                        "column1" => ["value1"],
                                        "column2" => ["value2"],
                                      }),
                     command.build_arrow_table)
      end
    end

    sub_test_case("Hash") do
      def test_integer
        command = load_command({"values" => [
                                  {
                                    "column1" => 1,
                                    "column2" => 2,
                                  },
                                  {
                                    "column1" => 10,
                                    "column2" => 20,
                                  },
                                ].to_json})
        columns = {
          "column1" => Arrow::Int64Array.new([1, 10]),
          "column2" => Arrow::Int64Array.new([2, 20]),
        }
        assert_equal(Arrow::Table.new(columns),
                     command.build_arrow_table)
      end
    end
  end
end
