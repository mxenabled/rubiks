require 'rubiks/nodes/annotated_node'

module ::Rubiks

  class Level < ::Rubiks::AnnotatedNode
    CARDINALITIES = %w[ low normal high ]
    DATA_TYPES = %w[ string integer numeric boolean date_time timestamp ]

    value :cardinality, String
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
      parse_cardinality(working_hash.delete('cardinality'))
      return self
    end

    def data_type_if_present
      if self.data_type.present? && !::Rubiks::Level::DATA_TYPES.include?(self.data_type.to_s.underscore)
        errors << "DataType '#{self.data_type}' must be one of #{::Rubiks::Level::DATA_TYPES.join(', ')} on Level"
      end
    end

    def parse_data_type(data_type_value)
      return if data_type_value.nil?

      self.data_type = data_type_value.to_s
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

      builder.level(attrs)
    end

    def to_json
      MultiJson.dump(self.to_hash)
    end
  end

end
