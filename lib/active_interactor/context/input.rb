# frozen_string_literal: true

module ActiveInteractor
  module Context
    # The base class for input context objects
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
    #
    # @example Create an input context class and use it in an interactor
    #  class CreateUserInput < ActiveInteractor::Context::Input
    #    argument :login, String, 'The User login', required: true
    #    argument :password, String, 'The User password', required: true
    #  end
    #
    #  class CreateUser < ActiveInteractor::Interactor::Base
    #    accepts_arguments_matching CreateUserInput
    #
    #    returns :user, User, 'The created User', required: true
    #  end
    class Input < Base
      # Add an argument {ActiveInteractor::Context::Attribute attribute} to the context
      #
      # @example
      #  class CreateUserInput < ActiveInteractor::Context::Input
      #    argument :login, String, 'The User login', required: true
      #    argument :password, String, 'The User password', required: true
      #  end
      #
      # see {ActiveInteractor::Context::Attribute#initialize}
      #
      # @param attribute_args [Array] the attribute arguments
      # @return [void]
      def self.argument(*attribute_args)
        attribute_set.add(*attribute_args)
      end

      # The argument names
      #
      # @example
      #  class CreateUserInput < ActiveInteractor::Context::Input
      #    argument :login, String, 'The User login', required: true
      #    argument :password, String, 'The User password', required: true
      #  end
      #
      #  CreateUserInput.argument_names
      #  #=> [:login, :password]
      #
      # @return [Array<Symbol>]
      def self.argument_names
        attribute_set.attribute_names
      end

      # The {ActiveInteractor::Context::Attribute arguments} of the context
      #
      # @return [Array<ActiveInteractor::Context::Attribute>]
      def self.arguments
        attribute_set.attributes
      end
    end
  end
end
