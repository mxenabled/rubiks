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
