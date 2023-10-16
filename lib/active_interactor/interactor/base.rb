# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    class Base
      include ContextMethods
      include InteractionMethods

      def initialize(input = {})
        @raw_input = input.dup
        validate_input_and_generate_runtime_context!
      end

      def perform!
        with_notification(:perform) do |payload|
          interact
          generate_and_validate_output_context!
          payload[:result] = Result.success(data: output_to_result_context!)
        end
      end

      protected

      def fail!(errors = {})
        result = nil
        with_notification(:rollback) do |payload|
          rollback
          result = Result.failure(data: parse_output!, errors: errors)
          payload[:result] = result
        end

        raise Error, result
      end

      def with_notification(action)
        ActiveSupport::Notifications.instrument("#{self.class.name}::#{action.to_s.classify}") do |payload|
          yield payload if block_given?
        end
      end
    end
  end
end
