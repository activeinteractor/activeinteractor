# frozen_string_literal: true

require 'simplecov'
require 'simplecov_json_formatter'

module ActiveInteractor
  module Spec
    class Coverage
      EXCLUDED_FILES_PATTERN = '/spec/'
      TRACKED_FILES_PATTERN = 'lib/**/*.rb'

      def self.start
        SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter
        SimpleCov.start do
          add_filter EXCLUDED_FILES_PATTERN
          enable_coverage :branch
          track_files TRACKED_FILES_PATTERN
        end
      end
    end
  end
end
