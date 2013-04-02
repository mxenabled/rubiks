require 'spec_helper'
# Mondrian level has: unique_members, column, type, name_column, ordinal_column

describe ::Rubiks::Level do
  include_context 'schema_context'

  subject { described_class.new_from_hash }

  specify { subject.respond_to?(:from_hash) }
  specify { subject.respond_to?(:to_hash) }

  context 'when parsed from a valid hash' do
    subject { described_class.new_from_hash(level_hash) }

    its(:to_hash) { should have_key('name') }

    it { should be_valid }
  end

  context 'when parsed from an invalid (empty) hash' do
    subject { described_class.new_from_hash({}) }

    it { should_not be_valid }
  end

end
