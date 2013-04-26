module ::Rubiks

  class Level < ::Rubiks::NamedObject
    def cardinality(new_value=nil)
      @cardinality = new_value.to_s if new_value.present?
      @cardinality ||= @options[:cardinality]
    end

    def contiguous(new_value=nil)
      @contiguous = new_value.to_s if new_value.present?
      @contiguous ||= @options.key?(:contiguous) ? @options[:contiguous].to_s : nil
    end

    def column(new_value=nil)
      @column = new_value.to_s if new_value.present?
      @column ||= @options[:column] || name
    end

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

    def type(new_value=nil)
      @type = new_value if new_value.present?
      @type ||= @options[:type]
    end

    def json_hash
      hash = default_json_attributes
      hash[:cardinality] = cardinality.to_s if cardinality.present?
      hash[:visible] = visible if visible.present? && visible == 'false'
      hash[:contiguous] = contiguous if contiguous.present? && contiguous == 'true'
      hash.stringify_keys!
    end

    def to_xml(builder = nil)
      builder = builder || new_builder

      xml_attrs = default_xml_attributes.merge(:column => column)
      xml_attrs[:nameColumn] = name_column if name_column.present?
      xml_attrs[:ordinalColumn] = ordinal_column if ordinal_column.present?
      xml_attrs[:levelType] = level_type if level_type.present?
      xml_attrs[:type] = type.to_s.capitalize if type.present?
      builder.level(xml_attrs)
    end
  end

end
