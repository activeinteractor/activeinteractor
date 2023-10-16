# frozen_string_literal: true

module ActiveInteractor
  module ActiveModelErrorMethods
    extend ActiveSupport::Concern

    attr_reader :errors

    module ClassMethods
      def human_attribute_name(attribute, _options = {})
        attribute.respond_to?(:to_s) ? attribute.to_s.humanize : attribute
      end

      def lookup_ancestors
        [self]
      end
    end

    included do
      extend ActiveModel::Naming
      extend ClassMethods
    end

    def read_attribute_for_validation(attribute_name)
      send(attribute_name.to_sym)
    end
  end
end
