module ::Rubiks

  class Dimension < NamedObject
    def hierarchies
      @hierarchies ||= []
    end

    def hierarchy(hierarchy_name, options={}, &block)
      options = options.merge(:table_name => self.table_name)
      new_hierarchy = ::Rubiks::Hierarchy.new(hierarchy_name.to_s, options)

      new_hierarchy.instance_eval(&block) if block_given?

      hierarchies.push(new_hierarchy)

      new_hierarchy
    end

    def to_xml(builder = nil)
      builder = builder || new_builder

      builder.dimension(:name => caption, :foreignKey => "#{name}_id") do
        hierarchies.each{ |hierarchy| hierarchy.to_xml(builder) }
      end
    end
  end

end
