# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    # The Base Class inherited by all Interactors
    class Base
      extend Callbacks::ClassMethods
      extend ContextMethods::ClassMethods
      extend InteractionMethods::ClassMethods
      extend OptionMethods::ClassMethods
      extend Type::DeclerationMethods::ClassMethods
      include Callbacks
      include ContextMethods
      include InteractionMethods
      include OptionMethods
      include Type::DeclerationMethods
    end
  end
end
