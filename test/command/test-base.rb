# Copyright (C) 2011-2017  Kouhei Sutou <kou@clear-code.com>
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

class BaseCommandTest < Test::Unit::TestCase
  class CovnertToURIFormatTest < self
    def test_no_special_characters
      select = Groonga::Command::Base.new("select",
                                          :table => "Users",
                                          :filter => "age<=30",
                                          :output_type => "json")
      assert_equal("/d/select.json?filter=age%3C%3D30&table=Users",
                   select.to_uri_format)
    end

    def test_double_quote
      filter = 'geo_in_rectangle(location,' +
                                '"35.73360x139.7394","62614x139.7714") && ' +
                 '((type == "たいやき" || type == "和菓子")) && ' +
                 'keyword @ "たいやき" &! keyword @ "白" &! keyword @ "養殖"'
      select = Groonga::Command::Base.new("select",
                                          :table => "Users",
                                          :filter => filter,
                                          :output_type => "json")
      assert_equal("/d/select.json?filter=geo_in_rectangle%28location%2C" +
                   "%2235.73360x139.7394%22%2C%2262614x139.7714%22%29+" +
                   "%26%26+%28%28type+" +
                   "%3D%3D+%22%E3%81%9F%E3%81%84%E3%82%84%E3%81%8D%22+" +
                   "%7C%7C+type+%3D%3D+" +
                   "%22%E5%92%8C%E8%8F%93%E5%AD%90%22%29%29+" +
                   "%26%26+keyword+%40+" +
                   "%22%E3%81%9F%E3%81%84%E3%82%84%E3%81%8D%22+%26%21+" +
                   "keyword+%40+%22%E7%99%BD%22+%26%21+" +
                   "keyword+%40+%22%E9%A4%8A%E6%AE%96%22&table=Users",
                   select.to_uri_format)
    end

    def test_nil
      select = Groonga::Command::Base.new("select",
                                          :table => "Users",
                                          :filter => nil,
                                          :output_type => "json")
      assert_equal("/d/select.json?table=Users",
                   select.to_uri_format)
    end

    def test_path_prefix
      select = Groonga::Command::Base.new("select",
                                          :table => "Users",
                                          :output_type => "json")
      select.path_prefix = "/db1"
      assert_equal("/db1/select.json?table=Users",
                   select.to_uri_format)
    end
  end

  class CovnertToCommandFormatTest < self
    def test_no_special_characters
      select = Groonga::Command::Base.new("select",
                                          :table => "Users",
                                          :filter => "age<=30",
                                          :output_type => "json")
      assert_equal("select --filter \"age<=30\" " +
                     "--output_type \"json\" --table \"Users\"",
                   select.to_command_format)
    end

    def test_double_quote
      filter = 'geo_in_rectangle(location,' +
                                '"35.73360x139.7394","62614x139.7714") && ' +
                 '((type == "たいやき" || type == "和菓子")) && ' +
                 'keyword @ "たいやき" &! keyword @ "白" &! keyword @ "養殖"'
      select = Groonga::Command::Base.new("select",
                                          :table => "Users",
                                          :filter => filter,
                                          :output_type => "json")
      assert_equal("select " +
                     "--filter " +
                       "\"geo_in_rectangle(location," +
                       "\\\"35.73360x139.7394\\\",\\\"62614x139.7714\\\") && " +
                       "((type == \\\"たいやき\\\" || " +
                         "type == \\\"和菓子\\\")) && " +
                       "keyword @ \\\"たいやき\\\" &! keyword @ \\\"白\\\" &! " +
                       "keyword @ \\\"養殖\\\"\" " +
                     "--output_type \"json\" --table \"Users\"",
                   select.to_command_format)
    end

    def test_nil
      select = Groonga::Command::Base.new("select",
                                          :table => "Users",
                                          :filter => nil,
                                          :output_type => "json")
      assert_equal("select --output_type \"json\" --table \"Users\"",
                   select.to_command_format)
    end

    def test_pretty_print
      select = Groonga::Command::Base.new("select",
                                          :table => "Users",
                                          :filter => "_key == 29",
                                          :output_type => "json")
      command = select.to_command_format(:pretty_print => true)
      assert_equal(<<-COMMAND.chomp, command)
