# frozen_string_literal: true

module ActiveInteractor
  module Type
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :Boolean
    autoload :HasTypes
    autoload :List
    autoload :Union
  end
end
