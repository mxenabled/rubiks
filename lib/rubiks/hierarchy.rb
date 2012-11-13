module Rubiks
  class Hierarchy
    attr_accessor :name
    attr_reader :levels

    def initialize(name)
      @name = name
      @levels = []
    end

    def level(name)
      levels << name
    end
  end
end
