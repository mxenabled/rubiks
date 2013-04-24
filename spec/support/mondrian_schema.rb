module MondrianSchema

  class SalesCube
    include Rubiks::Cube

    dimension :dates

    measure :unit_sales, :aggregator => :sum, :format_string => '$#,###'
    measure :store_sales, :aggregator => :sum, :format_string => '$#,###'
    measure :store_cost, :aggregator => :sum, :format_string => '$#,###'

    calculated_member :profit, :dimension => :measures, :formula => '[Measures].[Store Sales] / [Measures].[Store Cost]', :format_string => '$#,###'
  end

  class DateDimension
    include Rubiks::Dimension

    attribute :year, :column => 'the_year', :data_type => :numeric
    attribute :quarter, :column => 'quarter', :data_type => :string
    attribute :month, :column => 'month_of_year', :data_type => :numeric

    hierarchy :yqmd do |h|
      h.level :year
      h.level :quarter
      h.level :month
    end
  end

end


# <?xml version='1.0'?>
# <Schema name='Sales'>
#   <PhysicalSchema>
#     <Table name='customer'>
#       <Key>
#         <Column name='customer_id'/>
#       </Key>
#     </Table>
#     <Table name='time_by_day'>
#       <Key>
#         <Column name='time_id'/>
#       </Key>
#     </Table>
#     <Table name='sales_fact'/>
#   </PhysicalSchema>
#   <Cube name='Sales'>
#     <Dimensions>
#       <Dimension name='Time' table='time_by_day'
#         type='TimeDimension' key='Id'>
#         <Attribute name='Year' keyColumn='the_year'
#         levelType='TimeYears'/>
#         <Attribute name='Id' keyColumn='time_id'/>
#       </Dimension>
#       <Dimension name='Customer' key='Name'>
#         <Attribute name='Name' keyColumn='customer_id'
#         nameColumn='full_name'/>
#         <Attribute name='Education' keyColumn='education'/>
#       </Dimension>
#     </Dimensions>
#     <MeasureGroups>
#       <MeasureGroup table='sales_fact'>
#         <Measures>
#           <Measure name='Units' column='unit_sales'/>
#           <Measure name='Store Sales' column='store_sales'/>
#         </Measures>
#         <DimensionLinks>
#           <ForeignKeyLink dimension='Customer' foreignKeyColumn='customer_id'/>
#           <ForeignKeyLink dimension='Time' foreignKeyColumn='time_id'/>
#         </DimensionLinks>
#       </MeasureGroup>
#     </MeasureGroups>
#   </Cube>
# </Schema>
