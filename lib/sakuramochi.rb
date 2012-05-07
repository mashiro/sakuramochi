require 'active_support'
require 'active_support/core_ext/hash'
require 'active_record'
require 'sakuramochi/version'

module Sakuramochi
  autoload :Configuration,    'sakuramochi/configuration'
  autoload :Predicate,        'sakuramochi/predicate'
  autoload :PredicateBuilder, 'sakuramochi/predicate_builder'
  autoload :Condition,        'sakuramochi/condition'
  autoload :Relation,         'sakuramochi/relation'

  def self.config
    @config ||= Sakuramochi::Configuration.new
  end

  def self.configure(&block)
    yield config
  end

  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Relation.send(:include, Sakuramochi::Relation)
    ActiveRecord::PredicateBuilder.send(:include, Sakuramochi::PredicateBuilder)
  end
end
