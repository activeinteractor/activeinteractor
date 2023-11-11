# frozen_string_literal: true

module ActiveInteractor
  module Context
    # Methods for Attribute Assignment
    module AttributeAssignment
      extend ActiveSupport::Concern

      # Create a new instance of {ActiveInteractor::Context::Base}
      #
      # @param attributes [Hash] the attributes to assign to the context
      #
      # @return [ActiveInteractor::Context::Base] the new instance of {ActiveInteractor::Context::Base context}
      def initialize(attributes = {})
        attribute_set.attributes.each do |attribute|
          next unless attributes.with_indifferent_access.key?(attribute.name)

          assign_attribute_value(attribute.name, attributes.with_indifferent_access[attribute.name])
        end
      end

      # Assign an attribute value
      #
      # @example
      #  class CreateUserInput < ActiveInteractor::Context::Input
      #    argument :email, String, 'The email address of the user', required: true
      #  end
      #
      #  input = CreateUserInput.new
      #  input[:email] = 'hello@aaronmallen.me'
      #  #=> 'hello@aaronmallen.me'
      #
      #
      # @param attribute_name [Symbol, String] the name of the attribute to assign
      # @param value [Object] the value to assign to the attribute
      #
      # @return [Object] the value assigned to the attribute
      def []=(attribute_name, value)
        assign_attribute_value(attribute_name, value)
      end

      protected

      # Assign an attribute value
      #
      # @visibility private
      #
      # @param attribute_name [Symbol, String] the name of the attribute to assign
      # @param value [Object] the value to assign to the attribute
      #
      # @return [Object] the value assigned to the attribute
      def assign_attribute_value(attribute_name, value)
        attribute = attribute_set.find(attribute_name)
        raise NoMethodError, "unknown attribute '#{attribute_name}' for #{self.class.name}" unless attribute

        attribute.assign_value(value)
      end

      # Handle method_missing for attribute assignment
      #
      # @visibility private
      #
      # @param method_name [Symbol, String] the name of the method
      # @param arguments [Array<Object>] the arguments passed to the method
      #
      # @raise [ArgumentError] if the number of arguments is not 1
      # @return [Object] the value assigned to the attribute
      def assignment_method_missing(method_name, *arguments)
        if arguments.length != 1
          raise ArgumentError,
                "wrong number of arguments (given #{arguments.length}, expected 1)"
        end

        assign_attribute_value(method_name.to_s.delete('=').to_sym, arguments.first)
      end
    end
  end
end
