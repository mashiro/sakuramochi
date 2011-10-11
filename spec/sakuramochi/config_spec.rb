require 'spec_helper'

describe Sakuramochi::Configuration do
  describe '#configure' do
    before do
      Sakuramochi.configure do |config|
        @config = config
      end
    end
    subject { @config }
    it { should be_an_instance_of Sakuramochi::Configuration }
    its(:object_id) { should eql Sakuramochi.config.object_id }

    describe '#add' do
      before do
        @config.add :test
      end
      subject { @config.predicates }
      it { should have_key 'test' }
    end
  end
end
