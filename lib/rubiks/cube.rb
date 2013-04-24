module ::Rubiks

  class Cube < NamedObject
    attribute :dimensions, :default => Array.new

    def dimension(name, options={})
      cubes.push(::Rubiks::Dimension.new(options.merge('name' => name)))
    end

    def to_xml(builder = nil)
      builder = builder || new_builder

      builder.cube(:name => caption) do
        builder.table(:name => "view_#{name.tableize}")
      end
    end
  end

end
