require 'spec_helper'

describe ::Rubiks::CalculatedMember do
  include_context 'schema_context'

  subject { described_class.new_from_hash }

  specify { subject.respond_to?(:from_hash) }
  specify { subject.respond_to?(:to_hash) }
  specify { subject.respond_to?(:dimension) }
  specify { subject.respond_to?(:formula) }
  specify { subject.respond_to?(:format_string) }

  context 'when parsed from a valid hash' do
    subject { described_class.new_from_hash(calculated_member_hash) }

    it { should be_valid }

    its(:to_hash) { should have_key('name') }
    its(:to_hash) { should have_key('dimension') }
    its(:to_hash) { should have_key('formula') }
    its(:to_hash) { should have_key('format_string') }


    describe '#to_xml' do
      it 'renders a calculatedMember tag with attributes' do
        subject.to_xml.should be_like <<-XML
        <calculatedMember name="Fake Calculated Member" dimension="Fake Dimension" formula="fake_formula">
          <calculatedMemberProperty name="FORMAT_STRING" value="$#,##0.00"/>
        </calculatedMember>
        XML
      end
    end
  end

  context 'when parsed from an invalid (empty) hash' do
    subject { described_class.new_from_hash({}) }

    it { should_not be_valid }

    describe '#to_xml' do
      it 'renders a calculatedMember tag' do
        subject.to_xml.should be_like <<-XML
        <calculatedMember>
        </calculatedMember>
        XML
      end
    end
  end
end
