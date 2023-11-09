# frozen_string_literal: true

module ActiveInteractor
  module Context
    module AttributeValidation
      extend ActiveSupport::Concern

      included do
        validate :validate_attributes!
      end

      protected

      def validate_attributes!
        attribute_set.attributes.each do |attribute|
          attribute.validate!
          attribute.error_messages.each { |message| errors.add(attribute.name, message) }
        end
      end
    end
  end
end
