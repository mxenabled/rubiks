require 'spec_helper'

describe ::Rubiks::CalculatedMember do
  include_context 'schema_context'

  subject { described_class.new_from_hash }

  it_behaves_like 'an API node'
  it_behaves_like 'an annotated node'

  specify { subject.respond_to?(:dimension) }
  specify { subject.respond_to?(:formula) }
  specify { subject.respond_to?(:format_string) }

  context 'when parsed from a valid hash' do
    subject { described_class.new_from_hash(calculated_member_hash) }

    it { should be_valid }

    it_behaves_like 'a valid annotated node'

    %w[ dimension formula format_string ].each do |required_key|
      its(:to_hash) { should have_key(required_key) }
    end

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
