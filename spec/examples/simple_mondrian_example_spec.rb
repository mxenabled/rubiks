require 'spec_helper'

#  This schema is a valid XML schema for Mondrian
#
#  <?xml version="1.0" encoding="UTF-8"?>
#  <schema name="default">
#    <cube name="Transactions">
#      <table name="view_transactions"/>
#      <dimension name="Date" foreignKey="date_id">
#        <hierarchy name="Year Quarter Month" primaryKey="id" hasAll="true">
#          <table name="view_dates"/>
#          <level name="Year" column="year"/>
#          <level name="Quarter" column="quarter"/>
#          <level name="Month" column="month"/>
#        </hierarchy>
#      </dimension>
#      <measure name="Amount" column="amount" aggregator="sum" formatString="$#,###"/>
#    </cube>
#  </schema>

describe 'A simple Mondrian XML Schema' do
  let(:described_class) { ::Rubiks::Schema }
  let(:schema_hash) {
    {
      'cubes' => [{
        'name' => 'transactions',
        'measures' => [
          {
            'name' => 'amount',
            'aggregator' => 'sum',
            'format_string' => '$#,###'
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
                  'type' => 'numeric'
                },
                {
                  'name' => 'month',
                  'type' => 'numeric'
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
        <schema name="default">
          <cube name="Transactions">
            <table name="view_transactions"/>
            <dimension name="Date" foreignKey="date_id">
              <hierarchy name="Year Quarter Month" primaryKey="id" hasAll="true">
                <table name="view_dates"/>
                <level name="Year" column="year"/>
                <level name="Quarter" column="quarter"/>
                <level name="Month" column="month"/>
              </hierarchy>
            </dimension>
            <measure name="Amount" column="amount" aggregator="sum" formatString="$#,###"/>
          </cube>
        </schema>
      XML
    end
  end

end
