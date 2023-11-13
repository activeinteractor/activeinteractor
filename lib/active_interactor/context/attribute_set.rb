# frozen_string_literal: true

module ActiveInteractor
  module Context
    # A collection of {ActiveInteractor::Context::Attribute attributes}
    #
    # @api private
    class AttributeSet
      # Create a new instance of {ActiveInteractor::Context::AttributeSet}
      #
      # @param owner [ActiveInteractor::Context::Base] the {ActiveInteractor::Context::Base context} object
      # @param attributes [Array<ActiveInteractor::Context::Attribute>] the attributes to add to the set
      #
      # @return [ActiveInteractor::Context::AttributeSet] the new instance of {ActiveInteractor::Context::AttributeSet}
      def initialize(owner, *attributes)
        @owner = owner
        @set = {}
        attributes.each { |attribute| @set[attribute.name] = attribute }
      end

      # Add an attribute to the set
      #
      # @note see {ActiveInteractor::Context::Attribute#initialize}
      #
      # @param attribute_args [Array<Object>] the arguments to pass to
      #  {ActiveInteractor::Context::Attribute#initialize}
      #
      # @return [ActiveInteractor::Context::Attribute] the new instance of {ActiveInteractor::Context::Attribute}
      def add(*attribute_args)
        attribute_options = attribute_args.extract_options!
        attribute = Attribute.new(@owner, *attribute_args, **attribute_options)
        @set[attribute.name] = attribute
      end

      # The attribute names in the set
      #
      # @return [Array<Symbol>] the attribute names in the set
      def attribute_names
        @set.keys
      end

      # The attributes in the set
      #
      # @return [Array<ActiveInteractor::Context::Attribute>] the attributes in the set
      def attributes
        @set.values
      end

      # Find an attribute in the set by name
      #
      # @param attribute_name [Symbol, String] the name of the attribute to find
      #
      # @return [ActiveInteractor::Context::Attribute, nil] the found attribute
      def find(attribute_name)
        @set[attribute_name.to_sym]
      end

      # Merge attributes into the set
      #
      # @param attributes [Array<ActiveInteractor::Context::Attribute>] the attributes to merge into the set
      #
      # @return [void]
      def merge(attributes)
        attributes.each { |attribute| @set[attribute.name] = attribute }
      end
    end
  end
end
