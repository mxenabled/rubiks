module ::Rubiks::Nodes

  class Cube < ::Rubiks::Nodes::AnnotatedNode
    def from_hash(working_hash)
      super
      return self
    end
  end

end
