# frozen_string_literal: true

require 'active_model'
require 'active_support'

require_relative 'active_interactor/errors'

module ActiveInteractor
  extend ActiveSupport::Autoload

  autoload :Base
  autoload :Result
end
