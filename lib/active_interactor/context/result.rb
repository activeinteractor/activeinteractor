# frozen_string_literal: true

module ActiveInteractor
  module Context
    class Result
      delegate :[], :as_json, :to_json, to: :to_hash

      def self.register_owner(owner)
        owner.const_set(:ResultContext, Class.new(self))
      end

      def self.for_output_context(owner, context)
        context.fields.each_key { |field| owner::ResultContext.send(:attr_reader, field) }
        owner::ResultContext.new(context.fields)
      end

      def initialize(attributes = {})
        @attributes = {}
        attributes.each_pair do |key, value|
          instance_variable_set(:"@#{key}", value)
          @attributes[key] = value
        end
      end

      def to_hash
        @attributes.with_indifferent_access
      end
      alias to_h to_hash
    end
  end
end
