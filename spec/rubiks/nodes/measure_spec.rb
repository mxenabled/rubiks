require 'spec_helper'

describe ::Rubiks::Measure do
  include_context 'schema_context'

  subject { described_class.new_from_hash }

  specify { subject.respond_to?(:from_hash) }
  specify { subject.respond_to?(:to_hash) }
  specify { subject.respond_to?(:aggregator) }
  specify { subject.respond_to?(:format_string) }

  context 'when parsed from a valid hash' do
    subject { described_class.new_from_hash(measure_hash) }

    it { should be_valid }

    its(:to_hash) { should have_key('name') }
    its(:to_hash) { should have_key('aggregator') }
    its(:to_hash) { should have_key('format_string') }

    describe '#to_xml' do
      it 'renders a measure tag with attributes' do
        subject.to_xml.should be_like <<-XML
        <measure name="Fake Measure" column="fake_measure" aggregator="sum" formatString="#{subject.format_string}"/>
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
