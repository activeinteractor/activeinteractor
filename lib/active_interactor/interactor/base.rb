# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    # The Base Class inherited by all Interactors
    class Base
      include ActiveSupport::Callbacks
      extend Type::DeclerationMethods::ClassMethods
      include Type::DeclerationMethods

      define_callbacks :fail, :input_context_create, :input_context_validation, :output_context_create,
                       :output_context_validation, :perform, :rollback, :runtime_context_create

      class << self
        delegate :argument, :argument_names, :arguments, to: :input_context_class
        delegate :returns, :field_names, :fields, to: :output_context_class
        delegate(*ActiveModel::Validations::ClassMethods.instance_methods, to: :input_context_class, prefix: :input)
        delegate(*ActiveModel::Validations::HelperMethods.instance_methods, to: :input_context_class, prefix: :input)
        delegate(*ActiveModel::Validations::ClassMethods.instance_methods, to: :output_context_class, prefix: :output)
        delegate(*ActiveModel::Validations::HelperMethods.instance_methods, to: :output_context_class, prefix: :output)

        def accepts_arguments_matching(set_input_context_class)
          @input_context_class = set_input_context_class
        end
        alias input_context accepts_arguments_matching
        alias input_type accepts_arguments_matching

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

        def input_context_class
          @input_context_class ||= const_set(:InputContext, Class.new(Context::Input))
        end

        def output_context_class
          @output_context_class ||= const_set(:OutputContext, Class.new(Context::Output))
        end

        def perform!(input_context = {}, options = {})
          new(options).perform!(input_context)
        end

        def perform(input_context = {}, options = {})
          perform!(input_context, options)
        rescue Error => e
          e.result
        rescue StandardError => e
          Result.failure(errors: e.message)
        end

        def returns_data_matching(set_output_context_class)
          @output_context_class = set_output_context_class
        end
        alias output_context returns_data_matching
        alias output_type returns_data_matching

        def runtime_context_class
          @runtime_context_class ||= begin
            context_class = const_set(:RuntimeContext, Class.new(Context::Runtime))
            context_class.send(:attribute_set).merge(input_context_class.send(:attribute_set).attributes)
            context_class.send(:attribute_set).merge(output_context_class.send(:attribute_set).attributes)
            context_class
          end
        end

        def with_options(options)
          new(options)
        end

        protected

        def result_context
          @result_context ||= Context::Result.register_owner(self)
        end
      end

      def initialize(options = {})
        @options = Options.new(options.deep_dup)
      end

      def interact; end

      def perform!(input_context = {})
        @raw_input = input_context.deep_dup
        create_input_context
        validate_input_context!
        create_runtime_context
        return execute_perform_with_callbacks unless @options.skip_perform_callbacks

        execute_perform
      end

      def perform(input_context = {})
        perform!(input_context)
      rescue Error => e
        e.result
      rescue StandardError => e
        Result.failure(errors: e.message)
      end

      def rollback; end

      def with_options(options)
        @options = Options.new(options.deep_dup)
        self
      end

      protected

      attr_reader :context

      def create_input_context
        run_callbacks :input_context_create do
          @input_context = self.class.input_context_class.new(@raw_input.deep_dup)
        end
      end

      def create_output_context
        run_callbacks :output_context_create do
          @output_context = self.class.output_context_class.new(@context.attributes.deep_dup)
        end
      end

      def create_runtime_context
        run_callbacks :runtime_context_create do
          @context = self.class.runtime_context_class.new(@input_context.to_h.deep_dup)
        end
      end

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

      def output_to_result_context!
        self.class.send(:result_context).for_output_context(self.class, @output_context)
      end

      def perform_rollback
        return execute_rollback_with_callbacks unless @options.skip_rollback_callbacks

        rollback
      end

      def validate_input_context!
        return unless @options.validate && @options.validate_input_context

        run_callbacks :input_context_validation do
          @input_context.valid?
        end
        return if @input_context.errors.empty?

        raise Error,
              Result.failure(errors: @input_context.errors,
                             status: Result::STATUS[:failed_at_input])
      end

      def validate_output_context!
        return unless @options.validate && @options.validate_output_context

        run_callbacks :output_context_validation do
          @output_context.valid?
        end

        return if @output_context.errors.empty?

        raise Error,
              Result.failure(errors: @output_context.errors,
                             status: Result::STATUS[:failed_at_output])
      end

      def with_notification(action)
        ActiveSupport::Notifications.instrument("#{self.class.name}::#{action.to_s.classify}") do |payload|
          yield payload if block_given?
        end
      end
    end
  end
end
