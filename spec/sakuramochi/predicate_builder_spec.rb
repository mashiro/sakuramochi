# encoding: utf-8
require 'spec_helper'

describe Sakuramochi::PredicateBuilder do
  describe 'matches' do
    before do
      Sakuramochi.configure do |config|
        config.add :contains, :arel_predicate => :matches, :converter => proc { |v| "%#{v}%" }
      end
      @statuses = Status.where(key => value)
    end
    subject { @statuses }

    shared_examples_for :never_match do
      let(:value) { 'NEVER MATCH' }
      it { should be_empty }
    end

    context 'contains' do
      let(:key) { :text_contains }
      context 'with "マカロン"' do
        let(:value) { 'マカロン' }

        it_should_behave_like :never_match
        it { should have(1).items }
        it { subject.map(&:text).should be_match_all /マカロン/ }
      end

      context 'with "スプラッシュ"' do
        let(:value) { 'スプラッシュ' }

        it_should_behave_like :never_match
        it { should have(3).items }
        it { subject.map(&:text).should be_match_all /スプラッシュ/ }
      end
    end

    context 'contains_any' do
      let(:key) { :text_contains_any }
      context 'with ["ハート", "スプラッシュ"]' do
        let(:value) { ['ハート', 'スプラッシュ'] }

        it_should_behave_like :never_match
        it { should have(7).items }
        it { subject.map(&:text).should be_match_all /(ハート|スプラッシュ)/ }
      end
    end

    context 'contains_all' do
      let(:key) { :text_contains_all }
      context 'with ["ハート", "スプラッシュ"]' do
        let(:value) { ['ハート', 'スプラッシュ'] }

        it_should_behave_like :never_match
        it { should have(2).items }
        it { subject.map(&:text).should be_match_all /ハート/ }
        it { subject.map(&:text).should be_match_all /スプラッシュ/ }
      end
    end
  end
end
