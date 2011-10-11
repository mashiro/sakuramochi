module Sakuramochi
  autoload :Configuration, 'sakuramochi/config'
  autoload :Predicate, 'sakuramochi/predicate'
  autoload :Relation, 'sakuramochi/relation'

  class Railtie < Rails::Railtie
    initializer 'sakuramochi.initialize' do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Relation.send(:extend, Sakuramochi::Relation)
      end
    end 
  end 
end
