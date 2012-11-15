require 'rubiks/version'

module Rubiks
  autoload :Cube,       'rubiks/cube'
  autoload :Dimension,  'rubiks/dimension'
  autoload :Hierarchy,  'rubiks/hierarchy'

  module Transformers
    autoload :LookupTransformer, 'rubiks/transformers/lookup_transformer'
  end
end
