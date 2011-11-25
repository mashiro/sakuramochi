# encoding: utf-8
require 'spec_helper'

describe Sakuramochi::Relation do
  describe '#build_where_with_condition' do
    describe 'not' do
      before { @users = User.where([:not, {:name_contains => 'あいら'}]) }
      subject { @users }

      it { subject.map(&:name).should_not be_match_all /あいら/ }
    end

    describe 'and' do
      before { @users = User.where([{:name_contains => '春音'}, :and, {:name_contains => 'あいら'}]) }
      subject { @users }

      it { subject.map(&:name).should be_match_all /春音/ }
      it { subject.map(&:name).should be_match_all /あいら/ }
      it { subject.map(&:name).should_not be_match_all /うる|える/ }
    end

    describe 'or' do
      before { @users = User.where([{:name_contains => 'あいら'}, :or, {:name_contains => 'りずむ'}]) }
      subject { @users }

      it { subject.map(&:name).should_not be_match_all /みおん/ }
    end
  end
end
