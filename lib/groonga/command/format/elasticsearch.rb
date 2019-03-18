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

        def command_line(options={})
          return if @name != "load"

          header = Hash.new
          body = Hash.new
          components = ""
          elasticsearch_version = options[:version]

          sorted_arguments = @arguments.sort_by do |name, _|
            name.to_s
          end
          sorted_arguments.each do |name, value|
            case name
            when :table
              case elasticsearch_version
              when 7
                header = {"index"=>{"_index"=>"#{value.downcase}", "_type"=>"_doc"}}
              when 8
                header = {"index"=>{"_index"=>"#{value.downcase}"}}
              else
                # Version 5.x or 6.x
                header = {"index"=>{"_index"=>"#{value.downcase}", "_type"=>"groonga"}}
              end
              components << JSON.generate(header) + "\n"
            when :values
              json_value = JSON.parse(value)
              if json_value.first.to_s.start_with?("[")
                is_first = true
                column_names = []
                column_values = []

                json_value.each do |load_value|
                  if is_first
                    column_names = load_value
                    is_first = false
                    next
                  end
                  column_values = load_value
                  column_names.each_with_index do |column_name, i|
                    body.merge!({"#{column_name}"=>"#{column_values[i]}"})
                  end
                  components << JSON.generate(body) + "\n"
                end
              else
                json_value.each do |load_value|
                  load_value.keys.each do |key|
                    body.merge!({"#{key}"=>"#{load_value[key]}"})
                  end
                  components << JSON.generate(body) + "\n"
                end
              end
            end
          end
          components.chomp!
        end
      end
    end
  end
end
