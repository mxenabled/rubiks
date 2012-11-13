module Rubiks
  module Dimension
    def self.included(klass)
      klass.extend Rubiks::Dimension::ClassMethods
    end

    module ClassMethods
      def hierarchy(name, &block)
        new_hierarchy = Hierarchy.new(name)
        new_hierarchy.instance_eval(&block) if block_given?
        hierarchies << new_hierarchy
      end

      def hierarchies
        @hierarchies ||= []
      end
    end

    def hierarchies
      self.class.hierarchies
    end
  end
end
