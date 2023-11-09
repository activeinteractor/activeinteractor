# frozen_string_literal: true

module ActiveInteractor
  # The Context namespace
  module Context
    extend ActiveSupport::Autoload

    autoload :Attribute
    autoload :AttributeAssignment
    autoload :AttributeRegistration
    autoload :AttributeSet
    autoload :AttributeValidation
    autoload :Base
    autoload :Input
    autoload :Output
    autoload :Result
    autoload :Runtime
  end
end
