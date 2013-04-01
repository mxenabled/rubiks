require 'rubiks/version'

require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/deep_dup'
require 'active_support/core_ext/hash/keys'

module ::Rubiks
  autoload :Cube,       'rubiks/cube'
  # autoload :Dimension,  'rubiks/dimension'

  autoload :ValidatedNode, 'rubiks/validated_node'

  # module Cubes
  #   # autoload :Base,  'rubiks/cubes/base'
  # end

  # module Dimensions
  #   # autoload :Base,  'rubiks/dimensions/base'
  # end
end
