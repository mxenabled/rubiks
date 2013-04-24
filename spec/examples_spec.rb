require 'spec_helper'

module MondrianExample
  class SalesSchema
    include Rubiks::Schema

    caption 'Sales'

    cube :sales
  end

  class Sales
    include Rubiks::Cube

    caption 'Sales'
    table 'sales_fact'

    dimension :time
    dimension :customer

    measure :unit_sales, :caption => 'Units'
    measure :store_sales
  end

  class Customer
    include Rubiks::Dimension
    key 'Name'

    attribute :name, :column => 'customer_id', :name_column => 'full_name'
    attribute :education
  end

  class Time
    include Rubiks::Dimension
    table 'time_by_day'
    type 'TimeDimension'

    attribute :year, :column => 'the_year', :level_type => 'TimeYears'
    attribute :id, :column => 'time_id'
  end

end

describe 'A Mondrian4 example from Mondrian In Action' do
  subject { MondrianExample::SalesSchema }

      #<PhysicalSchema>
      #  <Table name='customer'>
      #    <Key>
      #      <Column name='customer_id'/>
      #    </Key>
      #  </Table>
      #  <Table name='time_by_day'>
      #    <Key>
      #      <Column name='time_id'/>
      #    </Key>
      #  </Table>
      #  <Table name='sales_fact'/>
      #</PhysicalSchema>
  its(:to_xml) { #binding.pry#; should be_equivalent_to(
  #) }
  doc1 = Nokogiri::XML(subject.to_xml)
  doc2 = Nokogiri::XML(<<-XML)
<schema name='Sales'>
  <cube name='Sales'>
    <dimensions>
      <dimension name='Time' table='time_by_day' type='TimeDimension' key='id'>
        <attribute name='Year' keyColumn='the_year' levelType='TimeYears'/>
        <attribute name='Id' keyColumn='time_id'/>
      </dimension>
      <dimension name='Customer' key='Name'>
        <attribute name='Name' keyColumn='customer_id' nameColumn='full_name'/>
        <attribute name='Education' keyColumn='education'/>
      </dimension>
    </dimensions>
    <measureGroups>
      <measureGroup table='sales_fact'>
        <measures>
          <measure name='Units' column='unit_sales'/>
          <measure name='Store Sales' column='store_sales'/>
        </measures>
        <dimensionLinks>
          <foreignKeyLink dimension='Customer' foreignKeyColumn='customer_id'/>
          <foreignKeyLink dimension='Time' foreignKeyColumn='time_id'/>
        </dimensionLinks>
      </measureGroup>
    </measureGroups>
  </cube>
</schema>
  XML
  #binding.pry
  doc1.should be_equivalent_to(doc2)
  }

end
