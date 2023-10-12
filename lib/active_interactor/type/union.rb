# frozen_string_literal: true

module ActiveInteractor
  module Type
    class Union < Base
      def initialize(*types) # rubocop:disable Lint/MissingSuper
        @valid_types = types
      end

      def valid?(value)
        return true if value.nil?

        @valid_types.any? do |type|
          value_is_a_valid_active_interactor_type?(type, value) || value.is_a?(type)
        end
      end

      private

      def value_is_a_valid_active_interactor_type?(type, value)
        return false unless type.is_a?(ActiveInteractor::Type::Base) || type.superclass == ActiveInteractor::Type::Base

        type.valid?(value)
      end
    end
  end
end
