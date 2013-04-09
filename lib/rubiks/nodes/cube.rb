require 'rubiks/nodes/annotated_node'
require 'rubiks/nodes/dimension'
require 'rubiks/nodes/measure'
require 'rubiks/nodes/calculated_member'

module ::Rubiks

  class Cube < ::Rubiks::AnnotatedNode
    child :dimensions, [::Rubiks::Dimension]
    child :measures, [::Rubiks::Measure]
    child :calculated_members, [::Rubiks::CalculatedMember]

    validates :dimensions_present, :measures_present, :calculated_members_if_present

    def self.new_from_hash(hash={})
      new_instance = new('',[],[],[])
      return new_instance.from_hash(hash)
    end

    def from_hash(working_hash)
      return self if working_hash.nil?
      working_hash.stringify_keys!

      parse_name(working_hash.delete('name'))
      parse_dimensions(working_hash.delete('dimensions'))
      parse_measures(working_hash.delete('measures'))
      parse_calculated_members(working_hash.delete('calculated_members'))
      return self
    end

    def calculated_members_present
      if self.calculated_members.present?
        self.calculated_members.each do |calculated_member|
          calculated_member.validate
          errors.push(*calculated_member.errors)
        end
      end
    end

    def parse_calculated_members(calculated_members_array)
      return if calculated_members_array.nil? || calculated_members_array.empty?

      calculated_members_array.each do |calculated_member_hash|
        self.calculated_members << ::Rubiks::CalculatedMember.new_from_hash(calculated_member_hash)
      end
    end

    def measures_present
      if self.measures.present?
        self.measures.each do |measure|
          measure.validate
          errors.push(*measure.errors)
        end
      else
        errors << 'Measures Required for Cube'
      end
    end

    def parse_measures(measures_array)
      return if measures_array.nil? || measures_array.empty?

      measures_array.each do |measure_hash|
        self.measures << ::Rubiks::Measure.new_from_hash(measure_hash)
      end
    end

    def dimensions_present
      if self.dimensions.present?
        self.dimensions.each do |dimension|
          dimension.validate
          errors.push(*dimension.errors)
        end
      else
        errors << 'Dimensions Required for Cube'
      end
    end

    def parse_dimensions(dimensions_array)
      return if dimensions_array.nil? || dimensions_array.empty?

      dimensions_array.each do |dimension_hash|
        self.dimensions << ::Rubiks::Dimension.new_from_hash(dimension_hash)
      end
    end

    def to_hash
      hash = {}

      hash['name'] = self.name.to_s if self.name.present?
      hash['dimensions'] = self.dimensions.map(&:to_hash) if self.dimensions.present?
      hash['measures'] = self.measures.map(&:to_hash) if self.measures.present?
      hash['calculated_members'] = self.calculated_members.map(&:to_hash) if self.calculated_members.present?

      return hash
    end

    def to_xml(builder = nil)
      builder = Builder::XmlMarkup.new(:indent => 2) if builder.nil?

      attrs = Hash.new
      attrs['name'] = self.name.titleize if self.name.present?
      builder.cube(attrs) {
        builder.table('name' => "view_#{self.name.tableize}") if self.name.present?

        self.dimensions.each{ |dim| dim.to_xml(builder) } if self.dimensions.present?
        self.measures.each{ |measure| measure.to_xml(builder) } if self.measures.present?
        self.calculated_members.each{ |calculated_member| calculated_member.to_xml(builder) } if self.calculated_members.present?
      }
    end
  end

end
