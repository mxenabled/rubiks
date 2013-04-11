require 'spec_helper'

describe ::Rubiks::Cube do
  include_context 'schema_context'

  subject { described_class.new_from_hash }

  specify { subject.respond_to?(:from_hash) }
  specify { subject.respond_to?(:to_hash) }
  specify { subject.respond_to?(:dimensions) }
  specify { subject.respond_to?(:measures) }
  specify { subject.respond_to?(:calculated_members) }

  context 'when parsed from a valid hash' do
    subject { described_class.new_from_hash(cube_hash) }

    it { should be_valid }

    its(:to_hash) { should have_key('name') }

    describe '#to_xml' do
      it 'renders a cube tag with attributes' do
        subject.to_xml.should include(%Q!<cube name="Fake Cube">!)
      end
    end
  end

  context 'when parsed with date_dimension' do
    subject { described_class.new_from_hash({'date_dimension' => 'Date'}) }
    its(:to_hash) { should have_key('date_dimension') }
  end

  context 'when parsed with person_dimension' do
    subject { described_class.new_from_hash({'person_dimension' => 'Date'}) }
    its(:to_hash) { should have_key('person_dimension') }
  end

  context 'when parsed with count_measure' do
    subject { described_class.new_from_hash({'count_measure' => 'Count'}) }
    its(:to_hash) { should have_key('count_measure') }
  end

  context 'when parsed with person_count_measure' do
    subject { described_class.new_from_hash({'person_count_measure' => 'Count'}) }
    its(:to_hash) { should have_key('person_count_measure') }
  end

  context 'when parsed from an invalid (empty) hash' do
    subject { described_class.new_from_hash({}) }

    it { should_not be_valid }

    describe '#to_xml' do
      it 'renders a dimension tag' do
        subject.to_xml.should be_like <<-XML
        <cube>
        </cube>
        XML
      end
    end
  end

end
