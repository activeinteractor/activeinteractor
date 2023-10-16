# frozen_string_literal: true

module ActiveInteractor
  class Base < ActiveInteractor::Interactor::Base
    include Type::DeclerationMethods
  end
end
