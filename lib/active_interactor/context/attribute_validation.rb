# frozen_string_literal: true

module ActiveInteractor
  module Context
    # Methods for Attribute Validation
    module AttributeValidation
      extend ActiveSupport::Concern

      included do
        validate :validate_attributes!
      end

      protected

      # call {ActiveInteractor::Context::Attribute#validate!} on each attribute
      #
      # @visibility private
      def validate_attributes!
        attribute_set.attributes.each do |attribute|
          attribute.validate!
          attribute.error_messages.each { |message| errors.add(attribute.name, message) }
        end
      end
    end
  end
end
