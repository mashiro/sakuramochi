require 'spec_helper'

describe Sakuramochi::Predicate do
  describe '#convert' do
    before do
      @pred = Sakuramochi::Predicate.new :converter => converter
    end

    context 'default converter' do
      let(:converter) { nil }
      subject { @pred.convert(3) }

      it { should eq 3 }
    end

    context 'custom converter' do
      let(:converter) { proc { |v| v * v } }

      context 'as unit' do
        subject { @pred.convert(3) }
        it { should eq [9] }
      end

      context 'as array' do
        subject { @pred.convert([1,2,3]) }
        it { should eq [1,4,9] }
      end

      context 'as range' do
        subject { @pred.convert(1..3) }
        it { should eq [1,4,9] }
      end
    end
  end

  describe '#validate' do
    before do
      @pred = Sakuramochi::Predicate.new :validator => validator
    end

    context 'default validator' do
      let(:validator) { nil }

      context 'with "value"' do
        subject { @pred.validate('value') }
        it { should be_true }
      end

      context 'with empty' do
        subject { @pred.validate('') }
        it { should be_false }
      end

      context 'with nil' do
        subject { @pred.validate(nil) }
        it { should be_false }
      end
    end

    context 'custom validator: greater then 3' do
      let(:validator) { proc { |v| v > 3 } }

      context 'with 2' do
        subject { @pred.validate(2) }
        it { should be_false }
      end

      context 'with 4' do
        subject { @pred.validate(4) }
        it { should be_true }
      end

      context 'with (1..3)' do
        subject { @pred.validate(1..3) }
        it { should be_false }
      end

      context 'with (1..5)' do
        subject { @pred.validate(1..5) }
        it { should be_true }
      end
    end
  end

  describe '#detect' do
    context 'config.add :test' do
      before do
        Sakuramochi.configure do |config|
          config.add :test
        end
      end

      context 'with :username_test' do
        before { @name, @pred = Sakuramochi::Predicate.detect(:username_test) }
        subject { {:name => @name, :pred => @pred } }
        its([:name]) { should eq 'username' }
        its([:pred]) { should be_instance_of Sakuramochi::Predicate }
      end

      context 'with :username_test2' do
        before { @name, @pred = Sakuramochi::Predicate.detect(:username_test2) }
        subject { {:name => @name, :pred => @pred } }
        its([:name]) { should eq 'username_test2' }
        its([:pred]) { should be_nil }
      end
    end
  end
end
