require 'sakuramochi/predicate'
require 'active_support/concern'

module Sakuramochi
  module Relation
    extend ActiveSupport::Concern

    included do
      module_eval do

        def where_with_predicate(opts, *rest)
          return self if opts.blank?

          where_value = build_where(opts, rest)
          return self if where_value.blank?

          relation = clone
          relation.where_values += where_value
          relation
        end 
        alias_method_chain :where, :predicate

        def having_with_predicate(opts, *rest)
          return self if opts.blank?

          having_value = build_where(opts, rest)
          return self if having_value.blank?

          relation = clone
          relation.having_values += having_value
          relation
        end
        alias_method_chain :having, :predicate

      end
    end

  end 
end
