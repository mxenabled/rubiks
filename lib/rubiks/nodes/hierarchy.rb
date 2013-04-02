require 'rubiks/nodes/annotated_node'
require 'rubiks/nodes/level'

module ::Rubiks

  class Hierarchy < ::Rubiks::AnnotatedNode
    child :levels, [::Rubiks::Level]

    validates :levels_present

    def self.new_from_hash(hash={})
      new_instance = new('',[])
      return new_instance.from_hash(hash)
    end

    def levels_present
      if self.levels.present?
        self.levels.each do |level|
          level.validate
          errors.push(*level.errors)
        end
      else
        errors << 'Levels Required for Hierarchy'
      end
    end

    def from_hash(working_hash)
      return self if working_hash.nil?
      working_hash.stringify_keys!

      parse_name(working_hash.delete('name'))
      parse_levels(working_hash.delete('levels'))
      return self
    end

    def parse_levels(levels_array)
      return if levels_array.nil? || levels_array.empty?

      levels_array.each do |level_hash|
        self.levels << ::Rubiks::Level.new_from_hash(level_hash)
      end
    end

    def to_hash
      hash = {}

      hash['name'] = self.name.to_s if self.name.present?
      hash['levels'] = self.levels.map(&:to_hash) if self.levels.present?

      return hash
    end

  end

end
