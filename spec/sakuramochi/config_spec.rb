require 'spec_helper'

describe Sakuramochi::Configuration do
  before do
    Sakuramochi.configure do |config|
      config.clear
      @config = config
    end
  end
  subject { @config }

  describe '#configure' do
    it { should be_an_instance_of Sakuramochi::Configuration }
    its(:object_id) { should eq Sakuramochi.config.object_id }
  end

  describe '#clear' do
    before do
      @config.add :test1
      @config.add :test2
      @config.add :test3, :test4
      @config.clear
    end
    subject { @config.predicates }

    it { should be_empty }
  end

  describe '#add' do
    before do
      @config.add :test1, :grouping => true
      @config.add :test2, :grouping => false
    end
    subject { @config.predicates }

    it { should_not be_empty }

    context 'with :test1, :grouping => true' do
      it { should have_key 'test1' }
      it { should have_key 'test1_any' }
      it { should have_key 'test1_all' }
    end

    context 'with :test2, :grouping => false' do
      it { should have_key 'test2' }
      it { should_not have_key 'test2_any' }
      it { should_not have_key 'test2_all' }
    end
  end
end
