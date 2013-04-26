module ::Rubiks

  class Hierarchy < ::Rubiks::NamedObject
    def levels
      @levels ||= []
    end

    def level(level_name, options={}, &block)
      levels.push ::Rubiks::Level.find_or_create(level_name, options, &block)
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
      hash.stringify_keys!
    end

    def to_xml(builder = nil)
      builder = builder || new_builder

      xml_attrs = default_xml_attributes.merge(:hasAll => has_all.to_s)
      xml_attrs[:primaryKey] = 'id' unless degenerate?
      builder.hierarchy(xml_attrs) do
        builder.table(:name => table) unless degenerate?
        levels.each{ |level| level.to_xml(builder) }
      end
    end

    def degenerate?
      table == 'degenerate'
    end
  end

end
