require 'spec_helper'

describe ::Rubiks::Hierarchy do
  include_context 'schema_context'

  subject { described_class.new_from_hash }

  it_behaves_like 'an API node'
  it_behaves_like 'an annotated node'

  specify { subject.respond_to?(:levels) }

  context 'when parsed from a valid hash' do
    subject { described_class.new_from_hash(hierarchy_hash) }

    its(:to_hash) { should have_key('levels') }
    its(:to_hash) { should have_key('dimension') }

    it { should be_valid }
    it_behaves_like 'a valid annotated node'

    describe '#to_xml' do
      it 'renders a hierarchy tag with attributes' do
        subject.to_xml.should include(%Q!<hierarchy name="Fake Hierarchy" primaryKey="id" hasAll="true">!)
      end

      it 'renders a table tag with attributes' do
        subject.to_xml.should include(%Q!<table name="view_fake_dimensions"/>!)
      end
    end
  end

  context 'when parsed from an invalid (empty) hash' do
    subject { described_class.new_from_hash({}) }

    it { should_not be_valid }

    describe '#to_xml' do
      it 'renders a hierarchy and table tag' do
        subject.to_xml.should be_like <<-XML
        <hierarchy primaryKey="id" hasAll="true">
        <table/>
        </hierarchy>
        XML
      end
    end
  end

end
