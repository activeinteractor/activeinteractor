# frozen_string_literal: true

module ActiveInteractor
  module Context
    # The base class for context objects
    #
    # @abstract Iherited by {ActiveInteractor::Context::Input}, {ActiveInteractor::Context::Output},
    #  and {ActiveInteractor::Context::Runtime}
    #
    # @!attribute [r] errors
    #  @return [ActiveModel::Errors] the context errors
    #  @see https://github.com/rails/rails/blob/main/activemodel/lib/active_model/errors.rb
    #   ActiveModel::Errors
    #
    # @!method attribute_method?(attribute)
    #  @!scope class
    #  @see https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-attribute_method-3F
    #   ActiveModel::AttributeMethods::ClassMethods#attribute_method?
    #
    # @!method clear_validators!
    #  @!scope class
    #  @see https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-clear_validators-21
    #   ActiveModel::AttributeMethods::ClassMethods#clear_validators!
    #
    # @!method validate(*args, &block)
    #  @!scope class
    #  @see https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validate
    #   ActiveModel::AttributeMethods::ClassMethods#validate
    #
    # @!method validates(*attributes)
    #  @!scope class
    #  @see https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validates
    #   ActiveModel::AttributeMethods::ClassMethods#validates
    #
    # @!method validates!(*attributes)
    #  @!scope class
    #  @see https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validates-21
    #   ActiveModel::AttributeMethods::ClassMethods#validates!
    #
    # @!method validates_each(*attr_names, &block)
    #  @!scope class
    #  @see https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validates_each
    #   ActiveModel::AttributeMethods::ClassMethods#validates_each
    #
    # @!method validates_with(*args, &block)
    #  @!scope class
    #  @see https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validates_with
    #   ActiveModel::AttributeMethods::ClassMethods#validates_with
    #
    # @!method validators
    #  @!scope class
    #  @see https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validators
    #   ActiveModel::AttributeMethods::ClassMethods#validators
    #
    # @!method validators_on(*attributes)
    #  @!scope class
    #  @see https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validators_on
    #   ActiveModel::AttributeMethods::ClassMethods#validators_on
    #
    # @!method invalid?(context = nil)
    #  @see https://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-invalid-3F
    #   ActiveModel::Validations#invalid?
    #
    # @!method valid?(context = nil)
    #  @see https://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-valid-3F
    #   ActiveModel::Validations#valid?
    #
    # @!method validate(context = nil)
    #  @see https://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-validate
    #   ActiveModel::Validations#validate
    #
    # @!method validate!(context = nil)
    #  @see https://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-validate-21
    #   ActiveModel::Validations#validate!
    #
    # @!method validates_with(*args, &block)
    #  @see https://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-validates_with
    #   ActiveModel::Validations#validates_with
    #
    # @!method validation_context
    #  @see https://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-validation_context
    #   ActiveModel::Validations#validation_context
    class Base
      include ActiveModel::Validations
      include ActiveModelErrorMethods
      include AttributeRegistration
      include AttributeAssignment
      include Type::DeclerationMethods

      validate :validate_attributes!

      # Create a new instance of {ActiveInteractor::Context::Base} and assign
      # attribute values
      #
      # @example
      #  class CreateUserInput < ActiveInteractor::Context::Input
      #    argument :login, String, 'The User login', required: true
      #    argument :password, String, 'The User password', required: true
      #  end
      #
      #  CreateUserInput.new(login: 'hello@aaronmallen.me', password: 'password')
      #  #=> <#CreateUser @login='hello@aaronmallen.me' @password='password'>
      #
      # @param attributes [Hash] attribute values
      # @return [ActiveInteractor::Context::Base]
      def initialize(attributes = {})
        super
        @errors = ActiveModel::Errors.new(self)
      end

      protected

      # Validate the context attributes
      #
      # @api private
      # @visibility private
      # @return [void]
      def validate_attributes!
        attribute_set.attributes.each do |attribute|
          attribute.validate!
          attribute.error_messages.each { |message| errors.add(attribute.name, message) }
        end
      end
    end
  end
end
