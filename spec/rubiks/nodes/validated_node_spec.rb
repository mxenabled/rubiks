require 'spec_helper'

class NodeWithValidation < ::Rubiks::ValidatedNode
  validates :something

  def something
    errors << 'Something is required'
  end
end

class SubNodeWithValidation < NodeWithValidation
end

class NodeWithAdditionalValidation < NodeWithValidation
  validates :something_else
end




describe NodeWithValidation do
  subject { described_class }

  it 'has a validator' do
    subject.validators.length.should eq 1
  end

  context 'when parsed from an invalid (empty) hash' do
    subject { described_class.new }

    it { should_not be_valid }
  end
end

describe SubNodeWithValidation do
  subject { described_class }

  it 'inherits the validator of the super class' do
    subject.validators.length.should eq 1
  end
end

describe NodeWithAdditionalValidation do
  subject { described_class }

  it 'has 2 validators' do
    subject.validators.length.should eq 2
  end
end
