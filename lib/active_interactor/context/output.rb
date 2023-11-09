# frozen_string_literal: true

module ActiveInteractor
  module Context
    class Output < Base
      delegate :as_json, :to_h, :to_hash, :to_json, to: :fields

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
