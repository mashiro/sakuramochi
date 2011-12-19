require 'active_support/core_ext/hash'
require 'active_support'
require 'active_record'
require "sakuramochi/version"
require 'sakuramochi/config'
require 'sakuramochi/predicate'
require 'sakuramochi/predicate_builder'
require 'sakuramochi/condition'
require 'sakuramochi/relation'

module Sakuramochi
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Relation.send(:include, Sakuramochi::Relation)
    ActiveRecord::PredicateBuilder.send(:include, Sakuramochi::PredicateBuilder)
  end
end
