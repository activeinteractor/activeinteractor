# frozen_string_literal: true

module ActiveInteractor
  # The Type namespace
  module Type
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :Boolean
    autoload :DeclerationMethods
    autoload :List
    autoload :Union
  end
end
