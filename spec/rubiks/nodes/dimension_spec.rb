require 'spec_helper'

describe ::Rubiks::Dimension do
  include_context 'schema_context'

  subject { described_class.new_from_hash }

  it_behaves_like 'an API node'
  it_behaves_like 'an annotated node'

  specify { subject.respond_to?(:hierarchies) }

  context 'when parsed from a valid hash' do
    subject { described_class.new_from_hash(dimension_hash) }

    its(:to_hash) { should have_key('hierarchies') }

    it { should be_valid }
    it_behaves_like 'a valid annotated node'

    describe '#to_xml' do
      it 'renders a dimension tag with attributes' do
        subject.to_xml.should include(%Q!<dimension name="Fake Dimension" foreignKey="fake_dimension_id">!)
      end
    end
  end

  context 'when parsed from an invalid (empty) hash' do
    subject { described_class.new_from_hash({}) }

    it { should_not be_valid }

    describe '#to_xml' do
      it 'renders a dimension tag' do
        subject.to_xml.should be_like <<-XML
        <dimension>
        </dimension>
        XML
      end
    end
  end

end
