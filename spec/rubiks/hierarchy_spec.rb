require 'spec_helper'

describe ::Rubiks::Hierarchy do
  subject { described_class.new }

  it_behaves_like 'a named object'

  it { should respond_to :level }

  its(:to_xml) { should be_equivalent_to(Nokogiri::XML(<<-XML)) }
    <hierarchy name="Default" primaryKey="id" hasAll="true" allMemberName="All">
      <table name="view_defaults"/>
    </hierarchy>
  XML
end
