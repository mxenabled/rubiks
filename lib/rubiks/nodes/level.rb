require 'rubiks/nodes/annotated_node'

module ::Rubiks

  class Level < ::Rubiks::AnnotatedNode
    CARDINALITIES = %w[ low normal high ]
    DATA_TYPES = %w[ String Integer Numeric Boolean Date Time Timestamp ]

    value :cardinality, String
    value :contiguous_value, Fixnum
    value :sort_column, String
    value :data_type, String

    validates :cardinality_if_present, :data_type_if_present

    def self.new_from_hash(hash={})
      new_instance = new
      return new_instance.from_hash(hash)
    end

    def from_hash(working_hash)
      return self if working_hash.nil?
      working_hash.stringify_keys!

      parse_name(working_hash.delete('name'))
      parse_data_type(working_hash.delete('data_type'))
      parse_contiguous_value(working_hash.delete('contiguous'))
      parse_cardinality(working_hash.delete('cardinality'))
      parse_sort_column(working_hash.delete('sort'))
      parse_sort_column(working_hash.delete('sort_column'))
      return self
    end

    def parse_contiguous_value(input_value)
      return if input_value.nil?

      self.contiguous_value = !!input_value ? 1 : 0
    end

    def parse_sort_column(sort_column_value)
      return if sort_column_value.nil?

      if sort_column_value.kind_of?(::TrueClass)
        self.sort_column = "#{self.name}_sort"

      elsif sort_column_value.kind_of?(::String)
        self.sort_column = sort_column_value
      end
    end

    def data_type_if_present
      if self.data_type.present? && !::Rubiks::Level::DATA_TYPES.include?(self.data_type)
        errors << "DataType '#{self.data_type}' must be one of #{::Rubiks::Level::DATA_TYPES.join(', ')} on Level"
      end
    end

    def parse_data_type(data_type_value)
      return if data_type_value.nil?

      self.data_type = data_type_value.to_s.capitalize
    end

    def cardinality_if_present
      if self.cardinality.present? && !::Rubiks::Level::CARDINALITIES.include?(self.cardinality)
        errors << "Cardinality '#{self.cardinality}' must be one of #{::Rubiks::Level::CARDINALITIES.join(', ')} on Level"
      end
    end

    def parse_cardinality(cardinality_value)
      return if cardinality_value.nil?

      self.cardinality = cardinality_value.to_s
    end

    def to_hash
      hash = {}

      if self.name.present?
        hash['name'] = self.name.to_s
        hash['display_name'] = self.display_name
      end
      hash['contiguous'] = true if self.contiguous_value.present? && self.contiguous_value == 1
      hash['cardinality'] = self.cardinality if self.cardinality.present?
      hash['data_type'] = self.data_type if self.data_type.present?

      return hash
    end

    def to_xml(builder = nil)
      builder = Builder::XmlMarkup.new(:indent => 2) if builder.nil?

      attrs = {}

      if self.name.present?
        attrs['name'] = self.display_name
        attrs['column'] = self.name
      end
      attrs['type'] = self.data_type if self.data_type.present?
      attrs['ordinalColumn'] = self.sort_column if self.sort_column.present?

      builder.level(attrs)
    end

    def to_json
      MultiJson.dump(self.to_hash)
    end
  end

end
