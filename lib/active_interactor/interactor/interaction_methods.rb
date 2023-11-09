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

      def perform!
        return execute_perform_with_callbacks unless @options.skip_perform_callbacks

        execute_perform
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

      protected

      def execute_perform
        with_notification(:perform) do |payload|
          interact
          create_output_context
          validate_output_context!
          payload[:result] = Result.success(data: output_to_result_context!)
        end
      end

      def execute_perform_with_callbacks
        run_callbacks :perform do
          execute_perform
        end
      end

      def execute_rollback_with_callbacks
        run_callbacks :rollback do
          rollback
        end
      end

      def fail!(errors = {})
        run_callbacks :fail do
          result = nil
          with_notification(:rollback) do |payload|
            perform_rollback unless @options.skip_rollback
            result = Result.failure(data: @output, errors: errors)
            payload[:result] = result
          end
        end

        raise Error, result
      end

      def perform_rollback
        return execute_rollback_with_callbacks unless @options.skip_rollback_callbacks

        rollback
      end

      def with_notification(action)
        ActiveSupport::Notifications.instrument("#{self.class.name}::#{action.to_s.classify}") do |payload|
          yield payload if block_given?
        end
      end
    end
  end
end
