require 'sakuramochi/predicate'

module Sakuramochi
  def self.configure(&block)
    yield @config ||= Sakuramochi::Configuration.new
  end 

  def self.config
    @config
  end 

  class Configuration
    attr_reader :predicates

    def initialize
      @predicates = {}
    end 

    def add(*args)
      options = args.extract_options!
      args.each do |name|
        name = name.to_s
        options[:name] = name
        @predicates[name] = Predicate.new(options)
      end 
    end 
  end 

  configure do |config|
    config.add :like, :matches, :contains, :arel_predicate => :matches, :formatter => proc { |v| "%#{v}%" }
  end 
end
