module Rubiks
  module Cube
    def self.included(klass)
      klass.extend Rubiks::Cube::ClassMethods
    end

    module ClassMethods
      def dimension(name)
        model_name = name.to_s
        dimensions << model_name
        belongs_to model_name, :class_name => "Dimensions::#{model_name.classify}"
      end

      def dimensions
        @dimensions ||= []
      end

      def measure(name)
        measures << name
      end

      def measures
        @measures ||= []
      end
    end

    def mdx(query)
      res = olap.execute(query)
      output = []
      output << res.column_full_names
      res.values.each{ |v| output << v }
      output.join("\n")
    end

    def to_s
      "#<#{self.class.name}>"
    end

    def inspect
      "#<#{self.class.name} dims: #{self.class.dimensions.inspect}>"
    end


    private

    def olap
      @olap ||= Mondrian::OLAP::Connection.create(mondrian_config)
    end

    def mondrian_config
      @mondrian_config ||= begin
        ar_config = ActiveRecord::Base.connection.config

        {
          :driver   => ar_config[:adapter],
          :host     => ar_config[:host],
          :database => ar_config[:database],
          :username => ar_config[:username],
          :password => ar_config[:password],
          :schema   => mondrian_schema
        }
      end
    end

    def mondrian_schema
      rubiks_cube = self
      @mondrian_schema ||= Mondrian::OLAP::Schema.define do
        cube rubiks_cube.class.name do
          table rubiks_cube.class.table_name

          rubiks_cube.class.reflections.each do |name, reflection|
            dimension reflection.name.titleize, :foreign_key => reflection.foreign_key do

              reflection.class_name.constantize.hierarchies.each do |h|
                hierarchy :has_all => true, :primary_key => :id do
                  table reflection.table_name

                  h.levels.each do |l|
                    level l.to_s.titleize, :column => l
                  end
                end
              end

            end
          end

          rubiks_cube.class.measures.each do |m|
            measure m.to_s.titleize, :column => m, :aggregator => 'avg'
          end
        end
      end
    end

  end
end
