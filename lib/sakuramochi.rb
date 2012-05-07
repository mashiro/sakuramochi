require 'active_support'
require 'active_support/core_ext/hash'
require 'active_record'
require 'sakuramochi/version'

module Sakuramochi
  autoload :Configuration,    'sakuramochi/configuration'
  autoload :Predicate,        'sakuramochi/predicate'
  autoload :PredicateBuilder, 'sakuramochi/predicate_builder'
  autoload :Condition,        'sakuramochi/condition'
  autoload :Relation,         'sakuramochi/relation'

  def self.configure(&block)
    yield @config ||= Sakuramochi::Configuration.new
  end

  def self.config
    @config
  end

  configure do |config|
    predicates = {
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
    negative = proc { |p| "not_#{p}" }

    config.add predicates[:contains],                   :arel_predicate => :matches,        :converter => proc { |v| "%#{v}%" }
    config.add predicates[:contains].map(&negative),    :arel_predicate => :does_not_match, :converter => proc { |v| "%#{v}%" }
    config.add predicates[:starts_with],                :arel_predicate => :matches,        :converter => proc { |v| "#{v}%" }
    config.add predicates[:starts_with].map(&negative), :arel_predicate => :does_not_match, :converter => proc { |v| "#{v}%" }
    config.add predicates[:ends_with],                  :arel_predicate => :matches,        :converter => proc { |v| "%#{v}" }
    config.add predicates[:ends_with].map(&negative),   :arel_predicate => :does_not_match, :converter => proc { |v| "%#{v}" }
    config.add predicates[:in],                         :arel_predicate => :in
    config.add predicates[:in].map(&negative),          :arel_predicate => :not_in
    config.add predicates[:eq],                         :arel_predicate => :eq
    config.add predicates[:eq].map(&negative), :ne,     :arel_predicate => :not_eq
    config.add predicates[:gt],                         :arel_predicate => :gt
    config.add predicates[:gte],                        :arel_predicate => :gteq
    config.add predicates[:lt],                         :arel_predicate => :lt
    config.add predicates[:lte],                        :arel_predicate => :lteq
  end 

  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Relation.send(:include, Sakuramochi::Relation)
    ActiveRecord::PredicateBuilder.send(:include, Sakuramochi::PredicateBuilder)
  end
end
