require 'rubiks/nodes/validated_node'

module ::Rubiks

  class Measure < ::Rubiks::AnnotatedNode
    value :aggregator, String
    value :column, String
    value :format_string, String

    validates :aggregator_present

    def self.new_from_hash(hash={})
      new_instance = new
      return new_instance.from_hash(hash.deep_dup)
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

      if self.name.present?
        hash['name'] = self.name.to_s
        hash['display_name'] = self.display_name.to_s
      end
      hash['aggregator'] = self.aggregator if self.aggregator.present?
      hash['format_string'] = self.format_string if self.format_string.present?
      hash['column'] = self.column if self.column.present?

      return hash
    end

    def json_hash
      hash = self.to_hash
      hash.delete('column')
      return hash
    end

    def aggregator_present
      errors << 'Aggregator required on Measure' if self.aggregator.blank?
    end

    def parse_column(column_value)
      return if column_value.nil? && self.name.blank?

      self.column = column_value.nil? ?
                      self.name.underscore :
                      column_value.to_s
    end

    def parse_aggregator(aggregator_value)
      return if aggregator_value.nil?

      self.aggregator = aggregator_value.to_s
    end

    def parse_format_string(format_string_value)
      return if format_string_value.nil?

      self.format_string = format_string_value.to_s
    end

    def to_xml(builder = nil)
      builder = Builder::XmlMarkup.new(:indent => 2) if builder.nil?

      attrs = self.to_hash
      attrs['name'] = self.display_name if self.name.present?
      attrs.delete('display_name')
      attrs.keys.each do |key|
        attrs[key.camelize(:lower)] = attrs.delete(key)
      end
      builder.measure(attrs)
    end
  end

end
