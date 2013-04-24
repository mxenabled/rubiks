require 'spec_helper'

describe ::Rubiks::Schema do
  subject { described_class.new }

  it_behaves_like 'a named object'

  it { should respond_to :cube }

  its(:to_xml) { should be_equivalent_to(Nokogiri::XML(<<-XML)) }
    <schema name="Default">
    </schema>
  XML
end

# <schema name="default">
#   <cube name="Sales">
#     <table name="view_sales"/>
#     <dimension name="Date" foreignKey="date_id">
#       <hierarchy name="Year Quarter Month" primaryKey="id" hasAll="true">
#         <table name="view_dates"/>
#         <level name="Year" column="the_year" type="Numeric"/>
#         <level name="Quarter" column="quarter" type="String"/>
#         <level name="Month" column="month_of_year" type="Numeric"/>
#       </hierarchy>
#     </dimension>
#     <measure name="Unit Sales" aggregator="sum" formatString="#,###" column="unit_sales"/>
#     <measure name="Store Sales" aggregator="sum" formatString="#,###" column="store_sales"/>
#     <measure name="Store Cost" aggregator="sum" formatString="#,###" column="store_cost"/>
#     <calculatedMember name="Profit" dimension="Measures" formula="[Measures].[Store Sales] / [Measures].[Store Cost]">
#       <calculatedMemberProperty name="FORMAT_STRING" value="$#,##0.00"/>
#     </calculatedMember>
#   </cube>
# </schema>
