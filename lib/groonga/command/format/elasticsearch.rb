# Copyright (C) 2019  Yasuhiro Horimoto <horimoto@clear-code.com>
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

module Groonga
  module Command
    module Format
      class Elasticsearch
        def initialize(name, arguments)
          @name = name
          @arguments = arguments
        end

        def json(options={})
          return nil unless @name == "load"

          components = []
          column_names = []
          elasticsearch_version = options[:version] || 5

          sorted_arguments = @arguments.sort_by(&:first)
          sorted_arguments.each do |name, value|
            case name
            when :table
              case elasticsearch_version
              when 7
                header = {
                  "index" => {
                    "_index" => value.downcase,
                    "_type"=>"_doc",
                  }
                }
              when 8
                header = {
                  "index" => {
                    "_index" => value.downcase,
                  }
                }
              else
                # Version 5.x or 6.x
                header = {
                  "index" => {
                    "_index" => value.downcase,
                    "_type" => "groonga",
                  }
                }
              end
              components << JSON.generate(header)
            when :columns
              value.split(",").each do |column_name|
                column_names << column_name
              end
            when :values
              record = JSON.parse(value)

              if record[0].is_a?(::Array)
                record.each do |load_value|
                  body = {}
                  column_values = load_value
                  column_names.zip(column_values) do |column_name, column_value|
                    body[column_name] = column_value
                  end
                  components << JSON.generate(body)
                end
              else
                record.each do |load_value|
                  components << JSON.generate(load_value)
                end
              end
            end
          end
          components.join("\n")
        end
      end
    end
  end
end
