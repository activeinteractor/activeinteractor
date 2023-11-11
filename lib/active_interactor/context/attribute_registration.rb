# frozen_string_literal: true

module ActiveInteractor
  module Context
    # Methods for Attribute Registration
    module AttributeRegistration
      extend ActiveSupport::Concern

      # Class Methods for Attribute Registration
      module ClassMethods
        # Whether or not a method is defined on the {ActiveInteractor::Context::Base context} object
        #
        # @visibility private
        #
        # @param method_name [Symbol, String] the name of the method to check
        #
        # @return [Boolean] whether or not the method is defined on the {ActiveInteractor::Context::Base context}
        #  object
        def method_defined?(method_name)
          attribute_set.attribute_names.include?(method_name.to_s.delete('=').to_sym) || super
        end

        protected

        # The set of attributes on the {ActiveInteractor::Context::Base context} class
        #
        # @visibility private
        #
        # @return [ActiveInteractor::AttributeSet] the set of attributes on the
        #  {ActiveInteractor::Context::Base context} object
        def attribute_set
          @attribute_set ||= AttributeSet.new(self)
        end
      end

      # Read an attribute value
      #
      # @example
      #  class CreateUserInput < ActiveInteractor::Context::Input
      #    argument :email, String, 'The email address of the user', required: true
      #  end
      #
      #  input = CreateUserInput.new(email: 'hello@aaronmallen.me')
      #  input[:email]
      #  #=> 'hello@aaronmallen.me'
      #
      # @param attribute_name [Symbol, String] the name of the attribute to read
      #
      # @return [Object] the value of the attribute
      def [](attribute_name)
        read_attribute_value(attribute_name)
      end

      protected

      # The set of attributes on the {ActiveInteractor::Context::Base context} instance
      #
      # @visibility private
      #
      # @return [ActiveInteractor::AttributeSet] the set of attributes on the {ActiveInteractor::Context::Base context}
      #  instance
      def attribute_set
        @attribute_set ||= AttributeSet.new(self, *self.class.send(:attribute_set).attributes.map(&:dup))
      end

      # Handle method_missing for attribute assignment
      #
      # @visibility private
      #
      # @param method_name [Symbol, String] the name of the method to handle
      # @param arguments [Array<Object>] the arguments passed to the method
      #
      # @raise [ArgumentError] if the number of arguments is not 1
      # @raise [NoMethodError] if the attribute is not defined
      # @return [Object] the value assigned to the attribute
      def method_missing(method_name, *arguments)
        return super unless respond_to_missing?(method_name)
        return assignment_method_missing(method_name, *arguments) if method_name.to_s.end_with?('=')

        read_attribute_value(method_name)
      end

      # Read an attribute value
      #
      # @visibility private
      #
      # @param attribute_name [Symbol, String] the name of the attribute to read
      #
      # @return [Object] the value of the attribute
      def read_attribute_value(attribute_name)
        attribute = attribute_set.find(attribute_name)
        raise NoMethodError, "unknown attribute '#{attribute_name}' for #{self.class.name}" unless attribute

        attribute.value
      end

      # Handle respond_to_missing? for attribute assignment
      #
      # @visibility private
      #
      # @param method_name [Symbol, String] the name of the method to handle
      # @param _include_private [Boolean] whether or not to include private methods
      #
      # @return [Boolean] whether or not the method is defined on the {ActiveInteractor::Context::Base context} object
      def respond_to_missing?(method_name, _include_private = false)
        return true if attribute_set.attribute_names.include?(method_name.to_sym)
        return true if attribute_set.attribute_names.include?(method_name.to_s.delete('=').to_sym)

        super
      end
    end
  end
end
