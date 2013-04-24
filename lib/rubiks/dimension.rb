module ::Rubiks

  module Dimension
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

      def to_json
        MultiJson.dump(self.json_hash)
      end

      # attribute :name, :column => 'customer_id', :name_column => 'full_name'
      def attribute(attr_name, options={})
        xml_options = {}
        options.keys.each do |key|
          xml_options[key.to_s.camelize(:lower)] = options.delete(key)
        end
        xml_options['name'] = attr_name.to_s.titleize
        xml_options['keyColumn'] = xml_options.delete('column') || attr_name.to_s.underscore
        attributes.push(xml_options)
      end

      def attributes
        @attributes ||= Array.new
      end

      def table(new_table = nil)
        @table = new_table if new_table.present?
        @table
        #@table ||= self.name.split('::').last.tableize
      end

      def key(new_key = nil)
        @key = new_key if new_key.present?
        @key ||= 'id'
      end

      def type(new_type = nil)
        @type = new_type if new_type.present?
        @type
      end

      def hierarchy(name)
      end

      def to_xml(builder = nil)
        builder = Builder::XmlMarkup.new(:indent => 2) if builder.nil?

        xml_attrs = {
          :name => self.caption,
          :key => self.key
        }

        xml_attrs[:table] = self.table if self.table.present?
        xml_attrs[:type] = self.type if self.type.present?

        builder.dimension(xml_attrs) do
          attributes.each do |attribute_hash|
            builder.attribute(attribute_hash)
          end
        end
      end
    end
  end

end
