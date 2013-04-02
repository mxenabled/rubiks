require 'rubiks/nodes/validated_node'
require 'rubiks/nodes/hierarchy'

module ::Rubiks::Nodes

  class Level < ::Rubiks::Nodes::AnnotatedNode
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
  end

end
