require 'rubiks/nodes/annotated_node'
require 'rubiks/nodes/dimension'
require 'rubiks/nodes/measure'

module ::Rubiks::Nodes

  class Cube < ::Rubiks::Nodes::AnnotatedNode
    child :dimensions, [::Rubiks::Nodes::Dimension]
    child :measures, [::Rubiks::Nodes::Measure]

    validates :dimensions_present, :measures_present

    def self.new_from_hash(hash={})
      new_instance = new('',[],[])
      return new_instance.from_hash(hash)
    end

    def from_hash(working_hash)
      return self if working_hash.nil?
      working_hash.stringify_keys!

      parse_name(working_hash.delete('name'))
      parse_dimensions(working_hash.delete('dimensions'))
      parse_measures(working_hash.delete('measures'))
      return self
    end

    def measures_present
      if self.measures.present?
        self.measures.each do |measure|
          measure.validate
          errors.push(*measure.errors)
        end
      else
        errors << 'Measures Required for Cube'
      end
    end

    def parse_measures(measures_array)
      return if measures_array.nil? || measures_array.empty?

      measures_array.each do |measure_hash|
        self.measures << ::Rubiks::Nodes::Measure.new_from_hash(measure_hash)
      end
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

    def parse_dimensions(dimensions_array)
      return if dimensions_array.nil? || dimensions_array.empty?

      dimensions_array.each do |dimension_hash|
        self.dimensions << ::Rubiks::Nodes::Dimension.new_from_hash(dimension_hash)
      end
    end

    def to_hash
      hash = {}

      hash['name'] = self.name.to_s if self.name.present?
      hash['dimensions'] = self.dimensions.map(&:to_hash) if self.dimensions.present?
      hash['measures'] = self.measures.map(&:to_hash) if self.measures.present?

      return hash
    end
  end

end
