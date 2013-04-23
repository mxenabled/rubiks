require 'spec_helper'

describe ::Rubiks::Cube do
  let(:test_cube_class) { 
    class TestCube
      include ::Rubiks::Cube
    end
  }

  subject { test_cube_class }

  it { should respond_to :to_hash }
  it { should respond_to :to_xml }

  it { should respond_to :dimension }
  it { should respond_to :measure }
  it { should respond_to :calculated_member }

  its(:to_hash) { should have_key :name }
  its(:to_hash) { should have_key :display_name }

  describe '#to_xml' do
    subject { test_cube_class.to_xml }

    it { should be_equivalent_to(Nokogiri::XML(<<-XML)) }
      <cube name="Test Cube">
        <table name="view_test_cubes"/>
      </cube>
    XML
  end
end
