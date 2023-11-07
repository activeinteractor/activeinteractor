# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    # The base class for all interactors
    #
    # @abstract Subclass and override {#interact} to implement an interactor
    #
    # @!attribute [r] context
    #  @api protected
    #  @return [ActiveInteractor::Context::Runtime] the runtime context
    #
    # @!method input_attribute_method?(attribute)
    #  Calls {ActiveInteractor::Context::Input.attribute_method? .attribute_method?} on the
    #   {ActiveInteractor::Context::Input input context}
    #  @!scope class
    #
    # @!method input_clear_validators!
    #  Calls {ActiveInteractor::Context::Input.clear_validators! .clear_validators!} on the
    #  {ActiveInteractor::Context::Input input context}
    #  @!scope class
    #
    # @!method input_validate(*args, &block)
    #  Calls {ActiveInteractor::Context::Input.validate .validate} on the
    #   {ActiveInteractor::Context::Input input context}
    #  @!scope class
    #
    # @!method input_validates(*attributes)
    #  Calls {ActiveInteractor::Context::Input.validates .validates} on the
    #   {ActiveInteractor::Context::Input input context}
    #  @!scope class
    #
    #  @example
    #   class CreateUser < ActiveInteractor::Interactor::Base
    #     argument :login, String, 'The User login', required: true
    #     argument :password, String, 'The User password', required: true
    #     argument :password_confirmation, String, 'The User password confirmation', required: true
    #
    #     input_validates :password, confirmation: true
    #   end
    #
    # @!method input_validates!(*attributes)
    #  Calls {ActiveInteractor::Context::Input.validates! .validates!} on the
    #   {ActiveInteractor::Context::Input input context}
    #  @!scope class
    #
    # @!method input_validates_each(*attr_names, &block)
    #  Calls {ActiveInteractor::Context::Input.validates_each .validates_each} on the
    #   {ActiveInteractor::Context::Input input context}
    #  @!scope class
    #
    # @!method input_validates_with(*args, &block)
    #  Calls {ActiveInteractor::Context::Input.validates_with .validates_with} on the
    #   {ActiveInteractor::Context::Input input context}
    #  @!scope class
    #
    # @!method input_validators
    #  Calls {ActiveInteractor::Context::Input.validators .validators} on the
    #   {ActiveInteractor::Context::Input input context}
    #  @!scope class
    #
    # @!method input_validators_on(*attributes)
    #  Calls {ActiveInteractor::Context::Input.validators_on .validators_on} on the
    #   {ActiveInteractor::Context::Input input context}
    #  @!scope class
    #
    # @!method output_attribute_method?(attribute)
    #  Calls {ActiveInteractor::Context::Output.attribute_method? .attribute_method?} on the
    #   {ActiveInteractor::Context::Output output context}
    #  @!scope class
    #
    # @!method output_clear_validators!
    #  Calls {ActiveInteractor::Context::Output.clear_validators! .clear_validators!} on the
    #  {ActiveInteractor::Context::Output output context}
    #  @!scope class
    #
    # @!method output_validate(*args, &block)
    #  Calls {ActiveInteractor::Context::Output.validate .validate} on the
    #   {ActiveInteractor::Context::Output output context}
    #  @!scope class
    #
    # @!method output_validates(*attributes)
    #  Calls {ActiveInteractor::Context::Output.validates .validates} on the
    #   {ActiveInteractor::Context::Output output context}
    #  @!scope class
    #
    #  @example
    #   class CreateUser < ActiveInteractor::Interactor::Base
    #     VALID_ROLES = %w[admin user].freeze
    #     argument :login, String, 'The User login', required: true
    #     argument :password, String, 'The User password', required: true
    #     argument :password_confirmation, String, 'The User password confirmation', required: true
    #
    #     returns :user, User, 'The created User', required: true
    #     returns :user_role, String, 'The created User role', required: true
    #
    #     output_validates :user_role, inclusion: { in: VALID_ROLES }
    #   end
    #
    # @!method output_validates!(*attributes)
    #  Calls {ActiveInteractor::Context::Output.validates! .validates!} on the
    #   {ActiveInteractor::Context::Output output context}
    #  @!scope class
    #
    # @!method output_validates_each(*attr_names, &block)
    #  Calls {ActiveInteractor::Context::Output.validates_each .validates_each} on the
    #   {ActiveInteractor::Context::Output output context}
    #  @!scope class
    #
    # @!method output_validates_with(*args, &block)
    #  Calls {ActiveInteractor::Context::Output.validates_with .validates_with} on the
    #   {ActiveInteractor::Context::Output output context}
    #  @!scope class
    #
    # @!method output_validators
    #  Calls {ActiveInteractor::Context::Output.validators .validators} on the
    #   {ActiveInteractor::Context::Output output context}
    #  @!scope class
    #
    # @!method output_validators_on(*attributes)
    #  Calls {ActiveInteractor::Context::Output.validators_on .validators_on} on the
    #   {ActiveInteractor::Context::Output output context}
    #  @!scope class
    #
    # @method argument(attribute_name, type, description, options = {})
    #  @scope class
    #  Calls {ActiveInteractor::Context::Input.argument .argument} on the
    #   {ActiveInteractor::Context::Input input context}
    #
    # @!method argument_names
    #  @scope class
    #  Calls {ActiveInteractor::Context::Input.argument_names .argument_names} on the
    #   {ActiveInteractor::Context::Input input context}
    #
    # @!method arguments
    #  @scope class
    #  Calls {ActiveInteractor::Context::Input.arguments .arguments} on the
    #   {ActiveInteractor::Context::Input input context}
    #
    # @!method returns(attribute_name, type, description, options = {})
    #  @scope class
    #  Calls {ActiveInteractor::Context::Output.returns .returns} on the
    #   {ActiveInteractor::Context::Output output context}
    #
    # @!method field_names
    #  @scope class
    #  Calls {ActiveInteractor::Context::Output.field_names .field_names} on the
    #   {ActiveInteractor::Context::Output output context}
    #
    # @!method fields
    #  @scope class
    #  Calls {ActiveInteractor::Context::Output.fields .fields} on the
    #   {ActiveInteractor::Context::Output output context}
    class Base
      extend ContextMethods::ClassMethods
      extend InteractionMethods::ClassMethods
      include ContextMethods
      include InteractionMethods
      include Type::DeclerationMethods

      # Create an instance of {ActiveInteractor::Interactor::Base}
      # @param input [Hash] The input context attributes
      # @return [ActiveInteractor::Interactor::Base] The interactor instance
      def initialize(input = {})
        @raw_input = input.dup
        validate_input_and_generate_runtime_context!
      end

      # Perform the {#interaction} and return a {ActiveInteractor::Result result}
      #
      # @raise [ActiveInteractor::Error] If the {#interaction} fails
      # @return [ActiveInteractor::Result] The result
      def perform!
        with_notification(:perform) do |payload|
          interact
          generate_and_validate_output_context!
          payload[:result] = Result.success(data: output_to_result_context!)
        end
      end

      protected

      # fail an {#interaction} and return a {ActiveInteractor::Result result}
      #
      # @param errors [Hash] The errors to include in the result
      # @raise [ActiveInteractor::Error]
      def fail!(errors = {})
        result = nil
        with_notification(:rollback) do |payload|
          rollback
          result = Result.failure(data: @output, errors: errors)
          payload[:result] = result
        end

        raise Error, result
      end

      # @api private
      # @visibility private
      def with_notification(action)
        ActiveSupport::Notifications.instrument("#{self.class.name}::#{action.to_s.classify}") do |payload|
          yield payload if block_given?
        end
      end
    end
  end
end
