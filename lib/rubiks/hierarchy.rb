module ::Rubiks

  class Hierarchy < ::Rubiks::NamedObject
    attribute :has_all, :default => true
    attribute :all_member_name, :default => 'All'

    attr_accessor :table

    def level(name, options={})
      cubes.push(::Rubiks::Level.new(options.merge('name' => name)))
    end

    def table
      attributes['table'] || "view_#{self.name.tableize}"
    end

    def to_xml(builder = nil)
      builder = builder || new_builder

      builder.hierarchy(:name => caption, :primaryKey => 'id', :hasAll => has_all.to_s) do
        builder.table(:name => table)
      end
    end
  end

end
