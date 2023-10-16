# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    module ContextMethods
      extend ActiveSupport::Concern

      module ClassMethods
        delegate :argument, :argument_names, :arguments, to: :input_context_class
        delegate :returns, :field_names, :fields, to: :output_context_class

        def input_context_class
          @input_context_class ||= const_set(:InputContext, Class.new(Context::Input))
        end

        def accepts_arguments_matching(set_input_context_class)
          @input_context_class = set_input_context_class
        end
        alias input_context accepts_arguments_matching
        alias input_type accepts_arguments_matching

        def output_context_class
          @output_context_class ||= const_set(:OutputContext, Class.new(Context::Output))
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

        protected

        def result_context
          @result_context ||= Context::Result.register_owner(self)
        end
      end

      included do
        extend ClassMethods

        protected

        attr_reader :context
      end

      protected # rubocop:disable Lint/UselessAccessModifier

      def generate_and_validate_output_context!
        @output = self.class.output_context_class.new(context.attributes)
        @output.validate!
        return if @output.errors.empty?

        raise Error, Result.failure(errors: @output.errors, status: Result::STATUS[:failed_at_output])
      end

      def output_to_result_context!
        self.class.send(:result_context).for_output_context(self.class, @output)
      end

      def validate_input_and_generate_runtime_context!
        @input = self.class.input_context_class.new(@raw_input)
        @input.validate!
        return (@context = self.class.runtime_context_class.new(@raw_input)) if @input.errors.empty?

        raise Error, Result.failure(errors: @input.errors, status: Result::STATUS[:failed_at_input])
      end
    end
  end
end
