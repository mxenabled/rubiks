module ::Rubiks

  class Measure < ::Rubiks::NamedObject
    attribute :column
    attribute :aggregator
    attribute :format_string

    def to_xml(builder = nil)
      builder = builder || new_builder

      builder.measure(:name => caption, :column => name)
    end
  end

end
