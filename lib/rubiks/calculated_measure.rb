module ::Rubiks

  class CalculatedMeasure < NamedObject
    def formula(new_value=nil, options={})
      @formula = new_value.to_s if new_value.present?
      @formula ||= @options[:formula]
    end

    def format_string(new_value=nil, options={})
      @format_string = new_value.to_s if new_value.present?
      @format_string ||= @options[:format_string]
    end

    def to_xml(builder = nil)
      builder = builder || new_builder

      xml_attrs = {:name => caption, :dimension => 'Measures'}
      xml_attrs[:formula] = formula if formula.present?
      xml_attrs[:formatString] = format_string if format_string.present?

      builder.calculatedMember(xml_attrs)
    end
  end

end
