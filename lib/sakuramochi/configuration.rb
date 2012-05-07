require 'sakuramochi/predicate'

module Sakuramochi
  class Configuration
    attr_accessor :predicates

    def initialize
      @predicates = {}
      restore
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

    def clear
      @predicates.clear
    end

    def restore
      clear

      names = {
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

      add names[:contains],                   :arel_predicate => :matches,        :converter => proc { |v| "%#{v}%" }
      add names[:contains].map(&negative),    :arel_predicate => :does_not_match, :converter => proc { |v| "%#{v}%" }
      add names[:starts_with],                :arel_predicate => :matches,        :converter => proc { |v| "#{v}%" }
      add names[:starts_with].map(&negative), :arel_predicate => :does_not_match, :converter => proc { |v| "#{v}%" }
      add names[:ends_with],                  :arel_predicate => :matches,        :converter => proc { |v| "%#{v}" }
      add names[:ends_with].map(&negative),   :arel_predicate => :does_not_match, :converter => proc { |v| "%#{v}" }
      add names[:in],                         :arel_predicate => :in
      add names[:in].map(&negative),          :arel_predicate => :not_in
      add names[:eq],                         :arel_predicate => :eq
      add names[:eq].map(&negative), :ne,     :arel_predicate => :not_eq
      add names[:gt],                         :arel_predicate => :gt
      add names[:gte],                        :arel_predicate => :gteq
      add names[:lt],                         :arel_predicate => :lt
      add names[:lte],                        :arel_predicate => :lteq
    end
  end 
end
