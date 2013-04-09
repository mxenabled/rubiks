require 'rltk'
require 'rltk/ast'

module ::Rubiks

  # == Rubiks ValidatedNode
  #
  # Provides a basic validation framework to ASTNodes.
  #
  # A minimal implementation could be:
  #
  #  class NamedNode < ::Rubiks::ValidatedNode
  #    name :name, String
  #
  #    validates :name_present
  #
  #    def name_present
  #      errors << "Name required on NamedNode" if self.name.blank?
  #    end
  #
  #    def parse_name(name_value)
  #      return if name_value.nil?
  #
  #      self.name = name_value.to_s
  #    end
  #  end
  #
  # Which provides you with the following behavior:
  #
  #   name_node = nameNode.new
  #   name_node.valid?           # => false
  #   name_node.errors           # => ["Name required on NamedNode"]
  #
  #   name_node.name = 7
  #   name_node.valid?           # => true
  #
  class ValidatedNode < ::RLTK::ASTNode

    class << self
      attr_accessor :validators

      alias_method :validator_methods, :validators
    end

    def self.validates(*validator_symbols)
      @validators ||= []
      @validators << validator_symbols.flatten
      @validators.flatten!
      @validators.compact!
      @validators.uniq!

      return @validators
    end

    def self.inherited(klass)
      super
      klass.validators = self.validators.nil? ?
                          [] :
                          self.validators.dup
    end

    def errors
      @errors ||= []
    end

    def valid?
      validate if errors.empty?

      return errors.empty?
    end

    def validate
      self.class.validator_methods.each do |validator_method|
        self.__send__(validator_method) if respond_to?(validator_method)
      end
    end

  end
end