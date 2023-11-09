# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    class Base
      extend Callbacks::ClassMethods
      extend ContextMethods::ClassMethods
      extend InteractionMethods::ClassMethods
      extend Type::DeclerationMethods::ClassMethods
      include Callbacks
      include ContextMethods
      include InteractionMethods
      include OptionMethods
      include Type::DeclerationMethods
    end
  end
end
