require 'spec_helper'

describe ::Rubiks::Measure do
  include_context 'schema_context'

  subject { described_class.new_from_hash }

  specify { subject.respond_to?(:from_hash) }
  specify { subject.respond_to?(:to_hash) }
  specify { subject.respond_to?(:column) }
  specify { subject.respond_to?(:aggregator) }
  specify { subject.respond_to?(:format_string) }

  context 'when parsed from a valid hash' do
    subject { described_class.new_from_hash(measure_hash) }

    it { should be_valid }

    its(:to_hash) { should have_key('name') }
    its(:to_hash) { should have_key('column') }
    its(:to_hash) { should have_key('aggregator') }
    its(:to_hash) { should have_key('format_string') }
  end

  context 'when parsed from an invalid (empty) hash' do
    subject { described_class.new_from_hash({}) }

    it { should_not be_valid }
  end

end
