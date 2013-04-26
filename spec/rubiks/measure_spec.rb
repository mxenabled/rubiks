require 'spec_helper'

describe ::Rubiks::Measure do
  subject { described_class.new }

  it_behaves_like 'a named object'

  its(:to_xml) { should be_equivalent_to(Nokogiri::XML(<<-XML)) }
    <measure name="Default" column="default" aggregator="count"/>
  XML
end
