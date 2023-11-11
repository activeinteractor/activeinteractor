# frozen_string_literal: true

module ActiveInteractor
  # The Interactor namespace
  module Interactor
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :Callbacks
    autoload :ContextMethods
    autoload :InteractionMethods
    autoload :OptionMethods
    autoload :Options
  end
end
