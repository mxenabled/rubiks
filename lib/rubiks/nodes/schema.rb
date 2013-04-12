require 'rubiks/nodes/annotated_node'
require 'rubiks/nodes/cube'
require 'multi_json'
require 'builder'

module ::Rubiks

  class Schema < ::Rubiks::AnnotatedNode
    child :cubes, [::Rubiks::Cube]

    validates :cubes_present

    def self.new_from_hash(hash={})
      new_instance = new('',[])
      return new_instance.from_hash(hash.deep_dup)
    end

    def cubes_present
      if self.cubes.present?
        self.cubes.each do |cube|
          cube.validate
          errors.push(*cube.errors)
        end
      else
        errors << 'Cubes Required for Schema'
      end
    end

    def from_hash(working_hash)
      return self if working_hash.nil?
      working_hash.stringify_keys!

      parse_name(working_hash.delete('name'))
      self.name = 'default' if self.name.blank?
      parse_cubes(working_hash.delete('cubes'))
      return self
    end

    def parse_cubes(cubes_array)
      return if cubes_array.nil? || cubes_array.empty?

      cubes_array.each do |cube_hash|
        self.cubes << ::Rubiks::Cube.new_from_hash(cube_hash)
      end
    end

    def to_hash
      hash = {}

      hash['name'] = self.name if self.name.present?
      hash['cubes'] = self.cubes.map(&:to_hash) if self.cubes.present?

      return hash
    end

    def to_xml(builder = nil)
      builder = Builder::XmlMarkup.new(:indent => 2) if builder.nil?

      builder.instruct!

      attrs = self.to_hash
      attrs.delete('cubes')

      builder.schema(attrs) {
        self.cubes.each do |cube|
          cube.to_xml(builder)
        end
      }
    end
  end

end
