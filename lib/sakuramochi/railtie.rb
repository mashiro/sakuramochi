require 'rails'
require 'sakuramochi/config'
require 'sakuramochi/predicate'
require 'sakuramochi/predicate_builder'

module Sakuramochi
  class Railtie < Rails::Railtie
    initializer 'sakuramochi.initialize' do
      ActiveSupport.on_load(:active_record) do
        Railtie.setup
      end
    end 

    def self.setup
      ActiveRecord::PredicateBuilder.send(:include, Sakuramochi::PredicateBuilder)
    end
  end 
end
