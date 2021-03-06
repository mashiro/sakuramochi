require 'active_support/concern'
require 'sakuramochi/condition'

module Sakuramochi
  module Relation
    extend ActiveSupport::Concern

    included do
      alias :build_where_without_condition :build_where
      alias :build_where :build_where_with_condition
    end

    def collapse_conditions(node, other)
      case node
      when Sakuramochi::Condition::Nodes::Expression
        case node.operator.to_s
        when 'and'
          left = collapse_conditions(node.left, other)
          right = collapse_conditions(node.right, other)
          left && right ? Arel::Nodes::And.new([left, right]) : left || right

        when 'or'
          left = collapse_conditions(node.left, other)
          right = collapse_conditions(node.right, other)
          left && right ? Arel::Nodes::Or.new(left, right) : left || right
        end

      when Sakuramochi::Condition::Nodes::Term
        case node.operator.to_s
        when 'not'
          right = collapse_conditions(node.value, other)
          Arel::Nodes::Not.new(right) if right
        end

      when Sakuramochi::Condition::Nodes::Factor
        wheres = build_where_without_condition(node.value, other)
        arel = table.from(table)
        collapse_wheres(arel, (wheres - ['']).uniq)
        arel.constraints.inject { |left, right| left.and(right) }

      when Sakuramochi::Condition::Nodes::Group
        expression = collapse_conditions(node.expression, other)
        Arel::Nodes::Grouping.new(expression) if expression
      end
    end

    def build_where_with_condition(opts, other = [])
      if Sakuramochi::Condition.condition?(opts)
        ast = Sakuramochi::Condition::Parser.new(opts.dup).parse
        [collapse_conditions(ast, other)].compact
      else
        build_where_without_condition(opts, other)
      end
    end
  end
end
