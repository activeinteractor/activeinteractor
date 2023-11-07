# frozen_string_literal: true

module ActiveInteractor
  module Context
    # The base class for runtime context objects
    #
    # @api private
    class Runtime < Base
      # Create a new instance of {ActiveInteractor::Context::Runtime} and assign
      # attribute values
      #
      # @param attributes [Hash] attribute values
      # @return [ActiveInteractor::Context::Runtime]
      def initialize(attributes = {})
        super
        @table = {}
      end

      # The context attributes
      #
      # @return [Hash] the context attributes
      def attributes
        clean = attribute_set.attributes.each_with_object({}) do |attribute, result|
          result[attribute.name] = attribute.value
        end
        @table.merge(clean)
      end

      private

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
        return super if attribute

        assign_dirty_attribute_value(attribute_name, value)
      end

      # Assign dirty attribute values
      #
      # @api private
      # @visibility private
      #
      # @param attribute_name [String, Symbol] the attribute name to assign
      # @param value [Object] the attribute value to assign
      # @return [Object] the attribute value
      def assign_dirty_attribute_value(attribute_name, value)
        @table[attribute_name.to_sym] = value
      end

      # Gracefully handle missing methods
      #
      # @api private
      # @visibility private
      #
      # @param method_name [String, Symbol] the attribute name to read or assign
      # @param arguments [Array] the attribute value to assign
      # @return [Object] the attribute value
      def method_missing(method_name, *arguments)
        return assignment_method_missing(method_name, *arguments) if method_name.to_s.end_with?('=')

        read_attribute_value(method_name)
      end

      # Read attribute values
      #
      # @api private
      # @visibility private
      #
      # @param attribute_name [String, Symbol] the attribute name to read
      # @return [Object] the attribute value
      def read_attribute_value(attribute_name)
        attribute = attribute_set.find(attribute_name)
        return super if attribute

        read_dirty_attribute_value(attribute_name)
      end

      # Read dirty attribute values
      #
      # @api private
      # @visibility private
      #
      # @param attribute_name [String, Symbol] the attribute name to read
      # @return [Object] the attribute value
      def read_dirty_attribute_value(attribute_name)
        @table[attribute_name.to_sym]
      end

      # Gracefully handle missing methods
      #
      # @api private
      # @visibility private
      #
      # @param _method_name [String, Symbol] the attribute name to read
      # @param _include_private [Boolean] whether or not to include private methods
      # @return [Boolean] whether or not the attribute exists
      # @param [Object] _method_name
      def respond_to_missing?(_method_name, _include_private = false)
        true
      end
    end
  end
end
