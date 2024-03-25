# frozen_string_literal: true

module ActiveInteractor
  module Context
    class Attribute
      NO_DEFAULT_VALUE = :__no_default_value__
      attr_reader :description, :error_messages, :name

      def initialize(owner, name, type, description = nil, **options)
        parse_options(description, options)

        @owner = owner
        @name = name.to_sym
        @type_expression = type
        @error_messages = []
      end

      def assign_value(value)
        @user_provided_value = value
      end

      def default_value
        return if @options[:default] == NO_DEFAULT_VALUE

        @options[:default]
      end

      def required?
        @options[:required]
      end

      def type
        @type_expression
      end

      def validate!
        validate_presence!
        validate_type!
      end

      def value
        @user_provided_value || default_value
      end

      private

      def parse_options(description, options)
        if description.is_a?(String)
          @description = description
          @options = { required: false, default: NO_DEFAULT_VALUE }.merge(options)
        elsif description.is_a?(Hash)
          @options = { required: false, default: NO_DEFAULT_VALUE }.merge(description)
          @description = @options[:description]
        elsif description.nil?
          @description = nil
          @options = { required: false, default: NO_DEFAULT_VALUE }.merge(options)
        end
      end

      def type_is_a_active_interactor_type?
        type.is_a?(ActiveInteractor::Type::Base) || type.superclass == ActiveInteractor::Type::Base
      end

      def validate_presence!
        return true unless required? && value.nil?

        error_messages << :blank
      end

      def validate_type!
        return true if value_nil_or_untyped?
        return true if type_is_a_active_interactor_type? && type.valid?(value)
        return true if value.is_a?(type)

        error_messages << :invalid
      end

      def value_nil_or_untyped?
        value.nil? || %i[any untyped].include?(type)
      end
    end
  end
end
