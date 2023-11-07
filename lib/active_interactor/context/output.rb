# frozen_string_literal: true

module ActiveInteractor
  module Context
    # The base class for output context objects
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
    # @example Create an output context class and use it in an interactor
    #  class CreateUserOutput < ActiveInteractor::Context::Input
    #    returns :user, User, 'The created User', required: true
    #  end
    #
    #  class CreateUser < ActiveInteractor::Interactor::Base
    #    argument :login, String, 'The User login', required: true
    #    argument :password, String, 'The User password', required: true
    #
    #    returns_data_matching CreateUserOutput
    #  end
    class Output < Base
      # @!method as_json
      #  @return [Hash] the context {#fields} as a json hash
      #
      # @!method to_h
      #  @return [Hash] the context {#fields} as a hash
      #
      # @!method to_hash
      #  @return [Hash] the context {#fields} as a hash
      #
      # @!method to_json
      #  @return [String] the context {#fields} as a json string
      delegate :as_json, :to_h, :to_hash, :to_json, to: :fields

      # Add a field {ActiveInteractor::Context::Attribute attribute} to the context
      #
      # @example
      #  class CreateUserOutput < ActiveInteractor::Context::Input
      #    returns :user, User, 'The created User', required: true
      #  end
      #
      # see {ActiveInteractor::Context::Attribute#initialize}
      #
      # @param attribute_args [Array] the attribute arguments
      # @return [void]
      def self.returns(*attribute_args)
        attribute_set.add(*attribute_args)
      end

      # The field names
      #
      # @example
      #  class CreateUserOutput < ActiveInteractor::Context::Input
      #    returns :user, User, 'The created User', required: true
      #  end
      #
      #  CreateUserOutput.field_names
      #  #=> [:user]
      #
      # @return [Array<Symbol>]
      def self.field_names
        attribute_set.attribute_names
      end

      # The {ActiveInteractor::Context::Attribute fields} of the context
      #
      # @return [Array<ActiveInteractor::Context::Attribute>]
      def self.fields
        attribute_set.attributes
      end

      # The context fields as a hash
      #
      # @example
      #  class CreateUserOutput < ActiveInteractor::Context::Input
      #    returns :user, User, 'The created User', required: true
      #  end
      #
      #  context = CreateUserOutput.new(user: User.new)
      #  context.fields
      #  #=> { user: #<User> }
      #
      #
      # @return [Hash]
      def fields
        attribute_set.attributes.each_with_object({}) do |attribute, result|
          result[attribute.name] = attribute.value
        end
      end
    end
  end
end
