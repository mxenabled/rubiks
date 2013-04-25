module ::Rubiks

  class Cube < NamedObject
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

    def to_xml(builder = nil)
      builder = builder || new_builder

      builder.cube(:name => caption) do
        builder.table(:name => "view_#{name.tableize}")
        dimensions.each{ |dimension| dimension.to_xml(builder) }
        measures.each{ |measure| measure.to_xml(builder) }
        calculated_measures.each{ |measure| measure.to_xml(builder) }
      end
    end
  end

end
