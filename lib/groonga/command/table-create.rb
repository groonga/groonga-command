# Copyright (C) 2012-2016  Kouhei Sutou <kou@clear-code.com>
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
    class TableCreate < Base
      class << self
        def command_name
          "table_create"
        end

        def parameter_names
          [
            :name,
            :flags,
            :key_type,
            :value_type,
            :default_tokenizer,
            :normalizer,
            :token_filters,
          ]
        end
      end

      Command.register(command_name, self)

      # @return [String, nil] Key type name, nil for array no key table.
      # @since 1.0.7
      def key_type
        self[:key_type]
      end

      # @return [String, nil] Value type name, `nil` for no value
      #   table. Double array trie table always returns `nil` because
      #   double array trie table doesn't support value.
      #
      # @since 1.2.2
      def value_type
        self[:value_type]
      end

      def flags
        @flags ||= (self[:flags] || "").split(/\s*\|\s*/)
      end

      # @return [Boolean] true if "TABLE_NO_KEY" is specified in {#flags},
      #   false otherwise.
      # @since 1.0.3
      def table_no_key?
        flags.include?("TABLE_NO_KEY")
      end

      # @return [Boolean] true if "TABLE_HASH_KEY" is specified in {#flags},
      #   false otherwise.
      # @since 1.0.3
      def table_hash_key?
        flags.include?("TABLE_HASH_KEY")
      end

      # @return [Boolean] true if "TABLE_PAT_KEY" is specified in {#flags},
      #   false otherwise.
      # @since 1.0.3
      def table_pat_key?
        flags.include?("TABLE_PAT_KEY")
      end

      # @return [Boolean] true if "TABLE_DAT_KEY" is specified in {#flags},
      #   false otherwise.
      # @since 1.0.3
      def table_dat_key?
        flags.include?("TABLE_DAT_KEY")
      end

      # @return [Boolean] true if "KEY_WITH_SIS" is specified in {#flags},
      #   false otherwise.
      # @since 1.0.3
      def key_with_sis?
        flags.include?("KEY_WITH_SIS")
      end

      # @return [String, nil] Default tokenizer name or nil.
      # @since 1.0.7
      def default_tokenizer
        self[:default_tokenizer]
      end

      # @return [String, nil] Normalizer name or nil.
      # @since 1.0.7
      def normalizer
        self[:normalizer]
      end

      # @return [::Array<String>] Token filter names.
      # @since 1.2.1
      def token_filters
        @token_filters ||= (self[:token_filters] || "").split(/\s*\|\s*/)
      end
    end
  end
end
