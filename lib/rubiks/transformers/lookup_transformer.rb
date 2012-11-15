module Rubiks
  module Transformers
    module LookupTransformer
      ##
      # Public instance methods
      #
      # Looks up the member or creates a new member if missing
      # @param[ActiveRecord Class] The class to lookup
      # @param[String] The external natural key (PK)
      # @return[Object] The found or created member
      def lookup_member(klass, natural_key)
        model_name = klass.name.underscore
        cache_key = "rubiks.lookup.#{model_name}.#{natural_key}"

        if id = cache.read(cache_key)
          klass.find_by_id(id)

        elsif existing_member = klass.where(:natural_key => natural_key).first
          cache.write(cache_key, existing_member.id)
          existing_member

        else
          new_member = klass.new
          new_member.natural_key = natural_key

          new_member.save!
          cache.write(cache_key, new_member.id)
          new_member
        end
      end

      # Looks up the surrogate key based off a natural key
      # @param[ActiveRecord Class] The class to lookup
      # @param[String] The external natural key (PK)
      # @return[Integer] The surrogate key of the found or created member
      def lookup(klass, natural_key)
        model_name = klass.name.underscore
        cache_key = "rubiks.lookup.#{model_name}.#{natural_key}"

        if id = cache.read(cache_key)
          id

        elsif existing_member = klass.where(:natural_key => natural_key).first
          cache.write(cache_key, existing_member.id)
          existing_member.id

        else
          new_member = klass.new
          new_member.natural_key = natural_key

          new_member.save!
          cache.write(cache_key, new_member.id)
          new_member.id
        end
      end

      def lookup_date(input)
        date =  if input == :today
                  Date.today
                elsif input == :yesterday
                  1.day.ago
                elsif input.kind_of? Integer
                  Time.at(input)
                else
                  Date.parse(input)
                end

        date.strftime('%Y%m%d').to_i
      rescue
        -1
      end

      private

      def cache
        @cache ||= Rails.cache
      end

    end
  end
end
