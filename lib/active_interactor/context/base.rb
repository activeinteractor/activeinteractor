# frozen_string_literal: true

module ActiveInteractor
  module Context
    class Base
      # extend ActiveModelErrorMethods::ClassMethods
      extend AttributeRegistration::ClassMethods
      extend Type::DeclerationMethods::ClassMethods
      include ActiveModel::Validations
      # include ActiveModelErrorMethods
      include AttributeRegistration
      include AttributeAssignment
      include AttributeValidation
      include Type::DeclerationMethods
    end
  end
end
