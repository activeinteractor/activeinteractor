# frozen_string_literal: true

module ActiveInteractor
  module Context
    # A set of {ActiveInteractor::Context::Attribute attributes}
    #
    # @api private
    class AttributeSet
      # Create a new instance of {ActiveInteractor::Context::AttributeSet}
      #
      # @param owner [ActiveInteractor::Context::Base] the context object the set belongs to
      # @param attributes [Array<ActiveInteractor::Context::Attribute>] the attributes to add to the set
      # @return [ActiveInteractor::Context::AttributeSet]
      def initialize(owner, *attributes)
        @owner = owner
        @set = {}
        attributes.each { |attribute| @set[attribute.name] = attribute }
      end

      # Add an attribute to the set
      #
      # @param attribute_args [Array<Object>] the attribute arguments
      #   see {ActiveInteractor::Context::Attribute#initialize}
      # @return [ActiveInteractor::Context::Attribute]
      def add(*attribute_args)
        attribute_options = attribute_args.extract_options!
        attribute = Attribute.new(@owner, *attribute_args, **attribute_options)
        @set[attribute.name] = attribute
      end

      # The attribute names in the set
      #
      # @return [Array<Symbol>]
      def attribute_names
        @set.keys
      end

      # The attributes in the set
      #
      # @return [Array<ActiveInteractor::Context::Attribute>]
      def attributes
        @set.values
      end

      # Find an attribute by name
      #
      # @param attribute_name [String, Symbol] the attribute name
      # @return [ActiveInteractor::Context::Attribute, nil]
      def find(attribute_name)
        @set[attribute_name.to_sym]
      end

      # Merge attributes into the set
      #
      # @param attributes [Array<ActiveInteractor::Context::Attribute>] the attributes to merge
      # @return [void]
      def merge(attributes)
        attributes.each { |attribute| @set[attribute.name] = attribute }
      end
    end
  end
end
