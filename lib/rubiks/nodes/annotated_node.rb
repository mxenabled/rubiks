require 'rubiks/nodes/validated_node'

module ::Rubiks
  class AnnotatedNode < ::Rubiks::ValidatedNode
    value :name, String

    validates :name_present

    def name_present
      errors << "Name required on #{self.class.name.split('::').last}" if self.name.blank?
    end

    def parse_name(name_value)
      return if name_value.nil?

      self.name = name_value.to_s
    end

    def display_name
      return if self.name.nil?

      self.name.titleize
    end

  end
end
