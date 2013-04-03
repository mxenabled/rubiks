require 'spec_helper'

describe ::Rubiks::Dimension do
  include_context 'schema_context'

  subject { described_class.new_from_hash }

  specify { subject.respond_to?(:from_hash) }
  specify { subject.respond_to?(:to_hash) }
  specify { subject.respond_to?(:hierarchies) }

  context 'when parsed from a valid hash' do
    subject { described_class.new_from_hash(dimension_hash) }

    its(:to_hash) { should have_key('hierarchies') }

    it { should be_valid }
  end

  context 'when parsed from an invalid (empty) hash' do
    subject { described_class.new_from_hash({}) }

    it { should_not be_valid }
  end

end