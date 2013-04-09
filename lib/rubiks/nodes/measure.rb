require 'rubiks/nodes/validated_node'

module ::Rubiks

  class Measure < ::Rubiks::AnnotatedNode
    value :aggregator, String
    value :format_string, String

    validates :aggregator_present

    def self.new_from_hash(hash={})
      new_instance = new
      return new_instance.from_hash(hash)
    end

    def from_hash(working_hash)
      return self if working_hash.nil?
      working_hash.stringify_keys!

      parse_name(working_hash.delete('name'))
      parse_aggregator(working_hash.delete('aggregator'))
      parse_format_string(working_hash.delete('format_string'))
      return self
    end

    def to_hash
      hash = {}

      hash['name'] = self.name if self.name.present?
      hash['aggregator'] = self.aggregator if self.aggregator.present?
      hash['format_string'] = self.format_string if self.format_string.present?

      return hash
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

    def to_xml(builder = nil)
      builder = Builder::XmlMarkup.new(:indent => 2) if builder.nil?

      attrs = Hash.new
      attrs['name'] = self.name.titleize if self.name.present?
      attrs['column'] = self.name.underscore if self.name.present?
      attrs.reverse_merge!(self.to_hash)
      attrs.keys.each do |key|
        attrs[key.camelize(:lower)] = attrs.delete(key)
      end
      builder.measure(attrs)
    end
  end

end
