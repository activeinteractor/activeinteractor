# frozen_string_literal: true

module ActiveInteractor
  module Context
    extend ActiveSupport::Autoload

    autoload :Attribute
    autoload :AttributeRegistration
    autoload :AttributeSet
    autoload :AttributeAssignment
    autoload :Base
    autoload :Input
    autoload :Output
    autoload :Runtime
  end
end
