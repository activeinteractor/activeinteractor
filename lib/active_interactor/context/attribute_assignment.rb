# frozen_string_literal: true

module ActiveInteractor
  module Context
    module AttributeAssignment
      extend ActiveSupport::Concern

      def initialize(attributes = {})
        attribute_set.attributes.each do |attribute|
          next unless attributes.with_indifferent_access.key?(attribute.name)

          assign_attribute_value(attribute.name, attributes.with_indifferent_access[attribute.name])
        end
      end

      def []=(attribute_name, value)
        assign_attribute_value(attribute_name, value)
      end

      protected

      def assign_attribute_value(attribute_name, value)
        attribute = attribute_set.find(attribute_name)
        raise NoMethodError, "unknown attribute '#{attribute_name}' for #{self.class.name}" unless attribute

        attribute.assign_value(value)
      end

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
