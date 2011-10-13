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
      options.reverse_merge!(:grouping => true)
      args.flatten.each do |name|
        name = name.to_s

        suffixes = [nil]
        suffixes += ['any', 'all'] if options[:grouping]

        suffixes.each do |suffix|
          predicate_name = [name, suffix].compact.join('_')
          @predicates[predicate_name] = Predicate.new(options.merge({
            :name => predicate_name,
            :arel_predicate => [options[:arel_predicate], suffix].compact.join('_')
          }))
        end
      end 
    end 

    def clear
      @predicates.clear
    end
  end 

  configure do |config|
    # default predicates
    PREDICATES = {
      :contains =>    [:contains],
      :starts_with => [:starts_with, :start_with],
      :ends_with =>   [:ends_with, :end_with],
      :in =>          [:in],
      :eq =>          [:eq, :equal, :equals],
      :gt =>          [:gt],
      :gte =>         [:gte, :gteq],
      :lt =>          [:lt],
      :lte =>         [:lte, :lteq],
    }
    _not = proc { |p| "not_#{p}" }

    config.add PREDICATES[:contains],               :arel_predicate => :matches,        :converter => proc { |v| "%#{v}%" }
    config.add PREDICATES[:contains].map(&_not),    :arel_predicate => :does_not_match, :converter => proc { |v| "%#{v}%" }
    config.add PREDICATES[:starts_with],            :arel_predicate => :matches,        :converter => proc { |v| "#{v}%" }
    config.add PREDICATES[:starts_with].map(&_not), :arel_predicate => :does_not_match, :converter => proc { |v| "#{v}%" }
    config.add PREDICATES[:ends_with],              :arel_predicate => :matches,        :converter => proc { |v| "%#{v}" }
    config.add PREDICATES[:ends_with].map(&_not),   :arel_predicate => :does_not_match, :converter => proc { |v| "%#{v}" }
    config.add PREDICATES[:in],                     :arel_predicate => :in
    config.add PREDICATES[:in].map(&_not),          :arel_predicate => :not_in
    config.add PREDICATES[:eq],                     :arel_predicate => :eq
    config.add PREDICATES[:eq].map(&_not), :ne,     :arel_predicate => :not_eq
    config.add PREDICATES[:gt],                     :arel_predicate => :gt
    config.add PREDICATES[:gte],                    :arel_predicate => :gteq
    config.add PREDICATES[:lt],                     :arel_predicate => :lt
    config.add PREDICATES[:lte],                    :arel_predicate => :lteq
  end 
end
