module ::Rubiks

  class Measure < ::Rubiks::NamedObject
    def column(new_name=nil, options={})
      @column = new_name.to_s if new_name.present?
      @column ||= @options[:column] || name
    end

    def aggregator(new_name=nil, options={})
      @aggregator = new_name.to_s if new_name.present?
      @aggregator ||= @options[:aggregator] || 'count'
    end

    def format_string(new_value=nil, options={})
      @format_string = new_value.to_s if new_value.present?
      @format_string ||= @options[:format_string]
    end

    def measure(measure_name, options={}, &block)
      new_measure = ::Rubiks::Measure.new(measure_name.to_s, options)

      new_measure.instance_eval(&block) if block_given?

      measures.push(new_measure)

      new_measure
    end

    def to_xml(builder = nil)
      builder = builder || new_builder

      xml_attrs = {:name => caption, :column => column, :aggregator => aggregator}
      xml_attrs[:formatString] = format_string if format_string.present?
      builder.measure(xml_attrs)
    end
  end

end
