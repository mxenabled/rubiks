module ::Rubiks

  class Cube < NamedObject
    def date_dimension(new_value=nil)
      @date_dimension = new_value.to_s if new_value.present?
      @date_dimension ||= @options[:date_dimension]
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
      new_dimension = ::Rubiks::Dimension.new(dimension_name.to_s, options)

      new_dimension.instance_eval(&block) if block_given?

      dimensions.push(new_dimension)

      new_dimension
    end

    def measures
      @measures ||= []
    end

    def measure(measure_name, options={}, &block)
      new_measure = ::Rubiks::Measure.new(measure_name.to_s, options)

      new_measure.instance_eval(&block) if block_given?

      measures.push(new_measure)

      new_measure
    end

    def calculated_measures
      @calculated_measures ||= []
    end

    def calculated_measure(calculated_measure_name, options={}, &block)
      new_calculated_measure = ::Rubiks::CalculatedMeasure.new(calculated_measure_name.to_s, options)

      new_calculated_measure.instance_eval(&block) if block_given?

      calculated_measures.push(new_calculated_measure)

      new_calculated_measure
    end

    def json_hash
      hash = default_json_attributes.merge(
        :date_dimension => date_dimension,
        :person_dimension => person_dimension,
        :count_measure => count_measure,
        :person_count_measure => person_count_measure
      )
      hash[:dimensions] = dimensions.map{ |dim| dim.to_json }
      hash[:measures] = json_measures if json_measures.present?
      hash.delete_if { |key,value| value.nil? }
    end

    def to_xml(builder = nil)
      builder = builder || new_builder

      builder.cube(default_xml_attributes) do
        builder.table(:name => table_name)
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
