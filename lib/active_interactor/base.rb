# frozen_string_literal: true

module ActiveInteractor
  class Base
    include Type::HasTypes

    class << self
      delegate :argument, :argument_names, :arguments, to: :input_context_class
      delegate :returns, :field_names, :fields, to: :output_context_class

      def input_context_class
        @input_context_class ||= const_set(:InputContext, Class.new(Context::Input))
      end

      def accepts_arguments_matching(set_input_context_class)
        @input_context_class = set_input_context_class
      end
      alias input_context accepts_arguments_matching

      def output_context_class
        @output_context_class ||= const_set(:OutputContext, Class.new(Context::Output))
      end

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

      def returns_data_matching(set_output_context_class)
        @output_context_class = set_output_context_class
      end
      alias output_context returns_data_matching

      def runtime_context_class
        @runtime_context_class ||= begin
          context_class = const_set(:RuntimeContext, Class.new(Context::Runtime))
          context_class.send(:attribute_set).merge(input_context_class.send(:attribute_set).attributes)
          context_class.send(:attribute_set).merge(output_context_class.send(:attribute_set).attributes)
          context_class
        end
      end
    end

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

    attr_accessor :context

    def fail!(errors = {})
      result = nil
      with_notification(:rollback) do |payload|
        rollback
        result = Result.failure(data: parse_output!, errors: errors)
        payload[:result] = result
      end

      raise Error, result
    end

    def generate_and_validate_output_context!
      @output = self.class.output_context_class.new(context.attributes)
      @output.validate!
      return if @output.errors.empty?

      raise Error, Result.failure(errors: @output.errors, status: Result::STATUS[:failed_at_output])
    end

    def output_to_result_context!
      Context::Result.for_output_context(self.class, @output)
    end

    def validate_input_and_generate_runtime_context!
      @input = self.class.input_context_class.new(@raw_input)
      @input.validate!
      return (@context = self.class.runtime_context_class.new(@raw_input)) if @input.errors.empty?

      raise Error, Result.failure(errors: @input.errors, status: Result::STATUS[:failed_at_input])
    end

    def with_notification(action)
      ActiveSupport::Notifications.instrument("#{self.class.name}::#{action.to_s.classify}") do |payload|
        yield payload if block_given?
      end
    end
  end
end
