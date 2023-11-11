# frozen_string_literal: true

module ActiveInteractor
  module Context
    # The base class for all runtime context objects
    class Runtime < Base
      # Create a new instance of {ActiveInteractor::Context::Runtime} and assign the attributes
      #
      # @param attributes [Hash{Symbol => Object}] the attributes to assign to the context
      def initialize(attributes = {})
        super
        @table = {}
      end

      # Return the attributes as a hash
      #
      # @return [Hash{Symbol => Object}] the attributes as a hash
      def attributes
        clean = attribute_set.attributes.each_with_object({}) do |attribute, result|
          result[attribute.name] = attribute.value
        end
        @table.merge(clean)
      end

      private

      def assign_attribute_value(attribute_name, value)
        attribute = attribute_set.find(attribute_name)
        return super if attribute

        assign_dirty_attribute_value(attribute_name, value)
      end

      def assign_dirty_attribute_value(attribute_name, value)
        @table[attribute_name.to_sym] = value
      end

      def method_missing(method_name, *arguments)
        return assignment_method_missing(method_name, *arguments) if method_name.to_s.end_with?('=')

        read_attribute_value(method_name)
      end

      def read_attribute_value(attribute_name)
        attribute = attribute_set.find(attribute_name)
        return super if attribute

        read_dirty_attribute_value(attribute_name)
      end

      def read_dirty_attribute_value(attribute_name)
        @table[attribute_name.to_sym]
      end

      def respond_to_missing?(_method_name, _include_private = false)
        true
      end
    end
  end
end
