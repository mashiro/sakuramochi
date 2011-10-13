require 'spec_helper'

RSpec::Matchers.define :be_match_all do |expected|
  match do |actuals|
    actuals.all? { |actual| !!(actual =~ expected) }
  end
end

describe Sakuramochi::PredicateBuilder do
  before(:all) do
    @aira = User.create! :name => 'Aira'
    ['fresh fruit basket', 'munekyun taiken', 'heartful splash',
     'lovely rainbow', 'hirahira hiraku koi no hana', 'crystal splash'
    ].each do |jump|
      Status.create! :text => jump, :user => @aira
    end

    @rizumu = User.create! :name => 'Rizumu'
    ['heartful splash', 'colorful choco parade', 'fun fun heart dive',
     'stardust shower', 'happy macaron spin', 'pop\'n candy rocket'
    ].each do |jump|
      Status.create! :text => jump, :user => @rizumu
    end
  end

  describe 'matches' do
    before do
      Sakuramochi.configure do |config|
        config.clear
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
      context 'with "macaron"' do
        let(:value) { 'macaron' }

        it_should_behave_like :never_match
        it { should have(1).items }
        it { subject.map(&:text).should be_match_all /macaron/ }
      end

      context 'with "splash"' do
        let(:value) { 'splash' }

        it_should_behave_like :never_match
        it { should have(3).items }
        it { subject.map(&:text).should be_match_all /splash/ }
      end
    end

    context 'contains_any' do
      let(:key) { :text_contains_any }
      context 'with ["heart", "splash"]' do
        let(:value) { ['heart', 'splash'] }

        it_should_behave_like :never_match
        it { should have(4).items }
        it { subject.map(&:text).should be_match_all /(heart|splash)/ }
      end
    end

    context 'contains_all' do
      let(:key) { :text_contains_all }
      context 'with ["heart", "splash"]' do
        let(:value) { ['heart', 'splash'] }

        it_should_behave_like :never_match
        it { should have(2).items }
        it { subject.map(&:text).should be_match_all /heart/ }
        it { subject.map(&:text).should be_match_all /splash/ }
      end
    end
  end
end
