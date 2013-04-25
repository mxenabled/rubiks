module ::Rubiks

  class Hierarchy < ::Rubiks::NamedObject
    attr_accessor :table, :has_all, :all_member_name, :levels

    def levels
      @levels ||= []
    end

    def level(level_name, options={})
      levels.push(::Rubiks::Level.new(level_name, options))
    end

    def has_all(new_value=nil)
      @has_all = new_value if new_value.present?
      @has_all ||= true
    end

    def to_xml(builder = nil)
      builder = builder || new_builder

      builder.hierarchy(default_xml_attributes.merge(:primaryKey => 'id', :hasAll => has_all.to_s)) do
        builder.table(:name => table_name)
        levels.each{ |level| level.to_xml(builder) }
      end
    end
  end

end
