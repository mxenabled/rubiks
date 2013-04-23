module ::Rubiks

  module Dimension
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def attribute(name)
      end
    end
  end

end

    # dimension :dates

    # measure :unit_sales, :aggregator => :sum, :format_string => '$#,###'
    # measure :store_sales, :aggregator => :sum, :format_string => '$#,###'
    # measure :store_cost, :aggregator => :sum, :format_string => '$#,###'

    # calculated_member :profit, :dimension => :measures, :formula => '[Measures].[Store Sales] / [Measures].[Store Cost]', :format_string => '$#,###'


    # include ActiveAttr::Attributes

    # attribute :name
    # attribute 
