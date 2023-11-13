# frozen_string_literal: true

module ActiveInteractor
  module Context
    # The base class for all result context objects
    #
    # @api private
    # @visibility private
    class Result
      # Read an attribute value
      #
      # @param attribute_name [Symbol, String] the name of the attribute to read
      #
      # @return [Object] the value of the attribute
      delegate :[], to: :to_hash
      # Return the context as a JSON hash
      #
      # @return [Hash{String => Object}] the context as a JSON hash
      delegate :as_json, to: :to_hash
      # Return the context as a JSON string
      #
      # @return [String] the context as a JSON string
      delegate :to_json, to: :to_hash

      # Inject the context on an {ActiveInteractor::Interactor::Base interactor}
      #
      # @param owner [ActiveInteractor::Interactor::Base] the interactor to inject the context on
      #
      # @return [void]
      # @param [Object] owner
      def self.register_owner(owner)
        owner.const_set(:ResultContext, Class.new(self))
      end

      # Assign context attributes to the Result context
      #
      # @param owner [ActiveInteractor::Interactor::Base] the interactor to assign the context attributes to
      # @param context [ActiveInteractor::Context::Base] the context to assign the attributes from
      #
      # @return [ActiveInteractor::Context::Result] the result context
      def self.for_output_context(owner, context)
        context.fields.each_key { |field| owner::ResultContext.send(:attr_reader, field) }
        owner::ResultContext.new(context.fields.deep_dup)
      end

      # Create a new instance of {ActiveInteractor::Context::Result} and assign the attributes
      #
      # @param attributes [Hash{Symbol => Object}] the attributes to assign to the context
      #
      # @return [ActiveInteractor::Context::Result] the result context
      def initialize(attributes = {})
        @attributes = {}
        attributes.each_pair do |key, value|
          instance_variable_set(:"@#{key}", value)
          @attributes[key] = value
        end
      end

      # Return the context as a hash
      #
      # @return [Hash{Symbol => Object}] the context as a hash
      def to_hash
        @attributes.with_indifferent_access
      end
      alias to_h to_hash
    end
  end
end
