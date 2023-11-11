# frozen_string_literal: true

module ActiveInteractor
  module Context
    # The base class for all input context objects
    class Input < Base
      # Return the context as a JSON hash
      #
      # @return [Hash{String => Object}] the context as a JSON hash
      delegate :as_json, to: :arguments
      # Return the context as a hash
      #
      # @return [Hash{Symbol => Object}] the context as a hash
      delegate :to_h, to: :arguments
      # Return the context as a hash
      #
      # @return [Hash{Symbol => Object}] the context as a hash
      delegate :to_hash, to: :arguments
      # Return the context as a JSON string
      #
      # @return [String] the context as a JSON string
      delegate :to_json, to: :arguments

      # Add an argument {ActiveInteractor::Context::Attribute attribute} to the context
      #
      # @param attribute_args [Array<Object>] the arguments to pass to the
      #  {ActiveInteractor::Context::Attribute attribute}. see {ActiveInteractor::Context::Attribute#initialize} for a
      #  list of arguments
      #
      # @return [void]
      def self.argument(*attribute_args)
        attribute_set.add(*attribute_args)
      end

      # Return the argument names
      #
      # @return [Array<Symbol>] the argument names
      def self.argument_names
        attribute_set.attribute_names
      end

      # Return the arguments
      #
      # @return [Array<ActiveInteractor::Context::Attribute>] the arguments
      def self.arguments
        attribute_set.attributes
      end

      # Return the arguments as a hash
      #
      # @example
      #  class CreateUserInput < ActiveInteractor::Context::Input
      #    argument :email, String, "The user's email address", required: true
      #    argument :password, String, "The user's password", required: true
      #  end
      #
      #  context = CreateUserInput.new(email: 'hello@aaronmallen.me', password: 'password')
      #  context.arguments
      #  #=> { email: 'hello@aaronmallen.me', password: 'password' }
      #
      # @return [Hash{Symbol => Object}] the arguments as a hash
      def arguments
        attribute_set.attributes.each_with_object({}) do |attribute, result|
          result[attribute.name] = attribute.value
        end
      end
    end
  end
end
