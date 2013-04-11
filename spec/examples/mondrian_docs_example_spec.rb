require 'spec_helper'

# This example is taken from the Mondrian documentation:
# http://mondrian.pentaho.com/documentation/schema.php#Cubes_and_dimensions
# then modified to use Rails/Rubiks conventions
#
# We want the output to be:
#
# <schema name="default">
#   <cube name="Sales">
#     <table name="view_sales"/>
#
#     <dimension name="Date" foreignKey="date_id">
#       <hierarchy name="Year Quarter Month" primaryKey="id" hasAll="true">
#         <table name="view_dates"/>
#         <level name="Year" column="year"/>
#         <level name="Quarter" column="quarter"/>
#         <level name="Month" column="month"/>
#       </hierarchy>
#     </dimension>
#
#     <measure name="Unit Sales" column="unit_sales" aggregator="sum" formatString="#,###"/>
#
#     <calculatedMember name="Profit" dimension="Measures" formula="[Measures].[Store Sales] - [Measures].[Store Cost]">
#       <calculatedMemberProperty name="FORMAT_STRING" value="$#,##0.00"/>
#     </calculatedMember>
#   </cube>
# </schema>

describe 'A Mondrian XML Schema' do
  let(:described_class) { ::Rubiks::Schema }
  let(:schema_hash) {
    {
      'cubes' => [{
        'name' => 'sales',
        'measures' => [
          {
            'name' => 'unit_sales',
            'aggregator' => 'sum',
            'format_string' => '#,###'
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
                  'type' => 'numeric'
                },
                {
                  'name' => 'quarter',
                  'type' => 'string'
                },
                {
                  'name' => 'month',
                  'type' => 'numeric'
                }
              ]
            }]
          }
        ],
        'calculated_members' => [
          {
            'name' => 'Profit',
            'dimension' => 'Measures',
            'formula' => '[Measures].[Store Sales] - [Measures].[Store Cost]',
            'format_string' => '$#,##0.00'
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

      <schema name="default">
        <cube name="Sales">
          <table name="view_sales"/>

          <dimension name="Date" foreignKey="date_id">
            <hierarchy name="Year Quarter Month" primaryKey="id" hasAll="true">
              <table name="view_dates"/>
              <level name="Year" column="year"/>
              <level name="Quarter" column="quarter"/>
              <level name="Month" column="month"/>
            </hierarchy>
          </dimension>

          <measure name="Unit Sales" aggregator="sum" formatString="#,###" column="unit_sales"/>

          <calculatedMember name="Profit" dimension="Measures" formula="[Measures].[Store Sales] - [Measures].[Store Cost]">
            <calculatedMemberProperty name="FORMAT_STRING" value="$#,##0.00"/>
          </calculatedMember>
        </cube>
      </schema>
      XML
    end
  end

end
