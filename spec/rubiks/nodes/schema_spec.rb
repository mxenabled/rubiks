require 'spec_helper'

describe ::Rubiks::Nodes::Schema do
  subject { described_class.new([]) }

  # API
  specify { subject.respond_to?(:from_hash) }
  specify { subject.respond_to?(:to_hash) }

  context 'when parsed from a valid hash' do
    # subject { described_class.new([]).from_hash({}) }
    subject {
      described_class.new([]).from_hash({
        'cubes' => [{'name' => 'fake_cube'}]
      })
    }

    it 'has a cube' do
      subject.cubes.length.should eq 1
    end

    its(:to_hash) { should have_key('cubes') }

    it { should be_valid }
  end

  context 'when parsed from an invalid (empty) hash' do
    subject { described_class.new([]).from_hash({}) }

    it { should_not be_valid }
  end

end
