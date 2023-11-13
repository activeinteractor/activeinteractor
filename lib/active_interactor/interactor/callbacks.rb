# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    # Interactor Callback Methods
    #
    # @see https://api.rubyonrails.org/classes/ActiveSupport/Callbacks.html ActiveSupport::Callbacks
    module Callbacks
      extend ActiveSupport::Concern

      module ClassMethods
        # Called after an Interactor fails
        def after_fail(...)
          set_callback(:fail, :after, ...)
        end

        # Called after an Interactor's input context is created
        def after_input_context_create(...)
          set_callback(:input_context_create, :after, ...)
        end

        # Called after an Interactor's input context is validated
        def after_input_context_validation(...)
          set_callback(:input_context_validation, :after, ...)
        end

        # Called after an Interactor's output context is created
        def after_output_context_create(...)
          set_callback(:output_context_create, :after, ...)
        end

        # Called after an Interactor's output context is validated
        def after_output_context_validation(...)
          set_callback(:output_context_validation, :after, ...)
        end

        # Called after an Interactor performs
        def after_perform(...)
          set_callback(:perform, :after, ...)
        end

        # Called after an Interactor rolls back
        def after_rollback(...)
          set_callback(:rollback, :after, ...)
        end

        # Called after an Interactor's runtime context is created
        def after_runtime_context_create(...)
          set_callback(:runtime_context_create, :after, ...)
        end

        # Called around an Interactor failure
        def around_fail(...)
          set_callback(:fail, :around, ...)
        end

        # Called around an Interactor's input context creation
        def around_input_context_create(...)
          set_callback(:input_context_create, :around, ...)
        end

        # Called around an Interactor's input context validation
        def around_input_context_validation(...)
          set_callback(:input_context_validation, :around, ...)
        end

        # Called around an Interactor's output context creation
        def around_output_context_create(...)
          set_callback(:output_context_create, :around, ...)
        end

        # Called around an Interactor's output context validation
        def around_output_context_validation(...)
          set_callback(:output_context_validation, :around, ...)
        end

        # Called around an Interactor's perform
        def around_perform(...)
          set_callback(:perform, :around, ...)
        end

        # Called around an Interactor's rollback
        def around_rollback(...)
          set_callback(:rollback, :around, ...)
        end

        # Called around an Interactor's runtime context creation
        def around_runtime_context_create(...)
          set_callback(:runtime_context_create, :around, ...)
        end

        # Called before an Interactor fails
        def before_fail(...)
          set_callback(:fail, :before, ...)
        end

        # Called before an Interactor's input context is created
        def before_input_context_create(...)
          set_callback(:input_context_create, :before, ...)
        end

        # Called before an Interactor's input context is validated
        def before_input_context_validation(...)
          set_callback(:input_context_validation, :before, ...)
        end

        # Called before an Interactor's output context is created
        def before_output_context_create(...)
          set_callback(:output_context_create, :before, ...)
        end

        # Called before an Interactor's output context is validated
        def before_output_context_validation(...)
          set_callback(:output_context_validation, :before, ...)
        end

        # Called before an Interactor performs
        def before_perform(...)
          set_callback(:perform, :before, ...)
        end

        # Called before an Interactor rolls back
        def before_rollback(...)
          set_callback(:rollback, :before, ...)
        end

        # Called before an Interactor's runtime context is created
        def before_runtime_context_create(...)
          set_callback(:runtime_context_create, :before, ...)
        end
      end

      s included do
        include ActiveSupport::Callbacks
        define_callbacks :fail, :input_context_create, :input_context_validation, :output_context_create,
                         :output_context_validation, :perform, :rollback, :runtime_context_create
      end
    end
  end
end
