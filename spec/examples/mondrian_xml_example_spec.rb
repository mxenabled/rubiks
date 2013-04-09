require 'spec_helper'

# This example is taken from the Mondrian documentation:
# http://mondrian.pentaho.com/documentation/schema.php#Cubes_and_dimensions
# and then modified to use Rails/Rubiks conventions
#
# We want the output to be:
#
# <Schema>
#   <Cube name="Sales">
#     <Table name="view_sales"/>
#
#     <Dimension name="Gender" foreignKey="customer_id">
#       <Hierarchy hasAll="true" allMemberName="All Genders" primaryKey="id">
#         <Table name="customers"/>
#         <Level name="Gender" column="gender" uniqueMembers="true"/>
#       </Hierarchy>
#     </Dimension>
#
#     <Dimension name="Date" foreignKey="date_id">
#       <Hierarchy hasAll="false" primaryKey="id">
#         <Table name="view_dates"/>
#         <Level name="Year" column="year" type="Numeric" uniqueMembers="true"/>
#         <Level name="Quarter" column="quarter" uniqueMembers="false"/>
#         <Level name="Month" column="month_of_year" type="Numeric" uniqueMembers="false"/>
#       </Hierarchy>
#     </Dimension>
#
#     <Measure name="Unit Sales" column="unit_sales" aggregator="sum" formatString="#,###"/>
#     <Measure name="Store Sales" column="store_sales" aggregator="sum" formatString="#,###.##"/>
#     <Measure name="Store Cost" column="store_cost" aggregator="sum" formatString="#,###.00"/>
#
#     <CalculatedMember name="Profit" dimension="Measures" formula="[Measures].[Store Sales] - [Measures].[Store Cost]">
#       <CalculatedMemberProperty name="FORMAT_STRING" value="$#,##0.00"/>
#     </CalculatedMember>
#   </Cube>
# </Schema>

describe 'A basic Mondrian XML Schema' do
  let(:described_class) { ::Rubiks::Schema }
  let(:schema_hash) {
    {
      'cubes' => [{
        'name' => 'sales',
        'measures' => [
          {
            'name' => 'unit_sales',
            'format_string' => '#,###'
          },
          {
            'name' => 'store_sales',
            'format_string' => '#,###.##'
          },
          {
            'name' => 'store_cost',
            'format_string' => '#,###.00'
          }
        ],
        'dimensions' => [
          {
            'name' => 'date',
            'hierarchies' => [{
              'name' => 'year_quarter_month',
              'levels' => [
                {
                  'name' => 'year',
                  'type' => 'numeric',
                  'unique_members' => true
                },
                {
                  'name' => 'quarter'
                },
                {
                  'name' => 'month'
                }
              ]
            }]
          }
        ]
      }]
    }
  }

  subject { described_class.new_from_hash(schema_hash) }

  describe '#to_xml' do
    it 'renders XML' do
      subject.to_xml.should be_like <<-XML
      <?xml version="1.0" encoding="UTF-8"?>

      <Schema>
        <Cube name="Sales">
          <Table name="view_sales"/>

          <Dimension name="Gender" foreignKey="customer_id">
            <Hierarchy hasAll="true" allMemberName="All Genders" primaryKey="id">
              <Table name="customers"/>
              <Level name="Gender" column="gender" uniqueMembers="true"/>
            </Hierarchy>
          </Dimension>

          <Dimension name="Date" foreignKey="date_id">
            <Hierarchy hasAll="false" primaryKey="id">
              <Table name="view_dates"/>
              <Level name="Year" column="year" type="Numeric" uniqueMembers="true"/>
              <Level name="Quarter" column="quarter" uniqueMembers="false"/>
              <Level name="Month" column="month_of_year" type="Numeric" uniqueMembers="false"/>
            </Hierarchy>
          </Dimension>

          <Measure name="Unit Sales" column="unit_sales" aggregator="sum" formatString="#,###"/>
          <Measure name="Store Sales" column="store_sales" aggregator="sum" formatString="#,###.##"/>
          <Measure name="Store Cost" column="store_cost" aggregator="sum" formatString="#,###.00"/>

          <CalculatedMember name="Profit" dimension="Measures" formula="[Measures].[Store Sales] - [Measures].[Store Cost]">
            <CalculatedMemberProperty name="FORMAT_STRING" value="$#,##0.00"/>
          </CalculatedMember>
        </Cube>
      </Schema>


      <schema>
      <cube name="sales">
        <table name="view_sales"/>

        <Dimension name="Date" foreignKey="date_id">
          <Hierarchy hasAll="false" primaryKey="id">
            <Table name="view_dates"/>
            <Level name="Year" column="year" type="Numeric" uniqueMembers="true"/>
            <Level name="Quarter" column="quarter" uniqueMembers="false"/>
            <Level name="Month" column="month_of_year" type="Numeric" uniqueMembers="false"/>
          </Hierarchy>
        </Dimension>
      </cube>
      </schema>
      XML
    end
  end

end
