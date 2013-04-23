module ::Rubiks

  module Cube
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def display_name
        self.name.titleize
      end

      def to_hash
        hash = {}

        hash[:name] = self.name
        hash[:display_name] = self.display_name

        return hash
      end

      def to_xml(builder = nil)
        builder = Builder::XmlMarkup.new(:indent => 2) if builder.nil?

        builder.cube(:name => self.display_name) do
          builder.table(:name => "view_#{self.name.tableize}")
        end

#         attrs = Hash.new
#         attrs['name'] = self.name.titleize if self.name.present?
#         builder.cube(attrs) {
#           builder.table('name' => "view_#{self.name.tableize}") if self.name.present?
# 
#           self.dimensions.each{ |dim| dim.to_xml(builder) } if self.dimensions.present?
#           self.measures.each{ |measure| measure.to_xml(builder) } if self.measures.present?
#           self.calculated_members.each{ |calculated_member| calculated_member.to_xml(builder) } if self.calculated_members.present?
#         }

      end


      def dimension(name)
      end

      def measure(name)
      end

      def calculated_member(name)
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
