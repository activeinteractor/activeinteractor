# frozen_string_literal: true

module ActiveInteractor
  module Context
    module AttributeRegistration
      extend ActiveSupport::Concern

      module ClassMethods
        protected

        def attribute_set
          @attribute_set ||= AttributeSet.new(self)
        end
      end

      protected

      def attribute_set
        @attribute_set ||= AttributeSet.new(self, *self.class.send(:attribute_set).attributes.map(&:dup))
      end
    end
  end
end
