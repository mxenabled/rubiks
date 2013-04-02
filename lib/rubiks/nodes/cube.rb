require 'rubiks/nodes/annotated_node'
require 'rubiks/nodes/dimension'

module ::Rubiks::Nodes

  class Cube < ::Rubiks::Nodes::AnnotatedNode
    child :dimensions, [::Rubiks::Nodes::Dimension]

    validates :dimensions_present

    def self.new_from_hash(hash={})
      new_instance = new('',[])
      return new_instance.from_hash(hash)
    end

    def dimensions_present
      if self.dimensions.present?
        self.dimensions.each do |dimension|
          dimension.validate
          errors.push(*dimension.errors)
        end
      else
        errors << 'Dimensions Required for Cube'
      end
    end

    def from_hash(working_hash)
      return self if working_hash.nil?
      working_hash.stringify_keys!

      parse_name(working_hash.delete('name'))
      parse_dimensions(working_hash.delete('dimensions'))
      return self
    end

    def parse_dimensions(dimensions_array)
      return if dimensions_array.nil? || dimensions_array.empty?

      dimensions_array.each do |dimension_hash|
        self.dimensions << ::Rubiks::Nodes::Dimension.new('',[]).from_hash(dimension_hash)
      end
    end

    def to_hash
      hash = {}

      hash['name'] = self.name.to_s if self.name.present?
      hash['dimensions'] = self.dimensions.map(&:to_hash) if self.dimensions.present?

      return hash
    end
  end

end
