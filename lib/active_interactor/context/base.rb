# frozen_string_literal: true

module ActiveInteractor
  module Context
    class Base
      extend AttributeAssignment::ClassMethods
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
