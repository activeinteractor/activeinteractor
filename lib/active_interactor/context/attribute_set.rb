# frozen_string_literal: true

module ActiveInteractor
  module Context
    class AttributeSet
      def initialize(*attributes)
        @set = {}
        attributes.each { |attribute| @set[attribute.name] = attribute }
      end

      def add(*attribute_args)
        attribute_options = attribute_args.extract_options!
        attribute = Attribute.new(*attribute_args, **attribute_options)
        @set[attribute.name] = attribute
      end

      def attribute_names
        @set.keys
      end

      def attributes
        @set.values
      end

      def find(attribute_name)
        @set[attribute_name.to_sym]
      end

      def merge(attributes)
        attributes.each { |attribute| @set[attribute.name] = attribute }
      end
    end
  end
end
