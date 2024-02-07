# frozen_string_literal: true

module ActiveInteractor
  module Context
    # The base class for all context objects
    class Base
      extend Type::DeclerationMethods::ClassMethods
      include ActiveModel::Validations
      include Type::DeclerationMethods

      validate :validate_attributes!

      class << self
        def method_defined?(method_name)
          attribute_set.attribute_names.include?(method_name.to_s.delete('=').to_sym) || super
        end

        protected

        def attribute_set
          @attribute_set ||= AttributeSet.new(self)
        end
      end

      def initialize(attributes = {})
        attribute_set.attributes.each do |attribute|
          next unless attributes.with_indifferent_access.key?(attribute.name)

          assign_attribute_value(attribute.name, attributes.with_indifferent_access[attribute.name])
        end
      end

      def [](attribute_name)
        read_attribute_value(attribute_name)
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

      def attribute_set
        @attribute_set ||= AttributeSet.new(self, *self.class.send(:attribute_set).attributes.map(&:dup))
      end

      def method_missing(method_name, *arguments)
        return super unless respond_to_missing?(method_name)
        return assignment_method_missing(method_name, *arguments) if method_name.to_s.end_with?('=')

        read_attribute_value(method_name)
      end

      def read_attribute_value(attribute_name)
        attribute = attribute_set.find(attribute_name)
        raise NoMethodError, "unknown attribute '#{attribute_name}' for #{self.class.name}" unless attribute

        attribute.value
      end

      def respond_to_missing?(method_name, _include_private = false)
        return true if attribute_set.attribute_names.include?(method_name.to_sym)
        return true if attribute_set.attribute_names.include?(method_name.to_s.delete('=').to_sym)

        super
      end

      def validate_attributes!
        attribute_set.attributes.each do |attribute|
          attribute.validate!
          attribute.error_messages.each { |message| errors.add(attribute.name, message) }
        end
      end
    end
  end
end
