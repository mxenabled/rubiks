require 'rltk'
require 'rltk/ast'

module ::Rubiks
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
