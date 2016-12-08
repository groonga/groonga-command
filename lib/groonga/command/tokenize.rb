# -*- coding: utf-8 -*-
#
# Copyright (C) 2013  Kouhei Sutou <kou@clear-code.com>
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

require "groonga/command/base"

module Groonga
  module Command
    # A command class that represents `tokenize` command.
    #
    # @since 1.0.6
    class Tokenize < Base
      class << self
        def command_name
          "tokenize"
        end

        def parameter_names
          [
            :tokenizer,
            :string,
            :normalizer,
            :flags,
            :mode,
            :token_filters,
          ]
        end
      end

      Command.register(command_name, self)

      # @return [String] `tokenizer` parameter value.
      # @since 1.0.6
      def tokenizer
        self[:tokenizer]
      end

      # @return [String] `string` parameter value.
      # @since 1.0.6
      def string
        self[:string]
      end

      # @return [String] `normalizer` parameter value.
      # @since 1.0.6
      def normalizer
        self[:normalizer]
      end

      # @return [Array<String>] An array of flag specified in `flags`
      #   parameter value. This array is extracted by parsing `flags`
      #   parameter value. If `flags` parameter value is nil or empty,
      #   an empty array is returned.
      #
      # @since 1.0.6
      def flags
        @flags ||= flags_value(:flags)
      end

      # @return [String] `mode` parameter value.
      #
      # @since 1.1.0
      def mode
        self[:mode]
      end

      # @return [Array<String>] An array of token filter specified in
      #   `token_filters` parameter value. This array is extracted by
      #   parsing `token_filters` parameter value. If `token_filters`
      #   parameter value is nil or empty, an empty array is returned.
      #
      # @since 1.1.0
      def token_filters
        @token_filters ||= (self[:token_filters] || "").split(/\s*,\s*/)
      end
    end
  end
end
