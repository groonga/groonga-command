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
        def initialize(command)
          @command = command
        end

        def json(options={})
          return nil unless @command.is_a?(Load)

          components = []
          action = build_action(options)
          each_source do |source|
            components << JSON.generate(action)
            components << JSON.generate(source)
          end
          components.join("\n")
        end

        private
        def elasticsearch_version(options)
          options[:version] || 5
        end

        def build_action(options)
          index_name = @command[:table].downcase
          case elasticsearch_version(options)
          when 5, 6
            {
              "index" => {
                "_index" => index_name,
                "_type" => "groonga",
              }
            }
          when 7
            {
              "index" => {
                "_index" => index_name,
                "_type"=>"_doc",
              }
            }
          else
            {
              "index" => {
                "_index" => index_name,
              }
            }
          end
        end

        def each_source
          unless @command[:columns].nil?
            columns = @command[:columns].split(/\s*,\s*/)
          end
          values = JSON.parse(@command[:values]) || []
          values.each do |value|
            if value.is_a?(::Array)
              if columns.nil?
                columns = value
              else
                yield(Hash[columns.zip(value)])
              end
            else
              yield(value)
            end
          end
        end
      end
    end
  end
end
