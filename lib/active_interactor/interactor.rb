# frozen_string_literal: true

module ActiveInteractor
  # The Interactor namespace
  module Interactor
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :ContextMethods
    autoload :InteractionMethods
  end
end
