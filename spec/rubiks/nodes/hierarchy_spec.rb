require 'spec_helper'
# Mondrian level has: has_all, all_member_name, primary_key

describe ::Rubiks::Nodes::Hierarchy do
  include_context 'schema_context'

  subject { described_class.new_from_hash }

  specify { subject.respond_to?(:from_hash) }
  specify { subject.respond_to?(:to_hash) }
  specify { subject.respond_to?(:levels) }

  context 'when parsed from a valid hash' do
    subject { described_class.new_from_hash(hierarchy_hash) }

    its(:to_hash) { should have_key('levels') }

    it { should be_valid }
  end

  context 'when parsed from an invalid (empty) hash' do
    subject { described_class.new_from_hash({}) }

    it { should_not be_valid }
  end

end
