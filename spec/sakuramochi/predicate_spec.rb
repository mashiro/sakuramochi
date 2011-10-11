require 'spec_helper'

Sakuramochi::Railtie.initialize

describe Sakuramochi::Predicate do
  before do
    User.create :name => "foo"
    User.create :name => "bar"
  end
  describe '#where' do
    it { pending User.where(:name_like => "o").first.name.should == "foo" }
    it { pending User.where(:name_like => "b").first.name.should == "bar" }
    it { pending User.where(:name_like => "").first.name.should == "foo" }
  end
end
