module ::Rubiks

  class NamedObject
    def self.define(new_name=nil, options={}, &block)
      instance = new(new_name, options)
      instance.instance_eval(&block) if block_given?
      instances[instance.name.to_sym] = instance
      instance
    end

    def self.instances
      @instances ||= Hash.new
    end

    def self.find_or_create(instance_name, options={}, &block)
      return instances[instance_name.to_sym] if instances.has_key?(instance_name.to_sym)

      new_instance = new(instance_name.to_s, options)
      new_instance.instance_eval(&block) if block_given?
      new_instance
    end

    def self.clear!
      @instances = nil
    end

    def self.default
      if instances.has_key?('default')
        instances['default']
      elsif instances.present?
        instances.first[1]
      end
    end

    def self.[](instance_name)
      instances[instance_name.to_sym]
    end

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

    def hidden(new_value=nil)
      @hidden = new_value.to_s unless new_value.nil?
      @hidden ||= @options.key?(:hidden) ? @options[:hidden].to_s : nil
    end

    def column(new_value=nil)
      @column = new_value.to_s if new_value.present?
      @column ||= @options[:column] || name
    end

    def caption(new_value=nil)
      @caption = new_value if new_value.present?
      @caption ||= @options[:caption] || name.titleize
    end

    def table(new_value=nil)
      @table = new_value if new_value.present?
      @table ||= @options[:table] || "view_#{name.tableize}"
    end

    def to_json(options={})
      MultiJson.encode(json_hash, options)
    end

    def default_json_attributes
      json_attrs = {
        :name => caption,
        :description => description,
        :icon_type => icon_type
      }
      json_attrs[:hidden] = hidden if hidden.present? && hidden == 'true'
      json_attrs.delete_if { |key,value| value.nil? }
      json_attrs.stringify_keys!
    end
    alias_method :json_hash, :default_json_attributes

    def default_xml_attributes
      xml_attrs = {
        :name => caption,
        :description => description
      }
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
