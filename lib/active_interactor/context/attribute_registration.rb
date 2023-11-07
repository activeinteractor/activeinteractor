# frozen_string_literal: true

module ActiveInteractor
  module Context
    # Methods for registering attributes with a context object
    #
    # @abstract included in {ActiveInteractor::Context::Base}
    # @api private
    # @visibility private
    module AttributeRegistration
      extend ActiveSupport::Concern

      # Class methods for registering attributes
      #
      # @abstract extended in {ActiveInteractor::Context::Base}
      module ClassMethods
        protected

        # The {ActivieInteractor::Context::AttributeSet} for the {ActiveInteractor::Context::Base} class
        #
        # @api private
        # @visibility private
        #
        # @return [ActiveInteractor::Context::AttributeSet]
        def attribute_set
          @attribute_set ||= AttributeSet.new(self)
        end
      end

      included do
        extend ClassMethods
      end

      protected

      # The {ActivieInteractor::Context::AttributeSet} for the {ActiveInteractor::Context::Base} instance
      #
      # @api private
      # @visibility private
      #
      # @return [ActiveInteractor::Context::AttributeSet]
      def attribute_set
        @attribute_set ||= AttributeSet.new(self, *self.class.send(:attribute_set).attributes.map(&:dup))
      end
    end
  end
end
