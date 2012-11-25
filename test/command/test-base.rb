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
  end
end
