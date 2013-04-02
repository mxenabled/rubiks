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

  it 'has a validator (inherited)' do
    subject.validators.length.should eq 1
  end
end


describe NodeWithAdditionalValidation do
  subject { described_class }

  it 'has 2 validators' do
    subject.validators.length.should eq 2
  end
end


# 
#   its(:validators) { should }
# 
# describe ::Rubiks::Nodes::ValidatedNode do
#   context 'when subclassed' do
#     subject { ::Rubiks::ValidatedNodeSpec::NodeWithAdditionalValidation }
# 
#     its(:name) { should eq('some_name') }
# 
#     its(:to_hash) { should have_key('name') }
# 
#     it { should be_valid }
#   end
# 
#   context 'when parsed from an invalid (empty) hash' do
#     subject { described_class.new.from_hash({}) }
# 
#     it { should_not be_valid }
#   end
# 
# end
