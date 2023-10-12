# frozen_string_literal: true

module ActiveInteractor
  module Context
    class Base
      include ActiveModel::Validations
      include HasActiveModelErrors
      include AttributeRegistration
      include AttributeAssignment
      include Type::HasTypes

      def initialize(attributes = {})
        super
        @errors = ActiveModel::Errors.new(self)
      end

      def validate!
        attribute_set.attributes.each do |attribute|
          attribute.validate!
          attribute.error_messages.each { |message| errors.add(attribute.name, message) }
        end
      end
    end
  end
end
