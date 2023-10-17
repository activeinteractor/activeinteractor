# frozen_string_literal: true

module ActiveInteractor
  # The object returned by an {ActiveInteractor::Interactor::Base interactor}
  #
  # @!attribute [r] data
  #
  #  @example Given an {ActiveInteractor::Interactor::Base interactor} that creates an ActiveRecord User
  #   class CreateUser < ActiveInteractor::Interactor::Base
  #     argument :login, String, 'The login for the User', required: true
  #     argument :password, String, 'The password for the User', required: true
  #     argument :password_confirmation, String, 'The password confirmation for the user', required: true
  #
  #     returns :user, User, 'The created User', required: true
  #
  #     def interact
  #       context.user = User.new(context)
  #       fail!(context.user.errors) unless context.user.save
  #     end
  #   end
  #
  #   result = CreateUser.perform(login: 'johndoe', password: 'password', password_confirmation: 'password')
  #   result.data.user
  #
  #   #=> <# User @login='johndoe'>
  #
  #  @return [ActiveInteractor::Context::Result] the data returned by the
  #   {ActiveInteractor::Interactor::Base interactor}
  #
  # @!attribute [r] errors
  #  @return [ActiveModel::Errors] the errors returned by the
  #   {ActiveInteractor::Interactor::Base interactor}
  #  @see https://github.com/rails/rails/blob/main/activemodel/lib/active_model/errors.rb ActiveModel::Errors
  class Result
    include ActiveModelErrorMethods

    # @!method to_json
    # The {ActiveInteractor::Interactor::Base result} as a Hash
    #
    # @example When an {ActiveInteractor::Interactor::Base interactor} succeeds
    #  result = CreateUser.perform(login: 'johndoe', password: 'password', password_confirmation: 'password')
    #  result.to_hash
    #
    #  #=> { :success => true, :errors => {}, :data => { :login => 'johndoe' } }
    #
    # @example When an {ActiveInteractor::Interactor::Base interactor} fails
    #  result = CreateUser.perform(login: 'johndoe', password: 'password', password_confirmation: 'notpassword')
    #  result.to_hash
    #
    #  #=> {
    #  #=>   :success => false,
    #  #=>   :errors => { :password_confirmation => ["doesn't match Password"] },
    #  #=>   :data => { :login => 'johndoe' }
    #  #=> }
    #
    # @deprecated will be removed in version 2.0.0-alpha.3.0.0
    #  use {#to_hash} instead
    # @return [Hash {Symbol => Boolean, Hash}]
    delegate :to_json, to: :to_hash

    # @private
    STATUS = {
      success: 0,
      failed_at_input: 1,
      failed_at_runtime: 2,
      failed_at_output: 3
    }.freeze

    attr_reader :data

    class << self
      # @private
      def success(data: {})
        new(status: STATUS[:success], data: data)
      end

      # @private
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
    # @private
    def initialize(status:, data: {})
      @status = status
      @data = data
      @errors = ActiveModel::Errors.new(self)
    end

    # Whether or not the {ActiveInteractor::Interactor::Base result} is a failure
    #
    # @example When an {ActiveInteractor::Interactor::Base interactor} fails
    #  result = CreateUser.perform(login: 'johndoe', password: 'password', password_confirmation: 'notpassword')
    #  result.failure?
    #
    #  #=> true
    #
    # @example When an {ActiveInteractor::Interactor::Base interactor} succeeds
    #  result = CreateUser.perform(login: 'johndoe', password: 'password', password_confirmation: 'password')
    #  result.failure?
    #
    #  #=> false
    #
    # @return [Boolean]
    def failure?
      !success?
    end
    alias failed? failure?

    # @private
    def read_attribute_for_validation(attribute_name)
      data.send(attribute_name.to_sym)
    end

    # Whether or not the {ActiveInteractor::Interactor::Base result} is a success
    #
    # @return [Boolean]
    def success?
      @status == STATUS[:success]
    end
    alias successful? success?

    # The {ActiveInteractor::Interactor::Base result} as a Hash
    #
    # @example When an {ActiveInteractor::Interactor::Base interactor} succeeds
    #  result = CreateUser.perform(login: 'johndoe', password: 'password', password_confirmation: 'password')
    #  result.to_hash
    #
    #  #=> { :success => true, :errors => {}, :data => { :login => 'johndoe' } }
    #
    # @example When an {ActiveInteractor::Interactor::Base interactor} fails
    #  result = CreateUser.perform(login: 'johndoe', password: 'password', password_confirmation: 'notpassword')
    #  result.to_hash
    #
    #  #=> {
    #  #=>   :success => false,
    #  #=>   :errors => { :password_confirmation => ["doesn't match Password"] },
    #  #=>   :data => { :login => 'johndoe' }
    #  #=> }
    #
    # @return [Hash {Symbol => Boolean, Hash}]
    def to_hash
      {
        success: success?,
        errors: errors.to_hash,
        data: data.to_json
      }
    end
    alias to_h to_hash
  end
end
