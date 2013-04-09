require 'spec_helper'

describe ::Rubiks::Level do
  include_context 'schema_context'

  subject { described_class.new_from_hash }

  specify { subject.respond_to?(:from_hash) }
  specify { subject.respond_to?(:to_hash) }

  context 'when parsed from a valid hash' do
    subject { described_class.new_from_hash(level_hash) }

    its(:to_hash) { should have_key('name') }
    its(:to_hash) { should have_key('data_type') }
    its(:to_hash) { should have_key('editor_type') }

    it { should be_valid }

    describe '#to_json' do
      it 'includes the editor_type' do
        subject.to_json.should include('editor_type')
      end
    end

    describe '#to_xml' do
      it 'does not include the editor_type' do
        subject.to_xml.should_not include('editor_type')
      end

      it 'includes the type' do
        subject.to_xml.should include('type="Numeric"')
      end

      it 'renders a level tag with attributes' do
        subject.to_xml.should be_like <<-XML
        <level name="Fake Level" column="fake_level" type="Numeric"/>
        XML
      end
    end
  end

  context 'when parsed from an invalid (empty) hash' do
    subject { described_class.new_from_hash({}) }

    it { should_not be_valid }

    describe '#to_xml' do
      it 'renders a level tag' do
        subject.to_xml.should be_like <<-XML
        <level/>
        XML
      end
    end
  end

  context 'when parsed with an invalid editor_type' do
    subject { described_class.new_from_hash({'editor_type' => 'foo'}) }
    it { should_not be_valid }
  end

  context 'when parsed with an invalid data_type' do
    subject { described_class.new_from_hash({'data_type' => 'foo'}) }
    it { should_not be_valid }
  end

end
