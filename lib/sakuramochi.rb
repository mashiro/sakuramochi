require 'active_support/core_ext'
require 'active_support'
require 'active_record'
require 'sakuramochi/config'
require 'sakuramochi/predicate'
require 'sakuramochi/predicate_builder'

ActiveSupport.on_load(:active_record) do
  ActiveRecord::PredicateBuilder.send(:include, Sakuramochi::PredicateBuilder)
end
