require 'spec_helper'

describe ::Rubiks::Nodes::Schema do
  include_context 'schema_context'

  subject { described_class.new_from_hash }

  specify { subject.respond_to?(:from_hash) }
  specify { subject.respond_to?(:to_hash) }
  specify { subject.respond_to?(:cubes) }

  context 'when parsed from a valid hash' do
    subject { described_class.new_from_hash(schema_hash) }

    it 'has a cube' do
      subject.cubes.length.should eq 1
    end

    its(:to_hash) { should have_key('cubes') }

    it { should be_valid }
  end

  context 'when parsed from an invalid (empty) hash' do
    subject { described_class.new_from_hash({}) }

    it { should_not be_valid }
  end

end
