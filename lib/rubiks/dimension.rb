module ::Rubiks

  module Dimension
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

      def to_json
        MultiJson.dump(self.json_hash)
      end

      def attribute(name)
      end

      def hierarchy(name)
      end

      def to_xml(builder = nil)
        builder = Builder::XmlMarkup.new(:indent => 2) if builder.nil?

        builder.dimension(:name => self.display_name) do
        end
      end
    end
  end

end
