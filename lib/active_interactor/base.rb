# frozen_string_literal: true

module ActiveInteractor
  class Base
    class << self
      def argument(name, type, description = nil, **options)
        attributes[:arguments][name.to_sym] = { name: name, type: type, description: description }.merge(options)
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

      def returns(name, type, description = nil, **options)
        attributes[:fields][name.to_sym] = { name: name, type: type, description: description }.merge(options)
      end

      private

      def attributes
        @attributes ||= { arguments: {}, fields: {} }
      end
    end

    def initialize(input = {})
      @input = input.freeze
      @context = parse_input!
    end

    def perform!
      with_notification(:perform) do |payload|
        interact
        payload[:result] = Result.success(data: parse_output!)
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

    def parse_input!
      errors = {}
      context = self.class.send(:attributes)[:arguments].each_with_object({}) do |(name, options), hash|
        errors = validate_attribute_value(@input[name], name, options, errors)
        hash[name] = @input[name] || options[:default]
      end

      raise Error, Result.failure(errors: errors, status: Result::STATUS[:failed_on_input]) unless errors.empty?

      context
    end

    def parse_output!
      errors = {}
      context = self.class.send(:attributes)[:fields].each_with_object({}) do |(name, options), hash|
        errors = validate_attribute_value(self.context[name], name, options, errors)
        hash[name] = self.context[name] || options[:default]
      end

      raise Error, Result.failure(errors: errors, status: Result::STATUS[:failed_on_output]) unless errors.empty?

      context
    end

    def validate_attribute_value(value, attribute_name, attribute_options, errors)
      return errors unless value.blank? && attribute_options[:required] && !attribute_options[:default]

      errors[attribute_name] ||= []
      errors[attribute_name] << :blank
      errors
    end

    def with_notification(action)
      ActiveSupport::Notifications.instrument("#{self.class.name}::#{action.to_s.classify}") do |payload|
        yield payload if block_given?
      end
    end
  end
end
