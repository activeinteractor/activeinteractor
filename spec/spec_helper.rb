# frozen_string_literal: true

require_relative 'support/coverage'
ActiveInteractor::Spec::Coverage.start

require 'bundler/setup'
require 'active_interactor'

ENV['RBS_TEST_TARGET'] ||= 'ActiveInteractor::*'
require 'rbs/test/setup'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = 'spec/.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = :random
  Kernel.srand config.seed
end

Dir[File.join(__dir__, 'support', '**', '*.rb')].each { |f| require f }
