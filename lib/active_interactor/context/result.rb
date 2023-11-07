# frozen_string_literal: true

module ActiveInteractor
  module Context
    # The base class for result context objects returned in {ActiveInteractor::Result#data}
    #
    # @api private
    class Result
      # @!method []
      #  read an attribute by key
      #  @return [Object] the attribute value
      #
      # @!method as_json
      #  @return [Hash] the context as a json hash
      #
      # @!method to_h
      #  @return [Hash] the context as a hash
      #
      # @!method to_hash
      #  @return [Hash] the context as a hash
      #
      # @!method to_json
      #  @return [String] the context as a json string
      delegate :[], :as_json, :to_json, to: :to_hash

      # register an owner for the result context
      #   so that it can inject itself onto the owner
      #
      # @visibility private
      #
      # @param owner [ActiveInteractor::Interactor::Base] the owner class
      # @return [void]
      def self.register_owner(owner)
        owner.const_set(:ResultContext, Class.new(self))
      end

      # extract the result context from the output context
      #
      # @visibility private
      #
      # @param owner [ActiveInteractor::Interactor::Base] the instance of owner class
      # @param context [ActiveInteractor::Context::Output] the output context
      # @return [ActiveInteractor::Context::Result] an instace of result context
      def self.for_output_context(owner, context)
        context.fields.each_key { |field| owner::ResultContext.send(:attr_reader, field) }
        owner::ResultContext.new(context.fields)
      end

      # Create a new instance of {ActiveInteractor::Context::Result} and assign attributes
      # @param attributes [Hash] attribute values
      # @return [ActiveInteractor::Context::Result]
      def initialize(attributes = {})
        @attributes = {}
        attributes.each_pair do |key, value|
          instance_variable_set(:"@#{key}", value)
          @attributes[key] = value
        end
      end

      # The context as a hash
      #
      # @return [Hash]
      def to_hash
        @attributes.with_indifferent_access
      end
      alias to_h to_hash
    end
  end
end
