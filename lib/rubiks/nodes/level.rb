require 'rubiks/nodes/annotated_node'

module ::Rubiks

  class Level < ::Rubiks::AnnotatedNode
    EDITOR_TYPES = %w[ RANGE DISCRETE ]

    value :editor_type, String

    validates :editor_type_if_present

    def self.new_from_hash(hash={})
      new_instance = new
      return new_instance.from_hash(hash)
    end

    def from_hash(working_hash)
      return self if working_hash.nil?
      working_hash.stringify_keys!

      parse_name(working_hash.delete('name'))
      parse_editor_type(working_hash.delete('editor_type'))
      return self
    end

    def editor_type_if_present
      if self.editor_type.present? && !::Rubiks::Level::EDITOR_TYPES.include?(self.editor_type)
        errors << "EditorType '#{self.editor_type}' must be one of #{::Rubiks::Level::EDITOR_TYPES.join(', ')}"
      end
    end

    def parse_editor_type(editor_type_value)
      return if editor_type_value.nil?

      self.editor_type = editor_type_value.to_s
    end


    def to_hash
      hash = {}

      if self.name.present?
        hash['name'] = self.name.to_s
        hash['display_name'] = self.display_name
      end
      hash['editor_type'] = self.editor_type if self.editor_type.present?

      return hash
    end

    def to_xml(builder = nil)
      builder = Builder::XmlMarkup.new(:indent => 2) if builder.nil?

      attrs = {}

      if self.name.present?
        attrs['name'] = self.display_name
        attrs['column'] = self.name
      end

      builder.level(attrs)
    end

    def to_json
      MultiJson.dump(self.to_hash)
    end
  end

end
