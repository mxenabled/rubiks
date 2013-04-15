require 'spec_helper'

describe ::Rubiks::Measure do
  include_context 'schema_context'

  subject { described_class.new_from_hash }

  it_behaves_like 'an API node'
  it_behaves_like 'an annotated node'

  context 'when parsed from a valid hash' do
    subject { described_class.new_from_hash(measure_hash) }

    it { should be_valid }
    it_behaves_like 'a valid annotated node'

    its(:to_hash) { should have_key('aggregator') }
    its(:to_hash) { should have_key('format_string') }

    describe '#to_xml' do
      it 'renders a measure tag with attributes' do
        subject.to_xml.should be_like <<-XML
        <measure name="Fake Measure" aggregator="sum" formatString="#{subject.format_string}" column="fake_measure"/>
        XML
      end
    end
  end

  context 'when parsed with a specific column' do
    #subject { described_class.new_from_hash(measure_hash.merge('column' => 'foo')) }
    subject { described_class.new_from_hash('column' => 'foo') }

    describe '#to_xml' do
      it 'includes the specific column' do
        subject.to_xml.should be_like <<-XML
        <measure column="foo"/>
        XML
      end
    end
  end

  context 'when parsed from an invalid (empty) hash' do
    subject { described_class.new_from_hash({}) }

    it { should_not be_valid }

    describe '#to_xml' do
      it 'renders a measure tag' do
        subject.to_xml.should be_like <<-XML
        <measure/>
        XML
      end
    end
  end
end
