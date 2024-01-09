# frozen_string_literal: true

module ActiveInteractor
  module Context
    # The base class for all output context objects
    class Output < Base
      delegate :as_json, to: :fields
      delegate :to_h, to: :fields
      delegate :to_hash, to: :fields
      delegate :to_json, to: :fields

      def self.returns(*attribute_args)
        attribute_set.add(*attribute_args)
      end

      def self.field_names
        attribute_set.attribute_names
      end

      def self.fields
        attribute_set.attributes
      end

      def fields
        attribute_set.attributes.each_with_object({}) do |attribute, result|
          result[attribute.name] = attribute.value
        end
      end
    end
  end
end
