module ::Rubiks

  class Hierarchy < ::Rubiks::NamedObject
    def levels
      @levels ||= []
    end

    def level(level_name, options={})
      levels.push(::Rubiks::Level.new(level_name, options))
    end

    def all_member_name(new_value=nil)
      @all_member_name = new_value.to_s if new_value.present?
      @all_member_name ||= true
    end

    def has_all(new_value=nil)
      @has_all = new_value.to_s if new_value.present?
      @has_all ||= true
    end

    def json_hash
      hash = default_json_attributes.merge(
        :levels => levels.map{ |lvl| lvl.json_hash }
      )
      hash.delete_if { |key,value| value.nil? }
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
