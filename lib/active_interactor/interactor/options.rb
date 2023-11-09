# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    class Options
      DEFAULTS = {
        skip_perform_callbacks: false,
        skip_rollback: false,
        skip_rollback_callbacks: false,
        validate: true,
        validate_input_context: true,
        validate_output_context: true
      }.freeze

      attr_reader(*DEFAULTS.keys)

      def initialize(options = {})
        prepared_options = DEFAULTS.merge(options.deep_dup)
        prepared_options.each_pair { |key, value| instance_variable_set("@#{key}", value) }
      end
    end
  end
end
