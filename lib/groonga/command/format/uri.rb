# Copyright (C) 2012-2025  Sutou Kouhei <kou@clear-code.com>
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

require "cgi/escape"

module Groonga
  module Command
    module Format
      class URI
        def initialize(path_prefix, name, arguments)
          @path_prefix = path_prefix
          @name = name
          @arguments = arguments
        end

        def path
          path = [@path_prefix.chomp("/"), @name].join("/")
          arguments = @arguments.dup
          output_type = arguments.delete(:output_type)
          path << ".#{output_type}" if output_type
          unless arguments.empty?
            sorted_arguments = arguments.sort_by do |name, _|
              name.to_s
            end
            uri_arguments = sorted_arguments.collect do |name, value|
              "#{CGI.escape(name.to_s)}=#{CGI.escape(value)}"
            end
            path << "?"
            path << uri_arguments.join("&")
          end
          path
        end
      end
    end
  end
end
