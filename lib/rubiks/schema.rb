module ::Rubiks

  class Schema < NamedObject
    def cubes
      @cubes ||= []
    end

    def cube(cube_name, options={}, &block)
      cubes.push ::Rubiks::Cube.find_or_create(cube_name, options, &block)
    end

    def json_hash
      hash = default_json_attributes
      hash[:cubes] = cubes.map{ |c| c.json_hash } if cubes.present?
      hash
    end

    def to_xml(builder = nil)
      builder = builder || new_builder
      builder.instruct!

      builder.schema(:name => caption) do
        cubes.each{ |cube| cube.to_xml(builder) }
      end
    end
  end

end
