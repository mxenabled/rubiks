module ::Rubiks

  class Level < ::Rubiks::NamedObject
    attribute :level_type # TimeYears ..
    attribute :column
    attribute :name_column
    attribute :ordinal_column
    attribute :data_type

    def to_xml(builder = nil)
      builder = builder || new_builder

      builder.level(:name => caption, :column => name)
    end
  end

end
