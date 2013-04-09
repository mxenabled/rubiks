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
