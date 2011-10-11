require 'rails'
require 'sakuramochi/config'
require 'sakuramochi/predicate'
require 'sakuramochi/predicate_builder'
require 'sakuramochi/relation'

module Sakuramochi
  class Railtie < Rails::Railtie
    initializer 'sakuramochi.initialize' do
      ActiveSupport.on_load(:active_record) do
        initialize
      end
    end 

    def self.initialize
      ActiveRecord::Relation.send(:include, Sakuramochi::Relation)
      ActiveRecord::PredicateBuilder.send(:include, Sakuramochi::PredicateBuilder)
    end
  end 
end
