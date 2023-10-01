# frozen_string_literal: true

module ActiveInteractor
  class Result
    extend ActiveModel::Naming

    STATUS = {
      success: 0,
      failed_at_input: 1,
      failed_at_runtime: 2,
      failed_at_output: 3
    }.freeze

    attr_reader :data, :errors

    class << self
      def success(data: {})
        new(status: STATUS[:success], data: data)
      end

      def failure(data: {}, errors: {}, status: STATUS[:failed_at_runtime])
        result = new(status: status, data: data)
        parse_errors(errors).each_pair do |attribute, messages|
          Array.wrap(messages).each { |message| result.errors.add(attribute, message) }
        end
        result
      end

      def human_attribute_name(attribute, _options = {})
        attribute.respond_to?(:to_s) ? attribute.to_s.humanize : attribute
      end

      def lookup_ancestors
        [self]
      end

      private

      def parse_errors(errors)
        case errors
        when String
          { generic: [errors] }
        when ActiveModel::Errors
          errors.as_json
        else
          errors
        end
      end
    end

    private_class_method :new

    def initialize(status:, data: {})
      @status = status
      @data = data
      @errors = ActiveModel::Errors.new(self)
    end

    def failure?
      !success?
    end
    alias failed? failure?

    def read_attribute_for_validation(attribute_name)
      data[attribute_name]
    end

    def success?
      @status == STATUS[:success]
    end
    alias successful? success?
  end
end
