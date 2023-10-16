# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :ContextMethods
    autoload :InteractionMethods
  end
end
