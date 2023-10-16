# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    module InteractionMethods
      extend ActiveSupport::Concern

      module ClassMethods
        def perform!(input_context = {})
          new(input_context).perform!
        end

        def perform(input_context = {})
          perform!(input_context)
        rescue Error => e
          e.result
        rescue StandardError => e
          Result.failure(errors: e.message)
        end
      end

      included do
        extend ClassMethods
      end

      def perform
        perform!
      rescue Error => e
        e.result
      rescue StandardError => e
        Result.failure(errors: e.message)
      end

      def interact; end
      def rollback; end
    end
  end
end
