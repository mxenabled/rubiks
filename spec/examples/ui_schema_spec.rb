require 'spec_helper'

describe 'A schema with UI specific attributes' do
  subject {
    ::Rubiks::Schema.define :transactions do
      cube :transactions, :description => 'Financial transactions', :time_dimension => :date do
        dimension :date, :description => 'One row per day' do
          hierarchy :year_quarter_month, :description => 'YQM' do
            level :year, :type => :numeric, :description => 'Year', :contiguous => true
            level :quarter, :type => :string, :description => 'Quarter', :contiguous => true
            level :month, :type => :numeric, :description => 'Month', :contiguous => true
          end
          hierarchy :weekday_weekend do
            level :weekday_weekend, :type => :string, :cardinality => :low
          end
        end

        dimension :client, :visible => false do
          hierarchy :name do
            level :name, :type => :string, :description => 'Client name'
          end
        end

        measure :sales, :aggregator => 'sum', :format_string => '$#,###'
        measure :cost, :aggregator => 'sum', :format_string => '$#,###'
      end
    end
  }

  # describe '#json_hash' do
  #   it 'includes ui attributes' do
  #     binding.pry
  #     subject.json_hash.should match_json_expression(
  #       :cubes => {}
  #     )
  #   end
  # end

  its(:to_xml) { should be_equivalent_to(Nokogiri::XML(<<-XML)) }
    <schema name="Transactions">
      <cube name="Transactions" description="Financial transactions">
        <table name="view_transactions"/>
        <dimension name="Date" foreignKey="date_id" description="One row per day">
          <hierarchy name="Year Quarter Month" primaryKey="id" hasAll="true" description="YQM">
            <table name="view_dates"/>
            <level name="Year" column="year" type="Numeric" description="Year"/>
            <level name="Quarter" column="quarter" type="String" description="Quarter"/>
            <level name="Month" column="month" type="Numeric" description="Month"/>
          </hierarchy>
           <hierarchy name="Weekday Weekend" primaryKey="id" hasAll="true">
             <table name="view_dates"/>
             <level name="Weekday Weekend" column="weekday_weekend" type="String"/>
           </hierarchy>
        </dimension>
        <dimension name="Client" foreignKey="client_id" visible="false">
          <hierarchy name="Name" primaryKey="id" hasAll="true">
            <table name="view_clients"/>
            <level name="Name" column="name" type="String" description="Client name"/>
          </hierarchy>
        </dimension>
        <measure name="Sales" aggregator="sum" column="sales" formatString="$#,###"/>
        <measure name="Cost" aggregator="sum" column="cost" formatString="$#,###"/>
      </cube>
    </schema>
  XML
end
