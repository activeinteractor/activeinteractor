# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    module Callbacks
      extend ActiveSupport::Concern

      module ClassMethods
        def after_fail(...)
          set_callback(:fail, :after, ...)
        end

        def after_input_context_create(...)
          set_callback(:input_context_create, :after, ...)
        end

        def after_input_context_validation(...)
          set_callback(:input_context_validation, :after, ...)
        end

        def after_output_context_create(...)
          set_callback(:output_context_create, :after, ...)
        end

        def after_output_context_validation(...)
          set_callback(:output_context_validation, :after, ...)
        end

        def after_perform(...)
          set_callback(:perform, :after, ...)
        end

        def after_rollback(...)
          set_callback(:rollback, :after, ...)
        end

        def after_runtime_context_create(...)
          set_callback(:runtime_context_create, :after, ...)
        end

        def around_fail(...)
          set_callback(:fail, :around, ...)
        end

        def around_input_context_create(...)
          set_callback(:input_context_create, :around, ...)
        end

        def around_input_context_validation(...)
          set_callback(:input_context_validation, :around, ...)
        end

        def around_output_context_create(...)
          set_callback(:output_context_create, :around, ...)
        end

        def around_output_context_validation(...)
          set_callback(:output_context_validation, :around, ...)
        end

        def around_perform(...)
          set_callback(:perform, :around, ...)
        end

        def around_rollback(...)
          set_callback(:rollback, :around, ...)
        end

        def around_runtime_context_create(...)
          set_callback(:runtime_context_create, :around, ...)
        end

        def before_fail(...)
          set_callback(:fail, :before, ...)
        end

        def before_input_context_create(...)
          set_callback(:input_context_create, :before, ...)
        end

        def before_input_context_validation(...)
          set_callback(:input_context_validation, :before, ...)
        end

        def before_output_context_create(...)
          set_callback(:output_context_create, :before, ...)
        end

        def before_output_context_validation(...)
          set_callback(:output_context_validation, :before, ...)
        end

        def before_perform(...)
          set_callback(:perform, :before, ...)
        end

        def before_rollback(...)
          set_callback(:rollback, :before, ...)
        end

        def before_runtime_context_create(...)
          set_callback(:runtime_context_create, :before, ...)
        end
      end

      included do
        include ActiveSupport::Callbacks
      end
    end
  end
end
