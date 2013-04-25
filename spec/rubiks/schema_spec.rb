require 'spec_helper'

describe ::Rubiks::Schema do
  context 'the class' do
    subject { described_class }

    it { should respond_to :define }

    describe '.define' do
      it 'returns a new instance' do
        new_schema = described_class.define { }
        new_schema.should be_kind_of ::Rubiks::Schema
      end

      it 'evaluates the block' do
        new_schema = described_class.define { name 'Sample Cube' }
        new_schema.name.should eq 'Sample Cube'
      end
    end
  end

  subject { described_class.new }

  it_behaves_like 'a named object'

  it { should respond_to :cube }

  its(:to_xml) { should be_equivalent_to(Nokogiri::XML(<<-XML)) }
    <schema name="Default">
    </schema>
  XML
end
