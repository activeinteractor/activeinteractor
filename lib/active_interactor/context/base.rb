# frozen_string_literal: true

module ActiveInteractor
  module Context
    class Base
      include ActiveModel::Validations
      include ActiveModelErrorMethods
      include AttributeRegistration
      include AttributeAssignment
      include Type::DeclerationMethods

      validate :validate_attributes!

      def initialize(attributes = {})
        super
        @errors = ActiveModel::Errors.new(self)
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
