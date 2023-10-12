# frozen_string_literal: true

module ActiveInteractor
  module Type
    class List < Base
      def initialize(type) # rubocop:disable Lint/MissingSuper
        @type = type
      end

      def valid?(value)
        return false unless value.is_a?(Array)

        value.all? do |element|
          element.nil? || element.is_a?(@type) || (@type.is_a?(ActiveInteractor::Type::Base) && @type.valid?(element))
        end
      end

      private

      def value_is_a_valid_active_interactor_type?(_type, value)
        unless @type.is_a?(ActiveInteractor::Type::Base) || @type.superclass == ActiveInteractor::Type::Base
          return false
        end

        @type.valid?(value)
      end
    end
  end
end
