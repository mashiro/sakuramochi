require 'sakuramochi/predicate'
require 'active_support/concern'

module Sakuramochi
  module PredicateBuilder
    extend ActiveSupport::Concern

    included do
      unless respond_to? :build
        model_class = defined?(ActiveRecord::Model) ? ActiveRecord::Model : ActiveRecord::Base

        def self.build(attribute, value)
          case value
          when ActiveRecord::Relation
            value = value.select(value.klass.arel_table[value.klass.primary_key]) if value.select_values.empty?
            attribute.in(value.arel.ast)
          when Array, ActiveRecord::Associations::CollectionProxy
            values = value.to_a.map {|x| x.is_a?(model_class) ? x.id : x}
            ranges, values = values.partition {|v| v.is_a?(Range)}

            values_predicate = if values.include?(nil)
              values = values.compact

              case values.length
              when 0
                attribute.eq(nil)
              when 1
                attribute.eq(values.first).or(attribute.eq(nil))
              else
                attribute.in(values).or(attribute.eq(nil))
              end
            else
              attribute.in(values)
            end

            array_predicates = ranges.map { |range| attribute.in(range) }
            array_predicates << values_predicate
            array_predicates.inject { |composite, predicate| composite.or(predicate) }
          when Range
            attribute.in(value)
          when model_class
            attribute.eq(value.id)
          when Class
            # FIXME: I think we need to deprecate this behavior
            attribute.eq(value.name)
          else
            attribute.eq(value)
          end
        end
      end

      instance_eval do
        alias :build_from_hash_without_predicate :build_from_hash
        alias :build_from_hash :build_from_hash_with_predicate
      end
    end

    module ClassMethods
      def build_from_hash_with_predicate(engine, attributes, default_table)
        attributes.map do |column, value|
          table = default_table

          if value.is_a?(Hash)
            table = Arel::Table.new(column, engine)
            build_from_hash_with_predicate(engine, value, table)
          else
            column = column.to_s

            if column.include?('.')
              table_name, column = column.split('.', 2)
              table = Arel::Table.new(table_name, engine)
            end 

            column_name, predicate = Sakuramochi::Predicate.detect(column.to_s)
            attribute = table[column_name.to_sym]

            if predicate
              build_with_predicate(attribute, value, predicate)
            else
              build(attribute, value)
            end
          end
        end.flatten
      end

      private

      def build_with_predicate(attribute, value, predicate)
        if predicate.validate(value)
          if predicate.converter
            attribute.send(predicate.arel_predicate, predicate.convert(value))
          else
            relation = build(attribute, value)
            attribute.send(predicate.arel_predicate, relation.right)
          end
        else
          ''
        end
      end
    end

  end
end
