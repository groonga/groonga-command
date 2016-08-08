# -*- coding: utf-8 -*-
#
# Copyright (C) 2012-2014  Kouhei Sutou <kou@clear-code.com>
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

class ColumnCreateCommandTest < Test::Unit::TestCase
  private
  def column_create_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::ColumnCreate.new(pair_arguments,
                                       ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      table    = "Lexicon"
      name     = "content_index"
      flags    = "COLUMN_INDEX"
      type     = "Posts"
      source   = "content"

      command = column_create_command({}, [table, name, flags, type, source])
      assert_equal({
                     :table    => table,
                     :name     => name,
                     :flags    => flags,
                     :type     => type,
                     :source   => source,
                   },
                   command.arguments)
    end
  end

  class TableTest < self
    def test_reader
      command = column_create_command({"table" => "Logs"})
      assert_equal("Logs",
                   command.table)
    end
  end

  class FlagsTest < self
    def test_multiple
      command = column_create_command({"flags" => "COLUMN_INDEX|WITH_POSITION"})
      assert_equal(["COLUMN_INDEX", "WITH_POSITION"],
                   command.flags)
    end

    def test_one
      command = column_create_command({"flags" => "COLUMN_VECTOR"})
      assert_equal(["COLUMN_VECTOR"],
                   command.flags)
    end

    def test_no_flags
      command = column_create_command({})
      assert_equal([], command.flags)
    end

    class PredicateTest < self
      data({
             "COLUMN_SCALAR" => {
               :expected => true,
               :flags    => "COLUMN_SCALAR",
             },
             "other flag"   => {
               :expected => false,
               :flags    => "COLUMN_VECTOR",
             }
           })
      def test_column_scalar?(data)
        command = column_create_command({"flags" => data[:flags]})
        assert_equal(data[:expected], command.column_scalar?)
      end

      data({
             "COLUMN_VECTOR" => {
               :expected => true,
               :flags    => "COLUMN_VECTOR",
             },
             "other flag"   => {
               :expected => false,
               :flags    => "COLUMN_INDEX",
             }
           })
      def test_column_vector?(data)
        command = column_create_command({"flags" => data[:flags]})
        assert_equal(data[:expected], command.column_vector?)
      end

      data({
             "COLUMN_INDEX" => {
               :expected => true,
               :flags    => "COLUMN_INDEX",
             },
             "other flag"   => {
               :expected => false,
               :flags    => "COLUMN_SCALAR",
             }
           })
      def test_column_index?(data)
        command = column_create_command({"flags" => data[:flags]})
        assert_equal(data[:expected], command.column_index?)
      end

      data({
             "WITH_SECTION" => {
               :expected => true,
               :flags    => "COLUMN_INDEX|WITH_SECTION",
             },
             "other flag"   => {
               :expected => false,
               :flags    => "COLUMN_INDEX|WITH_WEIGHT",
             }
           })
      def test_with_section?(data)
        command = column_create_command({"flags" => data[:flags]})
        assert_equal(data[:expected], command.with_section?)
      end

      data({
             "WITH_WEIGHT" => {
               :expected => true,
               :flags    => "COLUMN_INDEX|WITH_WEIGHT",
             },
             "other flag"   => {
               :expected => false,
               :flags    => "COLUMN_INDEX|WITH_POSITION",
             }
           })
      def test_with_weight?(data)
        command = column_create_command({"flags" => data[:flags]})
        assert_equal(data[:expected], command.with_weight?)
      end

      data({
             "WITH_POSITION" => {
               :expected => true,
               :flags    => "COLUMN_INDEX|WITH_POSITION",
             },
             "other flag"   => {
               :expected => false,
               :flags    => "COLUMN_INDEX|WITH_SECTION",
             }
           })
      def test_with_position?(data)
        command = column_create_command({"flags" => data[:flags]})
        assert_equal(data[:expected], command.with_position?)
      end
    end
  end

  class TypeTest < self
    def test_reader
      command = column_create_command({"type" => "ShortText"})
      assert_equal("ShortText",
                   command.type)
    end
  end

  class SourcesTest < self
    def test_no_source
      command = column_create_command
      assert_equal([], command.sources)
    end

    def test_empty
      command = column_create_command("source" => "")
      assert_equal([], command.sources)
    end

    def test_one
      command = column_create_command("source" => "title")
      assert_equal(["title"], command.sources)
    end

    def test_multiple
      command = column_create_command("source" => "title, text, comment")
      assert_equal(["title", "text", "comment"],
                   command.sources)
    end
  end
end
