# frozen_string_literal: true

module ActiveInteractor
  module Context
    # The base class for all output context objects
    class Output < Base
      # Return the context as a JSON hash
      #
      # @return [Hash{String => Object}] the context as a JSON hash
      delegate :as_json, to: :fields
      # Return the context as a hash
      #
      # @return [Hash{Symbol => Object}] the context as a hash
      delegate :to_h, to: :fields
      # Return the context as a hash
      #
      # @return [Hash{Symbol => Object}] the context as a hash
      delegate :to_hash, to: :fields
      # Return the context as a JSON string
      #
      # @return [String] the context as a JSON string
      delegate :to_json, to: :fields

      # Add an field {ActiveInteractor::Context::Attribute attribute} to the context
      #
      # @param attribute_args [Array<Object>] the arguments to pass to the
      #  {ActiveInteractor::Context::Attribute attribute}. see {ActiveInteractor::Context::Attribute#initialize} for a
      #  list of arguments
      #
      # @return [void]
      def self.returns(*attribute_args)
        attribute_set.add(*attribute_args)
      end

      # Return the field names
      #
      # @return [Array<Symbol>] the field names
      def self.field_names
        attribute_set.attribute_names
      end

      # Return the fields
      #
      # @return [Array<ActiveInteractor::Context::Attribute>] the fields
      def self.fields
        attribute_set.attributes
      end

      # Return the fields as a hash
      #
      # @example
      #  class CreateUserOutput < ActiveInteractor::Context::Output
      #    returns :user, User, 'The created User', required: true
      #    returns :profile, UserProfile, 'The created User Profile', required: true
      #  end
      #
      #  context = CreateUserOutput.new(user: User.new, profile: UserProfile.new)
      #  context.fields
      #  #=> { user: <#User>, profile: <#UserProfile> }
      #
      # @return [Hash{Symbol => Object}] the fields as a hash
      def fields
        attribute_set.attributes.each_with_object({}) do |attribute, result|
          result[attribute.name] = attribute.value
        end
      end
    end
  end
end
