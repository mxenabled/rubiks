require 'rubiks/nodes/annotated_node'

module ::Rubiks

  class Level < ::Rubiks::AnnotatedNode
    def self.new_from_hash(hash={})
      new_instance = new
      return new_instance.from_hash(hash)
    end

    def from_hash(working_hash)
      return self if working_hash.nil?
      working_hash.stringify_keys!

      parse_name(working_hash.delete('name'))
      return self
    end

    def to_hash
      hash = {}

      hash['name'] = self.name.to_s if self.name.present?

      return hash
    end

    def to_xml(builder = nil)
      builder = Builder::XmlMarkup.new(:indent => 2) if builder.nil?

      attrs = Hash.new
      attrs['name'] = self.name.titleize if self.name.present?
      attrs['column'] = self.name.underscore if self.name.present?

      builder.level(attrs)
    end
  end

end
