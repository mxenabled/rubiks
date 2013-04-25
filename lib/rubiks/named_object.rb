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

    def description(new_value=nil)
      @description = new_value.to_s if new_value.present?
      @description ||= @options[:description]
    end

    def is_visible(new_value=nil)
      @is_visible = new_value.to_s if new_value.present?
      @is_visible ||= @options[:is_visible] || true
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

    def json_hash
      {
        :name => name,
        :caption => caption
      }
    end

    def to_json
      MultiJson.dump(json_hash)
    end

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
