# frozen_string_literal: true

module ActiveInteractor
  module Context
    class Input < Base
      delegate :as_json, :to_h, :to_hash, :to_json, to: :arguments

      def self.argument(*attribute_args)
        attribute_set.add(*attribute_args)
      end

      def self.argument_names
        attribute_set.attribute_names
      end

      def self.arguments
        attribute_set.attributes
      end

      def arguments
        attribute_set.attributes.each_with_object({}) do |attribute, result|
          result[attribute.name] = attribute.value
        end
      end
    end
  end
end
