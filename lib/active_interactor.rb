# frozen_string_literal: true

require 'active_model'
require 'active_support'
require 'active_support/core_ext'

require_relative 'active_interactor/errors'

module ActiveInteractor
  extend ActiveSupport::Autoload

  autoload :Base
  autoload :Context
  autoload :HasActiveModelErrors
  autoload :Result
end
