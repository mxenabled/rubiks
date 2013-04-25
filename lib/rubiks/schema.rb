module ::Rubiks

  class Schema < NamedObject
    attribute :cubes, :default => Array.new

    def self.define(&block)
      raise ArgumentError, 'A block is required' unless block_given?

      schema = new
      schema.instance_eval(&block)
      schema
    end

    def cube(name, options={})
      cubes.push(::Rubiks::Cube.new(options.merge('name' => name)))
    end

    def to_xml(builder = nil)
      builder = builder || new_builder

      builder.schema(:name => caption) do
      end
    end
  end

end
