# frozen_string_literal: true

module ActiveInteractor
  module Context
    # An attribute of a {ActiveInteractor::Context::Base context}
    #
    # @api private
    #
    # @!attribute [r] description
    #  @return [String, nil] the description of the attribute
    #
    # @!attribute [r] error_messages
    #  @return [Array<Symbol>] the error messages for the attribute
    #
    # @!attribute [r] name
    #  @return [Symbol] the name of the attribute
    class Attribute
      # The default value when no default is provided
      #
      # @visibility private
      NO_DEFAULT_VALUE = :__no_default_value__
      attr_reader :description, :error_messages, :name

      # Create a new instance of {ActiveInteractor::Context::Attribute}
      #
      # @param owner [ActiveInteractor::Context::Base] the {ActiveInteractor::Context::Base context} object the
      #  attribute belongs to.
      # @param [Object] name
      # @param [Object] type
      # @param [Object] description
      # @param [Hash{Symbol => Object}] options
      # @option options [Boolean] :required (false) whether or not the attribute is required
      # @option options [Object] :default (NO_DEFAULT_VALUE) the default value for the attribute
      #
      # @return [ActiveInteractor::Context::Attribute] the new instance of
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
      # @param value [Object] the value to assign to the attribute
      #
      # @return [Object] the value assigned to the attribute
      def assign_value(value)
        @user_provided_value = value
      end

      # The default value for the attribute
      #
      # @return [Object, nil] the default value for the attribute
      def default_value
        return if @options[:default] == NO_DEFAULT_VALUE

        @options[:default]
      end

      # Whether or not the attribute is required
      #
      # @return [Boolean] whether or not the attribute is required
      def required?
        @options[:required]
      end

      # The type of the attribute
      #
      # @return [Object] the type of the attribute
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

      # The value of the attribute
      #
      # @return [Object] the value of the attribute
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
