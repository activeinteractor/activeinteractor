# frozen_string_literal: true

module ActiveInteractor
  class Result
    include HasActiveModelErrors

    delegate :to_json, to: :to_hash

    STATUS = {
      success: 0,
      failed_at_input: 1,
      failed_at_runtime: 2,
      failed_at_output: 3
    }.freeze

    attr_reader :data

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
      data.send(attribute_name.to_sym)
    end

    def success?
      @status == STATUS[:success]
    end
    alias successful? success?

    def to_hash
      {
        success: success?,
        errors: errors.to_hash,
        data: data.to_hash
      }
    end
    alias to_h to_hash
  end
end
