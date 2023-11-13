# frozen_string_literal: true

module ActiveInteractor
  module Context
    # The base class for all context objects
    class Base
      extend AttributeRegistration::ClassMethods
      extend Type::DeclerationMethods::ClassMethods
      include ActiveModel::Validations
      include AttributeRegistration
      include AttributeAssignment
      include AttributeValidation
      include Type::DeclerationMethods
    end
  end
end
