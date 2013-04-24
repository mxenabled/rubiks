require 'spec_helper'

describe ::Rubiks::Level do
  subject { described_class.new }

  it_behaves_like 'a named object'

  its(:to_xml) { should be_equivalent_to(Nokogiri::XML(<<-XML)) }
    <level name="Default" column="default"/>
  XML
end
