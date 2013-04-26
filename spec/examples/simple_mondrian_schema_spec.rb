require 'spec_helper'

describe 'A simple Mondrian schema' do
  subject {
    ::Rubiks::Schema.define :banking do
      cube :transactions do
        dimension :date, :type => 'TimeDimension' do
          hierarchy :yqmwd, :caption => 'YQMWD' do
            level :year,    :level_type => 'TimeYears', :type => :numeric, :contiguous => true
            level :quarter, :level_type => 'TimeQuarters', :type => :numeric, :contiguous => true, :cardinality => :low
            level :month,   :level_type => 'TimeMonths', :type => :numeric, :contiguous => true
            level :week,    :level_type => 'TimeWeeks', :type => :numeric, :column => :week_of_month, :contiguous => true, :cardinality => :low
            level :day,     :level_type => 'TimeDays', :type => :numeric, :contiguous => true
          end
        end

        dimension :account do
          hierarchy :account_type do
            level :asset_liability, :cardinality => :low
            level :account_type
          end
        end

        measure :count, :column => :quantity
        measure :amount, :aggregator => :sum, :format_string => '$#,###'
      end
    end
  }

  its(:to_xml) { should be_equivalent_to(Nokogiri::XML(<<-XML)) }
    <schema name="Banking">
      <cube name="Transactions">
        <table name="view_transactions"/>
        <dimension name="Date" foreignKey="date_id" type="TimeDimension">
          <hierarchy name="YQMWD" hasAll="true" primaryKey="id">
            <table name="view_dates"/>
            <level name="Year" column="year" levelType="TimeYears" type="Numeric"/>
            <level name="Quarter" column="quarter" levelType="TimeQuarters" type="Numeric"/>
            <level name="Month" column="month" levelType="TimeMonths" type="Numeric"/>
            <level name="Week" column="week_of_month" levelType="TimeWeeks" type="Numeric"/>
            <level name="Day" column="day" levelType="TimeDays" type="Numeric"/>
          </hierarchy>
        </dimension>
        <dimension name="Account" foreignKey="account_id">
          <hierarchy name="Account Type" hasAll="true" primaryKey="id">
            <table name="view_accounts"/>
            <level name="Asset Liability" column="asset_liability"/>
            <level name="Account Type" column="account_type"/>
          </hierarchy>
        </dimension>
        <measure name="Count" column="quantity" aggregator="count"/>
        <measure name="Amount" column="amount" aggregator="sum" formatString="$#,###"/>
      </cube>
    </schema>
  XML
end
