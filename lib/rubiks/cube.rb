module ::Rubiks

  module Cube
    def self.included(klass)
      klass.extend(::Rubiks::UiAttributes::ClassMethods)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def json_hash
        hash = {}

        hash[:name] = self.name
        hash[:caption] = self.caption

        return hash
      end

      def table(new_table = nil)
        @table = new_table if new_table.present?
        @table ||= self.name.split('::').last.tableize
      end

      def to_xml(builder = nil)
        builder = Builder::XmlMarkup.new(:indent => 2) if builder.nil?

        builder.cube(:name => self.caption) do
          builder.dimensions do
            dimension_classes.each{ |dimension_class| dimension_class.to_xml(builder) }
          end

          builder.measureGroups do
            builder.measureGroup(:table => self.table) do
              builder.measures do
                measures.each do |measure_attrs|
                  builder.measure(measure_attrs)
                end
              end
              builder.dimensionLinks do
                dimension_classes.each do |dimension_class|
                  dimension_table_name = dimension_class.name.split('::').last.underscore

                  link_attrs = {
                    :dimension => dimension_class.caption,
                    :foreignKeyColumn => "#{dimension_table_name}_id"
                  }
                  builder.foreignKeyLink(link_attrs)
                end
              end
            end
          end
        end
      end

      def to_json
        MultiJson.dump(self.json_hash)
      end

      def dimension(name_or_class)
        dimensions.push(name_or_class)
      end

      def dimensions
        @dimensions ||= Array.new
      end

      def dimension_classes
        dimensions.map do |name_or_class|
          name_or_class.kind_of?(Class) ?
            name_or_class :
            "#{parent_name}::#{name_or_class.to_s.camelize}".constantize
        end
      end

      def measure(measure_name, options={})
        xml_options = {
          'column' => measure_name.to_s.underscore,
          'name' => options[:caption] || measure_name.to_s.titleize
        }
        measures.push(xml_options)
      end

      def measures
        @measures ||= Array.new
      end


      def calculated_member(name)
      end
    end
  end

end
