require 'sakuramochi/config'

module Sakuramochi
  class Predicate
    attr_reader :name, :arel_predicate, :expand, :converter, :validator

    def initialize(options = {}) 
      options = options.reverse_merge(:expand => true)
      @name = options[:name]
      @arel_predicate = options[:arel_predicate]
      @expand = options[:expand]
      @converter = options[:converter]
      @validator = options[:validator] || proc { |v| v.respond_to?(:empty?) ? !v.empty? : !v.nil? }
    end 

    def convert(value)
      return value unless @converter
      if @expand
        Predicate.as_a(value).map { |v| @converter.call(v) }
      else
        @converter.call(value)
      end
    end 

    def validate(value)
      if @expand
        Predicate.as_a(value).select { |v| @validator.call(v) }.any?
      else
        @validator.call(value)
      end
    end 

    def self.as_a(value)
      value.is_a?(Enumerable) ? value.to_a : [value]
    end

    def self.names
      Sakuramochi.config.predicates.keys
    end 

    def self.names_by_decreasing_length
      names.sort { |a, b| b.length <=> a.length }
    end 

    def self.detect(attr)
      attr_name = attr.to_s.dup
      pred_name = names_by_decreasing_length.detect {|p| attr_name.sub!(/_#{p}$/, '')}
      [attr_name, Sakuramochi.config.predicates[pred_name]]
    end 
  end 
end
