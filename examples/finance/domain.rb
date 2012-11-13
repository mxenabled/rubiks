class DimAccount < ActiveRecord::Base
  include Rubiks::Dimension

  hierarchy 'Asset/Liability' do
    level :asset_liability
    level :account_type
  end

  hierarchy 'Institution' do
    level :institution
  end
end

class DimCustomer < ActiveRecord::Base
  include Rubiks::Dimension

  hierarchy 'Gender' do
    level :gender
  end
end

class DimDate < ActiveRecord::Base
  include Rubiks::Dimension

  hierarchy 'Date' do
    level :year
    level :quarter
    level :month
  end
end

class CubeAccountSnapshot < ActiveRecord::Base
  include Rubiks::Cube

  dimension :account
  dimension :customer
  dimension :date

  measure :balance
end
