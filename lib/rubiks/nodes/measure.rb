require 'rubiks/nodes/validated_node'

module ::Rubiks

  class Measure < ::Rubiks::AnnotatedNode
    value :column, String
    value :aggregator, String
    value :format_string, String

    validates :column_present, :aggregator_present

    def self.new_from_hash(hash={})
      new_instance = new
      return new_instance.from_hash(hash)
    end

    def from_hash(working_hash)
      return self if working_hash.nil?
      working_hash.stringify_keys!

      parse_name(working_hash.delete('name'))
      parse_column(working_hash.delete('column'))
      parse_aggregator(working_hash.delete('aggregator'))
      parse_format_string(working_hash.delete('format_string'))
      return self
    end

    def to_hash
      hash = {}

      hash['name'] = self.name.to_s if self.name.present?
      hash['column'] = self.column.to_s if self.column.present?
      hash['aggregator'] = self.aggregator.to_s if self.aggregator.present?
      hash['format_string'] = self.format_string.to_s if self.format_string.present?

      return hash
    end

    def column_present
      errors << 'Column required on Measure' if self.column.blank?
    end

    def parse_column(column_value)
      return if column_value.nil?

      self.column = column_value.to_s
    end

    def aggregator_present
      errors << 'Aggregator required on Measure' if self.aggregator.blank?
    end

    def parse_aggregator(aggregator_value)
      return if aggregator_value.nil?

      self.aggregator = aggregator_value.to_s
    end

    def parse_format_string(format_string_value)
      return if format_string_value.nil?

      self.format_string = format_string_value.to_s
    end
  end

end
