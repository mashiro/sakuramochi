module Sakuramochi
  module Condition
    class UnexpectedError < StandardError; end
    class SyntaxError < StandardError; end

    module Nodes
      class Node
      end

      class Expression < Node
        attr_reader :operator, :left, :right
        def initialize(operator, left, right)
          @operator = operator
          @left = left
          @right = right
        end

        def inspect
          "(#{@operator} #{@left.inspect} #{@right.inspect})"
        end
      end

      class Term < Node
        attr_reader :operator, :value
        def initialize(operator, value)
          @operator = operator
          @value = value
        end

        def inspect
          "(#{@operator} #{@value.inspect})"
        end
      end

      class Factor < Node
        attr_reader :value
        def initialize(value)
          @value = value
        end

        def inspect
          "#{@value}"
        end
      end

      class Group < Node
        attr_reader :expression
        def initialize(expression)
          @expression = expression
        end

        def inspect
          "(#{@expression.inspect})"
        end
      end
    end

    # expression = term {("and"|"or") term}
    # term = ["not"] factor
    # factor = array | hash | "(" expression ")"
    class Parser
      EXPRESSIONS = ['and', 'or']
      TERMS = ['not']
      PARENTHESES = {'(' => ')'}

      def initialize(tokens)
        @tokens = tokens.dup
        @tokens = @tokens.split(/\s+/) if @tokens.is_a?(String) # debug
      end

      def parse
        expression
      end

      private

      def self.indifferenct_key(token)
        if token.is_a?(String) || token.is_a?(Symbol)
          token.to_s.downcase
        else
          token
        end
      end

      def peek
        token = @tokens.first
        self.class.indifferenct_key token
      end

      def shift
        token = @tokens.shift
        self.class.indifferenct_key token
      end

      def accept(*args)
        if args.include?(peek)
          shift
        else
          nil
        end
      end

      def expect(*args)
        if token = accept(*args)
          token
        else
          raise UnexpectedError
        end
      end

      def expression
        node = term
        while token = accept(*EXPRESSIONS)
          node = Nodes::Expression.new(token, node, term)
        end
        node
      end

      def term
        if token = accept(*TERMS)
          Nodes::Term.new(token, factor)
        else
          factor
        end
      end

      def factor
        if token = accept(*PARENTHESES.keys)
          node = expression
          expect PARENTHESES[token]
          Nodes::Group.new(node)
        else
          Nodes::Factor.new(shift)
        end
      end
    end

  end
end
