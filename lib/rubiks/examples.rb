require 'rubiks'
require 'yaml'

module ::Rubiks
  module Examples

    # This example is taken from the Mondrian documentation:
    # http://mondrian.pentaho.com/documentation/schema.php#Cubes_and_dimensions
    # then modified to use Rails/Rubiks conventions
    #
    # We want the output to be:
    #
    # <?xml version="1.0" encoding="UTF-8"?>
    # <schema name="default">
    #   <cube name="Sales">
    #     <table name="view_sales"/>
    #
    #     <dimension name="Date" foreignKey="date_id">
    #       <hierarchy name="Year Quarter Month" primaryKey="id" hasAll="true">
    #         <table name="view_dates"/>
    #         <level name="Year" column="the_year" type="Numeric"/>
    #         <level name="Quarter" column="quarter" type="String"/>
    #         <level name="Month" column="month_of_year" type="Numeric"/>
    #       </hierarchy>
    #     </dimension>
    #
    #     <measure name="Unit Sales" aggregator="sum" formatString="#,###" column="unit_sales"/>
    #     <measure name="Store Sales" aggregator="sum" formatString="#,###" column="store_sales"/>
    #     <measure name="Store Cost" aggregator="sum" formatString="#,###" column="store_cost"/>
    #
    #     <calculatedMember name="Profit" dimension="Measures" formula="[Measures].[Store Sales] / [Measures].[Store Cost]">
    #       <calculatedMemberProperty name="FORMAT_STRING" value="$#,##0.00"/>
    #     </calculatedMember>
    #   </cube>
    # </schema>
    class MondrianDocs
      class << self
        def filename
          File.expand_path('../../../spec/support/examples/mondrian_docs.yml', __FILE__)
        end

        def file_contents
          File.read(self.filename)
        end

        def hash
          YAML.load_file(self.filename)
        end

        def schema
          ::Rubiks::Schema.new_from_hash(self.hash)
        end

        def to_xml
          self.schema.to_xml
        end
      end
    end

  end
end
