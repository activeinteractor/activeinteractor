# frozen_string_literal: true

module ActiveInteractor
  module Context
    # An attribute of a {ActiveInteractor::Context::Base context}
    #
    # @api private
    #
    # @!attribute [r] description
    #   @return [String, nil] the attribute description
    #
    # @!attribute [r] error_messages
    #   @return [Array<Symbol, String, nil>] the attribute error messages
    #
    # @!attribute [r] name
    #   @return [Symbol] the attribute name
    class Attribute
      # Used when no default value is provided
      # @visibility private
      # @return [Symbol]
      NO_DEFAULT_VALUE = :__no_default_value__
      attr_reader :description, :error_messages, :name

      # Create a new instance of {ActiveInteractor::Context::Attribute}
      #
      # @param owner [ActiveInteractor::Context::Base] the context object the attribute belongs to
      # @param name [String, Symbol] the attribute name
      # @param type [Class, ActiveInteractor::Type::Base] the attribute type
      # @param description [String, nil] the attribute description
      # @param options [Hash] the attribute options
      # @option options [Boolean] :required (false) whether the attribute is required
      # @option options [Object] :default (NO_DEFAULT_VALUE) the attribute default value
      # @return [ActiveInteractor::Context::Attribute]
      def initialize(owner, name, type, description = nil, **options)
        @owner = owner
        @name = name.to_sym
        @type_expression = type
        @description = description || options[:description]
        @options = { required: false, default: NO_DEFAULT_VALUE }.merge(options)
        @error_messages = []
      end

      # Assign a value to the attribute
      #
      # @param value [Object] the value to assign
      # @return [void]
      def assign_value(value)
        @user_provided_value = value
      end

      # The attribute default value
      #
      # @return [Object, nil]
      def default_value
        return if @options[:default] == NO_DEFAULT_VALUE

        @options[:default]
      end

      # Whether the attribute is required
      #
      # @return [Boolean]
      def required?
        @options[:required]
      end

      # The attribute type
      #
      # @return [Class, ActiveInteractor::Type::Base, Object]
      def type
        @type_expression
      end

      # Validate the attribute
      #
      # @return [void]
      def validate!
        validate_presence!
        validate_type!
      end

      # The attribute value (user provided or default)
      #
      # @return [Object, nil]
      def value
        @user_provided_value || default_value
      end

      private

      def type_is_a_active_interactor_type?
        type.is_a?(ActiveInteractor::Type::Base) || type.superclass == ActiveInteractor::Type::Base
      end

      def validate_presence!
        return true unless required? && value.nil?

        error_messages << :blank
      end

      def validate_type!
        return true if value.nil?
        return true if %i[any untyped].include?(type)

        if type_is_a_active_interactor_type?
          return true if type.valid?(value)

          error_messages << :invalid
        elsif value.is_a?(type)
          return true
        end

        error_messages << :invalid
      end
    end
  end
end
