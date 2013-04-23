require 'spec_helper'

describe ::Rubiks::Dimension do
  let(:test_cube_class) { 
    class TestDimension
      include ::Rubiks::Dimension
    end
  }

  subject { test_cube_class }

  it { should respond_to :json_hash }
  it { should respond_to :to_json }
  it { should respond_to :to_xml }

  it { should respond_to :attribute }
  it { should respond_to :hierarchy }

  its(:json_hash) { should have_key :name }
  its(:json_hash) { should have_key :display_name }

  its(:to_xml) { should be_equivalent_to(Nokogiri::XML(<<-XML)) }
    <dimension name="Test Dimension">
    </dimension>
  XML
end

# <?xml version="1.0" encoding="UTF-8"?>
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
