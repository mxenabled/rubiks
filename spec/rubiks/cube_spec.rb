require 'spec_helper'

describe ::Rubiks::Cube do
  # API
  specify { subject.respond_to?(:from_hash) }
  specify { subject.respond_to?(:to_hash) }

  context 'when parsed from a valid hash' do
    subject { described_class.new.from_hash('name' => 'fake_cube') }

    its(:name) { should eq('fake_cube') }

    its(:to_hash) { should have_key('name') }

    it { should be_valid }
  end


  context 'when parsed from an invalid (empty) hash' do
    subject { described_class.new.from_hash({}) }

    it { should_not be_valid }
  end

end
