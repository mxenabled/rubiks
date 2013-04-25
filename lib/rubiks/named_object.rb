module ::Rubiks

  class NamedObject
    def initialize(new_name = nil, options = {})
      @name = new_name.to_s if new_name.present?
      @options = options.symbolize_keys
    end

    def name(new_value=nil)
      @name = new_value.to_s if new_value.present?
      @name ||= @options[:name] || 'default'
    end

    def icon_type(new_value=nil)
      @icon_type = new_value.to_s if new_value.present?
      @icon_type ||= @options[:icon_type]
    end

    def description(new_value=nil)
      @description = new_value.to_s if new_value.present?
      @description ||= @options[:description]
    end

    def visible(new_value=nil)
      @visible = new_value.to_s unless new_value.nil?
      @visible ||= @options.key?(:visible) ? @options[:visible].to_s : nil
    end

    def column(new_value=nil)
      @column = new_value.to_s if new_value.present?
      @column ||= @options[:column] || name
    end

    def caption(new_value=nil)
      @caption = new_value if new_value.present?
      @caption ||= name.titleize
    end

    def table_name(new_value=nil)
      @table_name = new_value if new_value.present?
      @table_name ||= @options[:table_name] || "view_#{name.tableize}"
    end

    def to_json
      MultiJson.dump(json_hash)
    end

    def default_json_attributes
      json_attrs = {
        :name => name,
        :caption => caption,
        :description => description,
        :icon_type => icon_type
      }
      json_attrs[:visible] = visible if visible.present? && visible == 'false'
      json_attrs.delete_if { |key,value| value.nil? }
    end
    alias_method :json_hash, :default_json_attributes

    def default_xml_attributes
      xml_attrs = {
        :name => caption,
        :description => description
      }
      xml_attrs[:visible] = visible if visible.present? && visible == 'false'
      xml_attrs.delete_if { |key,value| value.nil? }
    end
    alias_method :xml_hash, :default_xml_attributes

    def to_xml(builder = nil)
      return if name.blank?

      builder = builder || new_builder

      builder.__send__(name)
    end

    private

    def new_builder
      builder = Builder::XmlMarkup.new(:indent => 2) if builder.nil?
    end
  end

end
