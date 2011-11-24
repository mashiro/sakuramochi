require 'spec_helper'

describe Sakuramochi::Relation do
  describe '#build_where_with_condition' do
    before do
      #@statuses = Status.where([:not, {:text_contains => 'splash'}, :and, {:id => 1}])
      @statuses = Status.joins(:user).where([
        :'(', {:users => {:name_contains => 'aira'}}, :or, {:text_contains => 'aira'}, :')', :and,
        :'(', {:users => {:name_contains => 'rizumu'}}, :or, {:text_contains => 'rizumu'}, :')'
      ])
    end
    #before { @statuses = Status.where([:not, {:text_contains => 'splash'}]) }
    subject { @statuses }

    it { should have(0).items }
  end
end
