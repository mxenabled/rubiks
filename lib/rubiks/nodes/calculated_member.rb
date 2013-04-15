require 'rubiks/nodes/annotated_node'

module ::Rubiks

  class CalculatedMember < ::Rubiks::AnnotatedNode
    value :dimension, String
    value :formula, String
    value :format_string, String

    validates :dimension_present, :formula_present

    def self.new_from_hash(hash={})
      new_instance = new
      return new_instance.from_hash(hash.deep_dup)
    end

    def from_hash(working_hash)
      return self if working_hash.nil?
      working_hash.stringify_keys!

      parse_name(working_hash.delete('name'))
      parse_dimension(working_hash.delete('dimension'))
      parse_formula(working_hash.delete('formula'))
      parse_format_string(working_hash.delete('format_string'))
      return self
    end

    def to_hash
      hash = {}

      if self.name.present?
        hash['name'] = self.name.to_s
        hash['display_name'] = self.display_name.to_s
      end
      hash['dimension'] = self.dimension.to_s if self.dimension.present?
      hash['formula'] = self.formula.to_s if self.formula.present?
      hash['format_string'] = self.format_string.to_s if self.format_string.present?

      return hash
    end

    def dimension_present
      errors << 'Dimension required on CalculatedMember' if self.dimension.blank?
    end

    def parse_dimension(dimension_value)
      return if dimension_value.nil?

      self.dimension = dimension_value.to_s
    end

    def formula_present
      errors << 'Formula required on CalculatedMember' if self.formula.blank?
    end

    def parse_formula(formula_value)
      return if formula_value.nil?

      self.formula = formula_value.to_s
    end

    def parse_format_string(format_string_value)
      return if format_string_value.nil?

      self.format_string = format_string_value.to_s
    end

    def to_xml(builder = nil)
      builder = Builder::XmlMarkup.new(:indent => 2) if builder.nil?

      attrs = self.to_hash
      attrs['name'] = self.display_name if self.display_name.present?
      attrs['dimension'] = self.dimension.titleize if self.dimension.present?
      attrs.delete('format_string')
      attrs.delete('display_name')
      builder.calculatedMember(attrs) do
        if self.format_string.present?
          format_attrs = {'name' => 'FORMAT_STRING', 'value' => self.format_string}
          builder.calculatedMemberProperty(format_attrs)
        end
      end
    end

    def json_hash
      self.to_hash
    end
  end

end
