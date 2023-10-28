# frozen_string_literal: true

require 'bundler/setup'
require 'active_interactor'

class User
  attr_accessor :login, :password

  def destroy!
    puts 'I get destroyed'
    @destroyed = true
    puts destroyed?
  end

  def destroyed?
    @destroyed || false
  end
end

class CreateUser < ActiveInteractor::Base
  argument :login, String, 'The login for the user', required: true
  argument :password, String, 'The password for the user', required: true
  argument :password_confirmation, String, 'The password confirmation for the user'

  returns :user, User, 'The created user', required: true

  def interact
    context.user = User.new
    fail!(password: %i[invalid]) unless context.password == context.password_confirmation

    set_user_attributes
  end

  def rollback
    context.user&.destroy!
  end

  private

  def set_user_attributes
    context.user.login = context.login
    context.user.password = context.password
  end
end

success_result = CreateUser.perform(login: 'testuser', password: 'password', password_confirmation: 'password')
puts success_result.success?
puts success_result.to_json
puts success_result.data[:user]

failure_result = CreateUser.perform(login: 'testuser', password: 'password', password_confirmation: 'notpassword')
puts failure_result.success?
puts failure_result.to_json
