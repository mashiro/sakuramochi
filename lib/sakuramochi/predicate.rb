require 'sakuramochi/config'

module Sakuramochi
  class Predicate
    attr_reader :name, :arel_predicate, :converter, :validator

    def initialize(options = {}) 
      @name = options[:name]
      @arel_predicate = options[:arel_predicate]
      @converter = options[:converter]
      @validator = options[:validator] || lambda { |v| v.respond_to?(:empty?) ? !v.empty? : !v.nil? }
    end 

    def convert(value)
      return value unless converter
      values = value.is_a?(Enumerable) ? value.to_a : [value]
      values.map { |v| converter.call(v) }
    end 

    def validate(value)
      values = value.is_a?(Enumerable) ? value.to_a : [value]
      values.select { |v| validator.call(v) }.any?
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
