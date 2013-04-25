module ::Rubiks

  class Level < ::Rubiks::NamedObject
    def name_column(new_value=nil)
      @name_column = new_value.to_s if new_value.present?
      @name_column ||= @options[:name_column]
    end

    def ordinal_column(new_value=nil)
      @ordinal_column = new_value.to_s if new_value.present?
      @ordinal_column ||= @options[:ordinal_column]
    end

    def level_type(new_value=nil)
      @level_type = new_value.to_s if new_value.present?
      @level_type ||= @options[:level_type]
    end

    def data_type(new_value=nil)
      @data_type = new_value if new_value.present?
      @data_type ||= @options[:data_type]
    end

    def to_xml(builder = nil)
      builder = builder || new_builder

      xml_attrs = {:name => caption, :column => column}
      xml_attrs[:type] = data_type.to_s.titleize if data_type.present?
      builder.level(xml_attrs)
    end
  end

end
