require 'spec_helper'

describe ::Rubiks::Cube do
  subject { described_class.new }

  it_behaves_like 'a named object'

  its(:to_xml) { should be_equivalent_to(Nokogiri::XML(<<-XML)) }
    <cube name="Default">
      <table name="view_defaults"/>
    </cube>
  XML

  context 'with calculated measures' do
    subject {
      cube = described_class.new
      cube.calculated_measure :profit
      cube
    }

    its(:json_hash) { should_not have_key 'calculated_measures' }
    its(:json_hash) { should have_key 'measures' }

    it 'adds calculated measures to the measures array' do
      subject.json_hash['measures'].length.should eq 1
      subject.json_hash['measures'].first['name'].should eq 'profit'
    end
  end
end
