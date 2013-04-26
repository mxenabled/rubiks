require 'spec_helper'

describe ::Rubiks::Dimension do
  subject { described_class.new }

  it_behaves_like 'a named object'

  its(:to_xml) { should be_equivalent_to(Nokogiri::XML(<<-XML)) }
    <dimension name="Default" foreignKey="default_id">
    </dimension>
  XML
end
