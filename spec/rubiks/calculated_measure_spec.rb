require 'spec_helper'

describe ::Rubiks::CalculatedMeasure do
  subject { described_class.new }

  it_behaves_like 'a named object'

  its(:to_xml) { should be_equivalent_to(Nokogiri::XML(<<-XML)) }
    <calculatedMember name="Default" dimension="Measures">
    </calculatedMember>
  XML
end
