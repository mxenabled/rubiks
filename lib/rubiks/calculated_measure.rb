module ::Rubiks

  class CalculatedMeasure < NamedObject
    attribute :formula
    attribute :format_string

    def to_xml(builder = nil)
      builder = builder || new_builder

      builder.calculatedMember(:name => caption, :dimension => 'Measures') do
      end
    end
  end

end
