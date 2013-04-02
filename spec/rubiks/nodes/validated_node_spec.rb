require 'spec_helper'

class NodeWithValidation < ::Rubiks::Nodes::ValidatedNode
  validates :something
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
