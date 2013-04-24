module ::Rubiks

  module UiAttributes
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def caption(new_caption = nil)
        @caption = new_caption if new_caption.present?
        @caption ||= self.name.split('::').last.titleize
      end

      def description
        self.caption
      end

      def is_visible?
        true
      end
    end
  end

end
