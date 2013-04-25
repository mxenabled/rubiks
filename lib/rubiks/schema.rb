module ::Rubiks

  class Schema < NamedObject
    def self.define(&block)
      raise ArgumentError, 'A block is required' unless block_given?

      schema = new
      schema.instance_eval(&block)
      schema
    end

    def cubes
      @cubes ||= []
    end

    def cube(cube_name, options={}, &block)
      new_cube = ::Rubiks::Cube.new(cube_name.to_s, options)

      new_cube.instance_eval(&block) if block_given?

      cubes.push(new_cube)

      new_cube
    end

    def to_xml(builder = nil)
      builder = builder || new_builder

      builder.schema(:name => caption) do
        cubes.each{ |cube| cube.to_xml(builder) }
      end
    end
  end

end
