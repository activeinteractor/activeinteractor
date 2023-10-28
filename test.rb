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

class CreateUser < ActiveInteractor::Interactor::Base
  argument :login, String, 'The login for the user', required: true
  argument :password, String, 'The password for the user', required: true
  argument :password_confirmation, String, 'The password confirmation for the user'

  returns :user, User, 'The created user', required: true

  input_validates :login, format: { with: URI::MailTo::EMAIL_REGEXP }

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

class Ping < ActiveInteractor::Interactor::Base
  argument :message, String, 'The message to ping', required: true

  returns :response, String, 'The passed message', required: true

  output_validates :response, inclusion: { in: ['Hello World'] }

  def interact
    context.response = context.message
  end
end

puts 'Describe Create User'
puts '=' * 80
create_user_success_result = CreateUser.perform(login: 'test@example.com', password: 'password',
                                                password_confirmation: 'password')
puts "it is successful: #{create_user_success_result.success?}"
puts "it has the correct data: #{create_user_success_result.to_json}"
puts "it responds to hash methods: #{create_user_success_result.data[:user].present?}"

create_user_failure_result = CreateUser.perform(login: 'testuser', password: 'password',
                                                password_confirmation: 'notpassword')
puts "it is a failure: #{create_user_failure_result.failure?}"
puts "it has the correct errors: #{create_user_failure_result.to_json}"

puts 'Describe Ping'
puts '=' * 80
ping_success_result = Ping.perform(message: 'Hello World')
puts "it is successful: #{ping_success_result.success?}"
puts "it has the correct data: #{ping_success_result.to_json}"

ping_failure_result = Ping.perform(message: 'Foo')
puts "it is a failure: #{ping_failure_result.failure?}"
puts "it has the correct errors: #{ping_failure_result.to_json}"
