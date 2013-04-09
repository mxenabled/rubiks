require 'rubiks/nodes/annotated_node'
require 'rubiks/nodes/level'

module ::Rubiks

  class Hierarchy < ::Rubiks::AnnotatedNode
    value :dimension, String
    child :levels, [::Rubiks::Level]

    validates :levels_present, :dimension_present

    def self.new_from_hash(hash={})
      new_instance = new('','',[])
      return new_instance.from_hash(hash)
    end

    def dimension_present
      errors << 'Dimension required on Hierarchy' if self.dimension.blank?
    end

    def parse_dimension(dimension_value)
      return if dimension_value.nil?

      self.dimension = dimension_value.to_s
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
      parse_dimension(working_hash.delete('dimension'))
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
      hash['dimension'] = self.dimension.to_s if self.dimension.present?
      hash['levels'] = self.levels.map(&:to_hash) if self.levels.present?

      return hash
    end

    def to_xml(builder = nil)
      builder = Builder::XmlMarkup.new(:indent => 2) if builder.nil?

      attrs = Hash.new
      attrs['name'] = self.name.titleize if self.name.present?
      attrs['primaryKey'] = 'id'

      builder.hierarchy(attrs) {
        table_attrs = Hash.new
        table_attrs['name'] = "view_#{dimension.tableize}" if dimension.present?
        builder.table(table_attrs)

        self.levels.each do |level|
          level.to_xml(builder)
        end if self.levels.present?
      }
    end
  end

end
