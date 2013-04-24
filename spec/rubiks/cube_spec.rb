require 'spec_helper'

describe ::Rubiks::Cube do
  let(:test_cube_class) { 
    class TestCube
      include ::Rubiks::Cube
    end
  }

  subject { test_cube_class }

  it { should respond_to :json_hash }
  it { should respond_to :to_json }
  it { should respond_to :to_xml }

  it { should respond_to :dimension }
  it { should respond_to :measure }
  it { should respond_to :calculated_member }

  its(:json_hash) { should have_key :name }
  its(:json_hash) { should have_key :caption }

  its(:to_xml) { should be_equivalent_to(Nokogiri::XML(<<-XML)) }
    <cube name="Test Cube">
      <dimensions>
      </dimensions>
      <measureGroups>
        <measureGroup table="test_cubes">
          <measures>
          </measures>
          <dimensionLinks>
          </dimensionLinks>
        </measureGroup>
      </measureGroups>
    </cube>
  XML
end