select \\
  --filter "_key == 29" \\
  --output_type "json" \\
  --table "Users"
      COMMAND
    end
  end

  class CovnertToElasticsearchFormatTest < self
    sub_test_case("non_target_command") do
      def test_select_command
        select = Groonga::Command::Base.new("select",
                                            :table => "Users",
                                            :filter => "age<=30",
                                            :output_type => "json")
        assert_equal(nil,
                     select.to_elasticsearch_format)
      end
    end

    sub_test_case("single_record") do
      def test_brackets_format
        load = Groonga::Command::Base.new("load",
                                          :table => "Site",
                                          :values => <<-VALUES)
  [
  ["_key","title"],
  ["http://example.org/","This is test record 1!"]
  ]
        VALUES

        expected = <<-OUTPUT
{"index":{"_index":"groonga","_type":"Site"}}
{"_key":"http://example.org/","title":"This is test record 1!"}
        OUTPUT

        assert_equal(expected.chomp, load.to_elasticsearch_format)
      end

      def test_curly_brackets_format
        load = Groonga::Command::Base.new("load",
                                          :table => "Site",
                                          :values => <<-VALUES)
  [
  {"_key": "http://example.org/", "title": "This is test record 1!"}
  ]
        VALUES

        expected = <<-OUTPUT
{"index":{"_index":"groonga","_type":"Site"}}
{"_key":"http://example.org/","title":"This is test record 1!"}
        OUTPUT

        assert_equal(expected.chomp, load.to_elasticsearch_format)
      end
    end

    sub_test_case("multiple_records") do
      def test_brackets_format
        load = Groonga::Command::Base.new("load",
                                          :table => "Site",
                                          :values => <<-VALUES)
  [
  ["_key","title"],
  ["http://example.org/","This is test record 1!"],
  ["http://example.net/","This is test record 2!"]
  ]
        VALUES

        expected = <<-OUTPUT
{"index":{"_index":"groonga","_type":"Site"}}
{"_key":"http://example.org/","title":"This is test record 1!"}
{"_key":"http://example.net/","title":"This is test record 2!"}
        OUTPUT

        assert_equal(expected.chomp, load.to_elasticsearch_format)
      end

      def test_curly_brackets_format
        load = Groonga::Command::Base.new("load",
                                          :table => "Site",
                                          :values => <<-VALUES)
  [
  {"_key": "http://example.org/", "title": "This is test record 1!"},
  {"_key": "http://example.net/", "title": "This is test record 2!"}
  ]
        VALUES

        expected = <<-OUTPUT
{"index":{"_index":"groonga","_type":"Site"}}
{"_key":"http://example.org/","title":"This is test record 1!"}
{"_key":"http://example.net/","title":"This is test record 2!"}
        OUTPUT

        assert_equal(expected.chomp, load.to_elasticsearch_format)
      end
    end
  end

  sub_test_case("#to_s") do
    def setup
      @table = "Users"
      @select = Groonga::Command::Base.new("select", :table => @table)
    end

    def test_uri_format
      @select.original_format = :uri
      assert_equal(@select.to_uri_format,
                   @select.to_s)
    end

    def test_command_format
      @select.original_format = :command
      assert_equal(@select.to_command_format,
                   @select.to_s)
    end

    def test_default
      assert_equal(@select.to_command_format,
                   @select.to_s)
    end
  end

  sub_test_case("#[]") do
    def setup
      @table = "Users"
      @select = Groonga::Command::Base.new("select", :table => @table)
    end

    def test_symbol
      assert_equal(@table, @select[:table])
    end

    def test_string
      assert_equal(@table, @select["table"])
    end
  end

  sub_test_case("#key?") do
    def setup
      @select = Groonga::Command::Base.new("select", :table => "Users")
    end

    def test_symbol
      assert_true(@select.key?(:table))
    end

    def test_string
      assert_true(@select.key?("table"))
    end
  end

  sub_test_case("#has_key?") do
    def setup
      @select = Groonga::Command::Base.new("select", :table => "Users")
    end

    def test_symbol
      assert_true(@select.has_key?(:table))
    end

    def test_string
      assert_true(@select.has_key?("table"))
    end
  end

  sub_test_case("#output_type") do
    def test_default
      command = Groonga::Command::Base.new("table_list", {})
      assert_equal(:json, command.output_type)
    end

    def test_specified
      command = Groonga::Command::Base.new("table_list",
                                           :output_type => "xml")
      assert_equal(:xml, command.output_type)
    end
  end
end
