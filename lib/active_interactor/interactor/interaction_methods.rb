# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    module InteractionMethods
      extend ActiveSupport::Concern

      module ClassMethods
        # Perform the {#interaction} and return a {ActiveInteractor::Result result}
        #
        # @raise [ActiveInteractor::Error] If the {#interaction} fails
        # @return [ActiveInteractor::Result] The result
        def perform!(input_context = {})
          new(input_context).perform!
        end

        # Perform the {#interaction} and return a {ActiveInteractor::Result result}
        #
        # @return [ActiveInteractor::Result] The result
        def perform(input_context = {})
          perform!(input_context)
        rescue Error => e
          e.result
        rescue StandardError => e
          Result.failure(errors: e.message)
        end
      end

      # Perform the {#interaction} and return a {ActiveInteractor::Result result}
      #
      # @return [ActiveInteractor::Result] The result
      def perform
        perform!
      rescue Error => e
        e.result
      rescue StandardError => e
        Result.failure(errors: e.message)
      end

      # The method to define the interaction of the {ActiveInteractor::Interactor::Base interactor}
      #
      # @example
      #  class CreateUser < ActiveInteractor::Interactor::Base
      #    argument :login, String, 'The User login', required: true
      #    argument :password, String, 'The User password', required: true
      #    argument :password_confirmation, String, 'The User password confirmation', required: true
      #
      #    returns :user, User, 'The created User', required: true
      #
      #    def interact
      #      context.user = User.new(login: context.login, password: context.password)
      #      fail!(context.user.errors) unless context.user.save
      #    end
      #  end
      def interact; end

      # The method to define the cleanup when the {ActiveInteractor::Interactor::Base interactor} fails
      #
      # @example
      #  class CreateUser < ActiveInteractor::Interactor::Base
      #    argument :login, String, 'The User login', required: true
      #    argument :password, String, 'The User password', required: true
      #    argument :password_confirmation, String, 'The User password confirmation', required: true
      #
      #    returns :user, User, 'The created User', required: true
      #
      #    def interact
      #      create_user!
      #      create_user_profile!
      #    end
      #
      #    def rollback
      #      context.user&.destroy
      #      context.user_profile&.destroy
      #    end
      #  end
      def rollback; end
    end
  end
end
