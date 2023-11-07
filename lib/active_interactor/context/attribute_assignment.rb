# frozen_string_literal: true

module ActiveInteractor
  module Context
    # Methods for assiging and reading attributes
    #
    # @abstract included in {ActiveInteractor::Context::Base}
    module AttributeAssignment
      extend ActiveSupport::Concern

      # Create a new instance of {ActiveInteractor::Context::Base} and assign
      # attribute values
      #
      # see {ActiveInteractor::Context::Base#initialize}
      def initialize(attributes = {})
        attribute_set.attributes.each do |attribute|
          next unless attributes.with_indifferent_access.key?(attribute.name)

          assign_attribute_value(attribute.name, attributes.with_indifferent_access[attribute.name])
        end
      end

      # Read an attribute by key
      #
      # @example Read the User#login attribute
      #  class CreateUserInput < ActiveInteractor::Context::Input
      #    argument :login, String, 'The User login', required: true
      #    argument :password, String, 'The User password', required: true
      #  end
      #
      #  context = CreateUserInput.new(login: 'hello@aaronmallen.me', password: 'password')
      #  context[:login]
      #  #=> 'hello@aaronmallen.me'
      #
      # @param attribute_name [String, Symbol] the attribute name to read
      # @return [Object] the attribute value
      def [](attribute_name)
        read_attribute_value(attribute_name)
      end

      # Assign an attribute value by key
      #
      # @example Assign the User#login attribute
      #  class CreateUserInput < ActiveInteractor::Context::Input
      #    argument :login, String, 'The User login', required: true
      #    argument :password, String, 'The User password', required: true
      #  end
      #
      #  context = CreateUserInput.new(password: 'password')
      #  context[:login] = 'hello@aaronmallen.me'
      #  #=> 'hello@aaronmallen.me'
      #
      # @param attribute_name [String, Symbol] the attribute name to assign
      # @param value [Object] the attribute value to assign
      # @return [void]
      def []=(attribute_name, value)
        assign_attribute_value(attribute_name, value)
      end

      protected

      # Assign attribute values
      #
      # @api private
      # @visibility private
      #
      # @param attribute_name [String, Symbol] the attribute name to assign
      # @param value [Object] the attribute value to assign
      # @return [Object] the attribute value
      def assign_attribute_value(attribute_name, value)
        attribute = attribute_set.find(attribute_name)
        raise NoMethodError, "unknown attribute '#{attribute_name}' for #{self.class.name}" unless attribute

        attribute.assign_value(value)
      end

      # Assign attribute values for {#method_missing}
      #
      # @api private
      # @visibility private
      #
      # @param method_name [String, Symbol] the attribute name to assign
      # @param arguments [Array] the attribute value to assign
      # @raise [ArgumentError] if the number of arguments is not 1
      # @return [Object] the attribute value
      def assignment_method_missing(method_name, *arguments)
        if arguments.length != 1
          raise ArgumentError,
                "wrong number of arguments (given #{arguments.length}, expected 1)"
        end

        assign_attribute_value(method_name.to_s.delete('=').to_sym, arguments.first)
      end

      # Gracefully handle missing methods
      #
      # @api private
      # @visibility private
      #
      # @param method_name [String, Symbol] the attribute name to read or assign
      # @param arguments [Array] the attribute value to assign
      # @raise [ArgumentError] if the number of arguments is not 1
      # @raise [NoMethodError] if the attribute cannon be found
      # @return [Object] the attribute value
      def method_missing(method_name, *arguments)
        return super unless respond_to_missing?(method_name)
        return assignment_method_missing(method_name, *arguments) if method_name.to_s.end_with?('=')

        read_attribute_value(method_name)
      end

      # Read attribute values
      #
      # @api private
      # @visibility private
      #
      # @param attribute_name [String, Symbol] the attribute name to read
      # @raise [NoMethodError] if the attribute cannon be found
      # @return [Object] the attribute value
      def read_attribute_value(attribute_name)
        attribute = attribute_set.find(attribute_name)
        raise NoMethodError, "unknown attribute '#{attribute_name}' for #{self.class.name}" unless attribute

        attribute.value
      end

      # Gracefully handle missing methods
      #
      # @api private
      # @visibility private
      #
      # @param method_name [String, Symbol] the attribute name to read
      # @param _include_private [Boolean] whether or not to include private methods
      # @return [Boolean] whether or not the attribute exists
      def respond_to_missing?(method_name, _include_private = false)
        return true if attribute_set.attribute_names.include?(method_name.to_sym)
        return true if attribute_set.attribute_names.include?(method_name.to_s.delete('=').to_sym)

        super
      end
    end
  end
end
