module ::Rubiks

  class Dimension < NamedObject
    attribute :table
    attribute :key, :default => 'id'
    attribute :type

    def table
      attributes['table'] || "view_#{name.tableize}"
    end

    def hierarchy(name, options={})
      cubes.push(::Rubiks::Hierarchy.new(options.merge('name' => name, 'dimension_table' => table)))
    end

    def to_xml(builder = nil)
      builder = builder || new_builder

      builder.dimension(:name => caption, :foreignKey => "#{name}_id") do
      end
    end
  end

end
