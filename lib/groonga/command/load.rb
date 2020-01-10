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

require "json"

begin
  require "arrow"
rescue LoadError
end

require "groonga/command/base"

module Groonga
  module Command
    class Load < Base
      class << self
        def command_name
          "load"
        end

        def parameter_names
          [
            :values,
            :table,
            :columns,
            :ifexists,
            :input_type,
            :each,
            :output_ids,
          ]
        end
      end

      Command.register(command_name, self)

      attr_writer :table
      attr_writer :values
      attr_writer :columns
      def initialize(*argumetns)
        super
        @table = nil
        @values = nil
        @columns = nil
      end

      # @return [String] The table name to be loaded.
      #
      # @since 1.3.5
      def table
        @table ||= self[:table]
      end

      def values
        @values ||= parse_values(self[:values])
      end

      def columns
        @columns ||= parse_columns(self[:columns])
      end

      # Builds `Arrow::Table` for data of this `load` command.
      #
      # This requires red-arrow gem. If red-arrow gem isn't available,
      # `NotImplementedError` is raised.
      #
      # @return [Arrow::Table, nil] `Arrow::Table` if there is one or more
      #    records, `nil` otherwise.
      #
      # @since 1.4.6
      def build_arrow_table
        unless defined?(::Arrow)
          raise NotImplementedError, "red-arrow is required"
        end
        builder = ArrowTableBuilder.new(columns, values)
        builder.build
      end

      # @return [Boolean] `true` if `output_ids` value is `"yes"`.
      #
      # @since 1.3.0
      def output_ids?
        boolean_value(:output_ids,
                      default: false,
                      invalid: false)
      end

      private
      def parse_values(values)
        return values if values.nil?
        JSON.parse(values)
      end

      def parse_columns(columns)
        return columns if columns.nil?
        columns.split(/\s*,\s*/)
      end

      class ArrowTableBuilder
        def initialize(columns, values)
          @columns = columns
          @values = values
        end

        def build
          raw_table = build_raw_table
          return nil if raw_table.empty?
          build_arrow_table(raw_table)
        end

        private
        def build_raw_table
          raw_table = {}
          if @values.first.is_a?(Array)
            columns = @columns
            if columns
              records = @values
            else
              columns = @values.first
              records = @values[1..-1]
            end
            records.each_with_index do |record, i|
              columns.zip(record).each do |name, value|
                raw_table[name] ||= []
                raw_table[name][i] = value
              end
            end
          else
            @values.each_with_index do |record, i|
              record.each do |name, value|
                raw_table[name] ||= []
                raw_table[name][i] = value
              end
            end
            raw_table.each_key do |key|
              if @values.size > raw_table[key].size
                raw_table[key][@values.size - 1] = nil
              end
            end
          end
          raw_table
        end

        def build_arrow_table(raw_table)
          arrow_fields = []
          arrow_arrays = []
          raw_table.each do |name, raw_array|
            sample = raw_array.find {|element| not element.nil?}
            case sample
            when Array
              data_type = nil
              raw_array.each do |sub_raw_array|
                next if sub_raw_array.nil?
                data_type = detect_arrow_data_type(sub_raw_array)
                break if data_type
              end
              data_type ||= :string
              arrow_array = build_arrow_array(data_type, raw_array)
            when Hash
              arrow_array = build_arrow_array(arrow_weight_vector_data_type,
                                              raw_array)
            else
              data_type = detect_arrow_data_type(raw_array) || :string
              if data_type == :string
                raw_array = raw_array.collect do |element|
                  element&.to_s
                end
              end
              data_type = Arrow::DataType.resolve(data_type)
              arrow_array = data_type.build_array(raw_array)
            end
            arrow_fields << Arrow::Field.new(name,
                                             arrow_array.value_data_type)
            arrow_arrays << arrow_array
          end
          arrow_schema = Arrow::Schema.new(arrow_fields)
          Arrow::Table.new(arrow_schema, arrow_arrays)
        end

        def prepare_raw_array(raw_array)
          raw_array.collect do |element|
            case element
            when Array
              prepare_raw_array(element)
            when Hash
              element.collect do |value, weight|
                {
                  "value" => value,
                  "weight" => weight,
                }
              end
            else
              element
            end
          end
        end

        def build_arrow_array(data_type, raw_array)
          arrow_list_field = Arrow::Field.new("item", data_type)
          arrow_list_data_type = Arrow::ListDataType.new(arrow_list_field)
          raw_array = prepare_raw_array(raw_array)
          Arrow::ListArrayBuilder.build(arrow_list_data_type, raw_array)
        end

        def arrow_weight_vector_data_type
          Arrow::StructDataType.new("value" => :string,
                                    "weight" => :int32)
        end

        def detect_arrow_data_type(raw_array)
          type = nil
          raw_array.each do |element|
            case element
            when nil
            when true, false
              type ||= :boolean
            when Integer
              if element >= (2 ** 63)
                type = nil if type == :int64
                type ||= :uint64
              else
                type ||= :int64
              end
            when Float
              type = nil if type == :int64
              type ||= :double
            when Hash
              arrow_list_field =
                Arrow::Field.new("item", arrow_weight_vector_data_type)
              arrow_list_data_type = Arrow::ListDataType.new(arrow_list_field)
              return arrow_list_data_type
            else
              return :string
            end
          end
          type
        end
      end
    end
  end
end
