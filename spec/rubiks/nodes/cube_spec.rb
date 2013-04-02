require 'spec_helper'

describe ::Rubiks::Nodes::Cube do
  include_context 'schema_context'

  subject { described_class.new_from_hash }

  specify { subject.respond_to?(:from_hash) }
  specify { subject.respond_to?(:to_hash) }
  specify { subject.respond_to?(:dimensions) }
  specify { subject.respond_to?(:measures) }

  context 'when parsed from a valid hash' do
    subject { described_class.new_from_hash(cube_hash) }

    it { should be_valid }

    its(:to_hash) { should have_key('name') }

    it 'has a Rubiks::Nodes::Dimension' do
      subject.dimensions.first.should be_kind_of(::Rubiks::Nodes::Dimension)
    end

    it 'has a Rubiks::Nodes::Measure' do
      subject.measures.first.should be_kind_of(::Rubiks::Nodes::Measure)
    end

    it 'has one value' do
      subject.values.size.should eq(1)
    end
  end

  context 'when parsed from an invalid (empty) hash' do
    subject { described_class.new_from_hash({}) }

    it { should_not be_valid }
  end

end
