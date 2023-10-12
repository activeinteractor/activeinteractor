# frozen_string_literal: true

module ActiveInteractor
  module Context
    class Input < Base
      def self.argument(*attribute_args)
        attribute_set.add(*attribute_args)
      end

      def self.argument_names
        attribute_set.attribute_names
      end

      def self.arguments
        attribute_set.attributes
      end
    end
  end
end
