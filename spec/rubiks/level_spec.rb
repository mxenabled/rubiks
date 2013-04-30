require 'spec_helper'

describe ::Rubiks::Level do
  subject { described_class.new }

  it_behaves_like 'a named object'

  its(:to_xml) { should be_equivalent_to(Nokogiri::XML(<<-XML)) }
    <level name="Default" column="default"/>
  XML

  context 'with UI attributes' do
    subject { described_class.new('default', :cardinality => :low, :contiguous => true ) }

    its(:json_hash) { should have_key 'cardinality' }
    its(:json_hash) { should have_key 'contiguous' }

    its(:xml_hash) { should_not have_key :cardinality }
  end

  context 'when hidden' do
    subject { described_class.new('default', :hidden => true) }

    it 'includes the hidden attribute' do
      subject.json_hash.should have_key 'hidden'
      subject.json_hash['hidden'].should eq 'true'
    end
  end
end
