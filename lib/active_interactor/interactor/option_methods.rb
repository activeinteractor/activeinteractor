# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    module OptionMethods
      def initialize(input = {})
        super(input)
        @options = Options.new
      end

      def with_options(options = {})
        @options = Options.new(options.deep_dup)
        self
      end
    end
  end
end
