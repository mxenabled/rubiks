require 'rubiks/version'

require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/deep_dup'
require 'active_support/core_ext/hash/keys'

module ::Rubiks
  module Nodes
    autoload :Cube,       'rubiks/nodes/cube'
    # autoload :Dimension,  'rubiks/dimension'

    autoload :AnnotatedNode, 'rubiks/nodes/annotated_node'
    autoload :ValidatedNode, 'rubiks/nodes/validated_node'
  end

  # module Cubes
  #   # autoload :Base,  'rubiks/cubes/base'
  # end

  # module Dimensions
  #   # autoload :Base,  'rubiks/dimensions/base'
  # end
end
