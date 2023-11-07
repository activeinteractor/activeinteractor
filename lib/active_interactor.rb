# frozen_string_literal: true

require 'active_model'
require 'active_support'
require 'active_support/core_ext'

require_relative 'active_interactor/errors'

# ## License
#
# Copyright (c) 2023 Aaron Allen
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# {https://activeinteractor.org ActiveInteractor} is An implementation of the Command
# Pattern for Ruby with ActiveModel::Validations inspired by the interactor gem.
# It has features like rich support for attributes, callbacks, and validations, and
# thread safe performance methods.
#
# {https://activeinteractor.org/getting-started Getting Started}
#
# {file:CHANGELOG.md Changelog}
#
# {file:HUMANS.md Acknowledgements}
#
# {file:SECURITY.md Security Policy}
#
# @author {hello@aaronmallen.me Aaron Allen}
#
# @example Create an interactor
#   class CreateUser < ActiveInteractor::Interactor::Base
#     argument :login, String, 'The User login', required: true
#     argument :password, String, 'The User password', required: true
#     argument :password_confirmation, String, 'The User password confirmation', required: true
#     argument :first_name, String, 'The User first name'
#     argument :last_name, String, 'The User last name'
#
#     returns :user, User, 'The created User', required: true
#
#     input_validates :password, confirmation: true
#
#     def interact
#       create_user!
#       create_user_profile!
#     end
#
#     def rollback
#       context.user.&destroy
#       context.user_profile&.destroy
#     end
#
#     private
#
#     def create_user!
#       context.user = User.new(login: context.login, password: context.password)
#       fail!(context.user.errors) unless context.user.save
#       puts "I created a user!"
#     end
#
#     def create_user_profile!
#       context.user_profile = UserProfile.new(
#         user: context.user,
#         first_name: context.first_name,
#         last_name: context.last_name
#       )
#       fail!(context.user_profile.errors) unless context.user_profile.save
#       puts "I created a user profile!"
#     end
#   end
#
#   result = CreateUser.perform(login: 'hello@aaronmallen', password: 'password', password_confirmation: 'password')
#   "I created a user!"
#   "I created a user profile!"
#   result.success?
#   #=> true
#   result.data.user
#   #=> <#User @login='hello@aaronmallen'>
#
#   result = CreateUser.perform(login: 'hello@aaronmallen', password: 'password', password_confirmation: 'notpassword')
#   result.success?
#   #=> false
#   result.errors.full_messages
#   #=> ["Password confirmation doesn't match Password"]
#

module ActiveInteractor
  extend ActiveSupport::Autoload

  autoload :ActiveModelErrorMethods
  autoload :Context
  autoload :Interactor
  autoload :Result
  autoload :Type
end
