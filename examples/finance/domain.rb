module Dimensions
  class Account < ActiveRecord::Base
    include Rubiks::Dimension

    hierarchy 'Asset/Liability' do
      level :asset_liability
      level :account_type
    end

    hierarchy 'Institution' do
      level :institution
    end
  end

  class Customer < ActiveRecord::Base
    include Rubiks::Dimension

    hierarchy 'Gender' do
      level :gender
    end
  end

  class Date < ActiveRecord::Base
    include Rubiks::Dimension

    hierarchy 'Date' do
      level :year
      level :quarter
      level :month
    end
  end
end

module Facts
  class AccountSnapshot < ActiveRecord::Base
    include Rubiks::Fact

    dimension :account
    dimension :customer
    dimension :date

    measure :balance
  end
end
