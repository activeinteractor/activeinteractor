# frozen_string_literal: true

module ActiveInteractor
  # An interactor result
  #
  # @!attribute [r] data
  #  @return [ActiveInteractor::Context::Result, Object, nil] the data returned by the interactor
  #
  #  @example
  #   result = CreateUser.perform(email: 'hello@aaronmallen.me', password: 'password')
  #   result.data.user
  #   #=> <#User @email="hello@aaronmallen.me">
  #
  # @!attribute [r] errors
  #  @return [ActiveModel::Errors] the errors from the interactor
  #
  #  @example
  #   result = CreateUser.perform(
  #     email: 'hello@aaronmallen',
  #     password: 'password',
  #     password_confirmation: 'not password'
  #   )
  #   result.errors.full_messages
  #   #=> ["Password confirmation doesn't match Password"]
  class Result
    extend ActiveModel::Naming

    attr_reader :data, :errors

    # Return a result as a JSON string
    delegate :to_json, to: :to_hash

    # Status codes for interactor results
    #
    # @visibility private
    STATUS = {
      success: 0,
      failed_at_input: 1,
      failed_at_runtime: 2,
      failed_at_output: 3
    }.freeze

    class << self
      # Return a failed result
      #
      # @visibility private
      #
      # @param data [ActiveInteractor::Context::Result, Object, nil] the data returned by the interactor
      # @param errors [ActiveModel::Errors, Hash, String] the errors from the interactor
      # @param status [Integer] the status code for the result
      #
      # @return [ActiveInteractor::Result] the failed result
      def failure(data: {}, errors: {}, status: STATUS[:failed_at_runtime])
        result = new(status: status, data: data)
        parse_errors(errors).each_pair do |attribute, messages|
          Array.wrap(messages).each { |message| result.errors.add(attribute, message) }
        end
        result
      end

      # Needed for ActiveModel::Errors
      #
      # @visibility private
      def human_attribute_name(attribute, _options = {})
        attribute.respond_to?(:to_s) ? attribute.to_s.humanize : attribute
      end

      # Needed for ActiveModel::Errors
      #
      # @visibility private
      def lookup_ancestors
        [self]
      end

      # Return a successful result
      #
      # @visibility private
      #
      # @param data [ActiveInteractor::Context::Result, Object, nil] the data returned by the interactor
      #
      # @return [ActiveInteractor::Result] the successful result
      def success(data: {})
        new(status: STATUS[:success], data: data)
      end

      private

      def parse_errors(errors)
        case errors
        when String
          { generic: [errors] }
        when ActiveModel::Errors
          errors.to_hash
        else
          errors
        end
      end
    end

    private_class_method :new

    # Create a new instance of {ActiveInteractor::Result}
    #
    # @visibility private
    #
    # @param status [Integer] the status code for the result
    # @param data [ActiveInteractor::Context::Result, Object, nil] the data returned by the interactor
    #
    # @return [ActiveInteractor::Result] the result
    def initialize(status:, data: {})
      @status = status
      @data = data
      @errors = ActiveModel::Errors.new(self)
    end

    # Whether or not the result is a failure
    #
    # @example When the result is a success
    #  result = CreateUser.perform(
    #    email: 'hello@aaronmallen',
    #    password: 'password',
    #    password_confirmation: 'password'
    #  )
    #  result.failure?
    #  #=> false
    #
    # @example When the result is a failure
    #  result = CreateUser.perform(
    #    email: 'hello@aaronmallen',
    #    password: 'password',
    #    password_confirmation: 'not password'
    #  )
    #  result.failure?
    #  #=> true
    #
    # @return [Boolean] whether or not the result is a failure
    def failure?
      !success?
    end
    alias failed? failure?

    # Needed for ActiveModel::Errors
    #
    # @visibility private
    def read_attribute_for_validation(attribute_name)
      data&.send(attribute_name.to_sym)
    end

    # Whether or not the result is a success
    #
    # @example When the result is a success
    #  result = CreateUser.perform(
    #    email: 'hello@aaronmallen',
    #    password: 'password',
    #    password_confirmation: 'password'
    #  )
    #  result.success?
    #  #=> true
    #
    # @example When the result is a failure
    #  result = CreateUser.perform(
    #    email: 'hello@aaronmallen',
    #    password: 'password',
    #    password_confirmation: 'not password'
    #  )
    #  result.success?
    #  #=> false
    #
    # @return [Boolean] whether or not the result is a failure
    def success?
      @status == STATUS[:success]
    end
    alias successful? success?

    # Return the result as a hash
    #
    # @example
    #  result = CreateUser.perform(email: 'hello@aaronmallen', password: 'password')
    #  result.to_hash
    #  #=> { success: true, status: 0, errors: {}, data: { user: <#User> } }
    def to_hash
      {
        success: success?,
        status: @status,
        errors: errors.to_hash,
        data: data.to_json
      }
    end
    alias to_h to_hash
  end
end
