require 'spec_helper'

describe ::Rubiks::Schema do
  let(:test_schema_class) { 
    class TestSchema
      include ::Rubiks::Schema
    end
  }

  subject { test_schema_class }

  it { should respond_to :json_hash }
  it { should respond_to :to_json }
  it { should respond_to :to_xml }

  it { should respond_to :cube }

  its(:json_hash) { should have_key :name }
  its(:json_hash) { should have_key :caption }

  its(:to_xml) { should be_equivalent_to(Nokogiri::XML(<<-XML)) }
    <schema name="Test Schema">
    </schema>
  XML
end
