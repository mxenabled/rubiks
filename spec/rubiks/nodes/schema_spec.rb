require 'spec_helper'

describe ::Rubiks::Schema do
  include_context 'schema_context'

  subject { described_class.new_from_hash }

  specify { subject.respond_to?(:from_hash) }
  specify { subject.respond_to?(:to_hash) }
  specify { subject.respond_to?(:to_json) }
  specify { subject.respond_to?(:to_xml) }
  specify { subject.respond_to?(:cubes) }

  context 'when parsed from a valid hash' do
    subject { described_class.new_from_hash(schema_hash) }

    it { should be_valid }

    its(:to_hash) { should have_key('cubes') }
  end

  context 'when parsed from an invalid (empty) hash' do
    subject { described_class.new_from_hash({}) }

    it { should_not be_valid }

    describe '#to_xml' do
      it 'renders XML' do
        subject.to_xml.should be_like <<-XML
        <?xml version="1.0" encoding="UTF-8"?>
        <schema name="default">
        </schema>
        XML
      end
    end
  end

end
