module ::Rubiks::Nodes

  class Schema < ::Rubiks::Nodes::ValidatedNode
    child :cubes, [::Rubiks::Nodes::Cube]

    validates :cubes_present

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

      parse_cubes(working_hash.delete('cubes'))
      return self
    end

    def parse_cubes(cubes_array)
      return if cubes_array.nil? || cubes_array.empty?

      cubes_array.each do |cube_hash|
        self.cubes << ::Rubiks::Nodes::Cube.new.from_hash(cube_hash)
      end
    end

    def to_hash
      hash = {}

      hash['cubes'] = self.cubes.map(&:to_hash) if self.cubes.present?

      return hash
    end
  end

end
