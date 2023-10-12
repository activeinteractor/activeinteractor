# frozen_string_literal: true

module ActiveInteractor
  module HasActiveModelErrors
    extend ActiveSupport::Concern

    module ClassMethods
      def self.human_attribute_name(attribute, _options = {})
        attribute.respond_to?(:to_s) ? attribute.to_s.humanize : attribute
      end

      def self.lookup_ancestors
        [self]
      end
    end

    included do
      extend ActiveModel::Naming
      extend ClassMethods

      attr_reader :errors
    end

    def read_attribute_for_validation(attribute_name)
      send(attribute_name.to_sym)
    end
  end
end
