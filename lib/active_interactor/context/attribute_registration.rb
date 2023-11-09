# frozen_string_literal: true

module ActiveInteractor
  module Context
    module AttributeRegistration
      extend ActiveSupport::Concern

      module ClassMethods
        def method_defined?(method_name)
          attribute_set.attribute_names.include?(method_name.to_s.delete('=').to_sym) || super
        end

        protected

        def attribute_set
          @attribute_set ||= AttributeSet.new(self)
        end
      end

      def [](attribute_name)
        read_attribute_value(attribute_name)
      end

      protected

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
    end
  end
end
