require 'rubiks/nodes/validated_node'
require 'rubiks/nodes/hierarchy'

module ::Rubiks

  class Dimension < ::Rubiks::AnnotatedNode
    child :hierarchies, [::Rubiks::Hierarchy]

    validates :hierarchies_present

    def self.new_from_hash(hash={})
      new_instance = new('',[])
      return new_instance.from_hash(hash.deep_dup)
    end

    def hierarchies_present
      if self.hierarchies.present?
        self.hierarchies.each do |hierarchy|
          hierarchy.validate
          errors.push(*hierarchy.errors)
        end
      else
        errors << 'Hierarchies Required for Dimension'
      end
    end

    def from_hash(working_hash)
      return self if working_hash.nil?
      working_hash.stringify_keys!

      parse_name(working_hash.delete('name'))
      parse_hierarchies(working_hash.delete('hierarchies'))
      return self
    end

    def parse_hierarchies(hierarchies_array)
      return if hierarchies_array.nil? || hierarchies_array.empty?

      hierarchies_array.each do |hierarchy_hash|
        hierarchy_hash['dimension'] = self.name if self.name.present?
        self.hierarchies << ::Rubiks::Hierarchy.new_from_hash(hierarchy_hash)
      end
    end

    def to_hash
      hash = {}

      hash['name'] = self.name.to_s if self.name.present?
      hash['hierarchies'] = self.hierarchies.map(&:to_hash) if self.hierarchies.present?

      return hash
    end

    def to_xml(builder = nil)
      builder = Builder::XmlMarkup.new(:indent => 2) if builder.nil?

      attrs = self.to_hash
      attrs.delete('hierarchies')
      attrs['name'] = self.name.titleize if self.name.present?
      attrs.keys.each do |key|
        attrs[key.camelize(:lower)] = attrs.delete(key)
      end
      attrs['foreignKey'] = "#{self.name.underscore}_id" if self.name.present?
      builder.dimension(attrs) {
        self.hierarchies.each do |hier|
          hier.to_xml(builder)
        end if self.hierarchies.present?
      }
    end
  end

end
