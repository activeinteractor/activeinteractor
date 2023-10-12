# frozen_string_literal: true

module ActiveInteractor
  module Context
    class Base
      include ActiveModel::Validations
      include HasActiveModelErrors
      include AttributeRegistration
      include AttributeAssignment
      include Type::HasTypes

      attr_reader :errors

      def initialize(attributes = {})
        @errors = ActiveModel::Errors.new(self)
        attribute_set.attributes.each do |attribute|
          next unless attributes.with_indifferent_access.key?(attribute.name)

          assign_attribute_value(attribute.name, attributes.with_indifferent_access[attribute.name])
        end
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
