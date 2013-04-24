module ::Rubiks

  class NamedObject
    include ActiveAttr::MassAssignment
    include ActiveAttr::AttributeDefaults

    attribute :name, :default => 'default'
    attribute :is_visible, :default => true

    attr_accessor :caption, :description, :is_visible

    def caption
      @caption || (name || '').titleize
    end

    def json_hash
      attributes
    end

    def to_json
      MultiJson.dump(json_hash)
    end

    def to_xml(builder = nil)
      return if name.blank?

      builder = builder || new_builder

      builder.__send__(name)
    end

    private

    def new_builder
      builder = Builder::XmlMarkup.new(:indent => 2) if builder.nil?
    end
  end

end
