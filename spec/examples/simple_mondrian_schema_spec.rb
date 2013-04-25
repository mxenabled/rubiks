require 'spec_helper'

describe 'A simple Mondrian schema' do
  subject {
    ::Rubiks::Schema.define do
      name :sales

      cube :sales do
        name :sales
        dimension :date do
          hierarchy :year_quarter_month do
            level :year, :data_type => :numeric
            level :quarter, :data_type => :string
            level :month, :data_type => :numeric
          end
        end
        measure :sales, :aggregator => 'sum', :format_string => '$#,###'
        measure :cost, :aggregator => 'sum', :format_string => '$#,###'
        calculated_measure :profit, :formula => '[Measures].[Sales] - [Measures].[Cost]', :format_string => '$#,###'
      end

    end
  }

  its(:to_xml) { should be_equivalent_to(Nokogiri::XML(<<-XML)) }
    <schema name="Sales">
      <cube name="Sales">
        <table name="view_sales"/>
        <dimension name="Date" foreignKey="date_id">
          <hierarchy name="Year Quarter Month" primaryKey="id" hasAll="true">
            <table name="view_dates"/>
            <level name="Year" column="year" type="Numeric"/>
            <level name="Quarter" column="quarter" type="String"/>
            <level name="Month" column="month" type="Numeric"/>
          </hierarchy>
        </dimension>
        <measure name="Sales" aggregator="sum" column="sales" formatString="$#,###"/>
        <measure name="Cost" aggregator="sum" column="cost" formatString="$#,###"/>
        <calculatedMember name="Profit" dimension="Measures" formula="[Measures].[Sales] - [Measures].[Cost]" formatString="$#,###"/>
      </cube>
    </schema>
  XML
end
