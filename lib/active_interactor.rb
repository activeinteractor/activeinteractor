# frozen_string_literal: true

require 'active_model'
require 'active_support'
require 'active_support/core_ext'

require_relative 'active_interactor/errors'

module ActiveInteractor
  extend ActiveSupport::Autoload

  autoload :ActiveModelErrorMethods
  autoload :Base
  autoload :Context
  autoload :Interactor
  autoload :Result
  autoload :Type
end
