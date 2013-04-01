module ::Rubiks
  class Cube < ::Rubiks::ValidatedNode
    value :name, String

    validates :name_present

    def name_present
      errors << 'Name required on Cube' unless self.name.present?
    end

    def from_hash(working_hash)
      return self if working_hash.nil?
      working_hash.stringify_keys!

      parse_name(working_hash.delete('name'))
      return self
    end

    def to_hash
      hash = {}

      hash['name'] = self.name if self.name.present?

      return hash
    end

    def parse_name(name_value)
      return if name_value.nil?

      self.name = name_value.to_s
    end

  end
end
