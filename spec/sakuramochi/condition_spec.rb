# encoding: utf-8
require 'spec_helper'

shared_examples_for 'expression node' do |operator, left, right, &block|
  it { should be_instance_of Sakuramochi::Condition::Nodes::Expression }
  its(:operator) { should eq operator }
  its(:left) { should be_instance_of left }
  its(:right) { should be_instance_of right }
end

shared_examples_for 'term node' do |operator, value|
  it { should be_instance_of Sakuramochi::Condition::Nodes::Term }
  its(:operator) { should eq operator }
  its(:value) { should be_instance_of value }
end

shared_examples_for 'factor node' do |value|
  it { should be_instance_of Sakuramochi::Condition::Nodes::Factor }
  its(:value) { should eq value }
end

shared_examples_for 'group node' do |expression|
  it { should be_instance_of Sakuramochi::Condition::Nodes::Group }
  its(:expression) { should be_instance_of expression }
end

describe Sakuramochi::Condition::Parser do
  extend Sakuramochi::Condition::Nodes

  context '1 and 2' do
    before { @node = Sakuramochi::Condition::Parser.new('1 and 2').parse }
    subject { @node }

    it_should_behave_like 'expression node', 'and', Factor, Factor
  end

  context 'not 1 or not 2' do
    before { @node = Sakuramochi::Condition::Parser.new('not 1 or not 2').parse }
    subject { @node }
    it_should_behave_like 'expression node', 'or', Term, Term

    context 'left' do
      before { @node = @node.left }
      it_should_behave_like 'term node', 'not', Factor

      context 'value' do
        before { @node = @node.value }
        it_should_behave_like 'factor node', '1'
      end
    end

    context 'right' do
      before { @node = @node.right }
      it_should_behave_like 'term node', 'not', Factor

      context 'value' do
        before { @node = @node.value }
        it_should_behave_like 'factor node', '2'
      end
    end
  end

  context '( 3 and not ( ( 4 ) or 5 ) )' do
    before { @node = Sakuramochi::Condition::Parser.new('( 3 and not ( ( 4 ) or 5 ) )').parse }
    subject { @node }
    it_should_behave_like 'group node', Expression

    context 'expression' do
      before { @node = @node.expression }
      it_should_behave_like 'expression node', 'and', Factor, Term

      context 'left' do
        before { @node = @node.left }
        it_should_behave_like 'factor node', '3'
      end

      context 'right' do
        before { @node = @node.right }
        it_should_behave_like 'term node', 'not', Group

        context 'value' do
          before { @node = @node.value }
          it_should_behave_like 'group node', Expression

          context 'expression' do
            before { @node = @node.expression }
            it_should_behave_like 'expression node', 'or', Group, Factor

            context 'left' do
              before { @node = @node.left }
              it_should_behave_like 'group node', Factor

              context 'expression' do
                before { @node = @node.expression }
                it_should_behave_like 'factor node', '4'
              end
            end

            context 'right' do
              before { @node = @node.right }
              it_should_behave_like 'factor node', '5'
            end
          end
        end
      end
    end
  end
end
