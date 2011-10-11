require 'rails'
require 'sakuramochi/config'
require 'sakuramochi/predicate'
require 'sakuramochi/relation'

module Sakuramochi
  class Railtie < Rails::Railtie
    initializer 'sakuramochi.initialize' do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Relation.send(:extend, Sakuramochi::Relation)
      end
    end 
  end 
end
