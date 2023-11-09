# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    module OptionMethods
      module ClassMethods
        def with_options(options)
          new(options)
        end
      end

      def initialize(options = {})
        @options = Options.new(options.deep_dup)
      end

      def with_options(options)
        @options = Options.new(options.deep_dup)
        self
      end
    end
  end
end
