require 'sakuramochi/predicate'

module Sakuramochi

  module Relation
    def self.extended(base)
      base.class_eval do
        def build_where_with_predicate(opts, other = []) 
          p opts
          if opts.is_a?(Hash)
            opts.each do |key, value|
              name, pred = Predicate.detect(key)
              p name, pred
            end 
            opts = ['name = ?', :test]
            build_where_without_predicate opts, other
          else
            build_where_without_predicate opts, other
          end 
        end 
        alias_method_chain :build_where, :predicate
      end 
    end 
  end 

end
