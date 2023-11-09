# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    module ContextMethods
      extend ActiveSupport::Concern
      module ClassMethods
        delegate :argument, :argument_names, :arguments, to: :input_context_class
        delegate :returns, :field_names, :fields, to: :output_context_class
        delegate(*ActiveModel::Validations::ClassMethods.instance_methods, to: :input_context_class, prefix: :input)
        delegate(*ActiveModel::Validations::HelperMethods.instance_methods, to: :input_context_class, prefix: :input)
        delegate(*ActiveModel::Validations::ClassMethods.instance_methods, to: :output_context_class, prefix: :output)
        delegate(*ActiveModel::Validations::HelperMethods.instance_methods, to: :output_context_class, prefix: :output)

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
        protected

        attr_reader :context
      end

      protected # rubocop:disable Lint/UselessAccessModifier

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

      def output_to_result_context!
        self.class.send(:result_context).for_output_context(self.class, @output_context)
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
    end
  end
end
