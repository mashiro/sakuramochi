require 'sakuramochi/predicate'

module Sakuramochi
  class Configuration
    attr_accessor :predicates

    def initialize
      @predicates = {}
    end 

    def add(*args)
      options = args.extract_options!
      options.reverse_merge!(:grouping => true)

      suffixes = [nil]
      suffixes += ['any', 'all'] if options[:grouping]

      args.flatten.each do |name|
        name = name.to_s
        suffixes.each do |suffix|
          predicate_name = [name, suffix].compact.join('_')
          @predicates[predicate_name] = Predicate.new(options.merge({
            :name => predicate_name,
            :arel_predicate => [options[:arel_predicate], suffix].compact.join('_')
          }))
        end
      end 
    end 
  end 
end
