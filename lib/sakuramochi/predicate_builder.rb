require 'sakuramochi/predicate'
require 'active_support/concern'

module Sakuramochi
  module PredicateBuilder
    extend ActiveSupport::Concern

    included do
      instance_eval do
        alias :build_from_hash_without_predicate :build_from_hash
        alias :build_from_hash :build_from_hash_with_predicate
      end
    end

    module ClassMethods
      def build_from_hash_with_predicate(engine, attributes, default_table)
        predicates = attributes.map do |column, value|
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

            column_name, predicate = Predicate.detect(column.to_s)
            attribute = table[column_name.to_sym]

            if predicate
              build_attribute_with_predicate(attribute, value, predicate)
            else
              build_attribute(attribute, value)
            end
          end
        end

        predicates.flatten.compact
      end

      private

      def build_attribute_with_predicate(attribute, value, predicate)
        if predicate.validate(value)
          if predicate.converter
            attribute.send(predicate.arel_predicate, predicate.convert(value))
          else
            relation = build_attribute(attribute, value)
            attribute.send(predicate.arel_predicate, relation.right)
          end
        else
          ''
        end
      end

      def build_attribute(attribute, value)
        case value
        when ActiveRecord::Relation
          value = value.select(value.klass.arel_table[value.klass.primary_key]) if value.select_values.empty?
          attribute.in(value.arel.ast)
        when Array, ActiveRecord::Associations::CollectionProxy
          values = value.to_a.map { |x|
            x.is_a?(ActiveRecord::Base) ? x.id : x
          }

          if values.include?(nil)
            values = values.compact
            if values.empty?
              attribute.eq nil
            else
              attribute.in(values.compact).or attribute.eq(nil)
            end
          else
            attribute.in(values)
          end

        when Range, Arel::Relation
          attribute.in(value)
        when ActiveRecord::Base
          attribute.eq(value.id)
        when Class
          # FIXME: I think we need to deprecate this behavior
          attribute.eq(value.name)
        else
          attribute.eq(value)
        end
      end
    end

  end
end
