require 'sakuramochi/config'

module Sakuramochi
  class Predicate
    attr_reader :name, :arel_predicate, :formatter, :validator

    def initialize(options = {}) 
      @name = options[:name]
      @arel_predicate = options[:arel_predicate]
      @formatter = options[:formatter]
      @validator = options[:validator] || lambda { |v| v.respond_to?(:empty?) ? !v.empty? : !v.nil? }
    end 

    def format(value)
      formatter ? formatter.call(value) : value
    end 

    def validate(value)
      validator.call(value)
    end 

    def self.names
      Sakuramochi.config.predicates.keys
    end 

    def self.names_by_decreasing_length
      names.sort { |a, b| b.length <=> a.length }
    end 

    def self.detect(attr)
      name = attr.to_s.dup
      pred = names_by_decreasing_length.detect {|p| name.sub!(/_#{p}$/, '')}
      [name, Sakuramochi.config.predicates[pred]]
    end 
  end 
end
