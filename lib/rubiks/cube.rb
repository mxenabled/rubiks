module ::Rubiks

  module Cube
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def display_name
        self.name.titleize
      end

      def json_hash
        hash = {}

        hash[:name] = self.name
        hash[:display_name] = self.display_name

        return hash
      end

      def to_xml(builder = nil)
        builder = Builder::XmlMarkup.new(:indent => 2) if builder.nil?

        builder.cube(:name => self.display_name) do
          builder.table(:name => "view_#{self.name.tableize}")
        end
      end

      def to_json
        MultiJson.dump(self.json_hash)
      end

      def dimension(name)
      end

      def measure(name)
      end

      def calculated_member(name)
      end
    end
  end

end
