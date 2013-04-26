module ::Rubiks

  class Cube < NamedObject
    def time_dimension(new_value=nil)
      @time_dimension = new_value.to_s if new_value.present?
      @time_dimension ||= @options[:time_dimension]
    end

    def person_dimension(new_value=nil)
      @person_dimension = new_value.to_s if new_value.present?
      @person_dimension ||= @options[:person_dimension]
    end

    def count_measure(new_value=nil)
      @count_measure = new_value.to_s if new_value.present?
      @count_measure ||= @options[:count_measure]
    end

    def person_count_measure(new_value=nil)
      @person_count_measure = new_value.to_s if new_value.present?
      @person_count_measure ||= @options[:person_count_measure]
    end

    def dimensions
      @dimensions ||= []
    end

    def dimension(dimension_name, options={}, &block)
      dimensions.push ::Rubiks::Dimension.find_or_create(dimension_name, options, &block)
    end

    def measures
      @measures ||= []
    end

    def measure(measure_name, options={}, &block)
      measures.push ::Rubiks::Measure.find_or_create(measure_name, options, &block)
    end

    def calculated_measures
      @calculated_measures ||= []
    end

    def calculated_measure(calculated_measure_name, options={}, &block)
      calculated_measures.push ::Rubiks::CalculatedMeasure.find_or_create(calculated_measure_name, options, &block)
    end

    def json_hash
      hash = default_json_attributes.merge(
        :time_dimension => time_dimension.to_s,
        :person_dimension => person_dimension.to_s,
        :count_measure => count_measure.to_s,
        :person_count_measure => person_count_measure.to_s,
        :dimensions => dimensions.map{ |dim| dim.json_hash },
        :measures => json_measures
      )
      hash.delete_if { |key,value| value.nil? || value.blank? }
      hash.stringify_keys!
    end

    def to_xml(builder = nil)
      builder = builder || new_builder

      builder.cube(default_xml_attributes) do
        builder.table(:name => table)
        dimensions.each{ |dimension| dimension.to_xml(builder) }
        measures.each{ |measure| measure.to_xml(builder) }
        calculated_measures.each{ |measure| measure.to_xml(builder) }
      end
    end

    def json_measures
      json_measures = []
      json_measures.push(*measures.map{ |m| m.json_hash })
      json_measures.push(*calculated_measures.map{ |cm| cm.json_hash })
      json_measures
    end
  end

end
