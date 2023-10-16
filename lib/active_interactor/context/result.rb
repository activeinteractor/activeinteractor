# frozen_string_literal: true

module ActiveInteractor
  module Context
    class Result
      def self.register_owner(owner)
        owner.const_set(:ResultContext, Class.new(self))
      end

      def self.for_output_context(owner, context)
        context.fields.each_key { |field| owner::ResultContext.send(:attr_reader, field) }
        owner::ResultContext.new(context.fields)
      end

      def initialize(attributes = {})
        attributes.each_pair { |key, value| instance_variable_set(:"@#{key}", value) }
      end
    end
  end
end
