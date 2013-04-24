module ::Rubiks

  module Schema
    def self.included(klass)
      klass.extend(::Rubiks::UiAttributes::ClassMethods)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def json_hash
        hash = {}

        hash[:name] = self.name
        hash[:caption] = self.caption

        return hash
      end

      def to_xml(builder = nil)
        builder = Builder::XmlMarkup.new(:indent => 2) if builder.nil?

        builder.schema(:name => self.caption) do
          cube_classes.each{ |cube_class| cube_class.to_xml(builder) }
        end
      end

      def to_json
        MultiJson.dump(self.json_hash)
      end

      def cube(name_or_class)
        cubes.push(name_or_class)
      end

      def cubes
        @cubes ||= Array.new
      end

      def cube_classes
        cubes.map do |name_or_class|
          name_or_class.kind_of?(Class) ?
            name_or_class :
            "#{parent_name}::#{name_or_class.to_s.camelize}".constantize
        end
      end
    end
  end

end
