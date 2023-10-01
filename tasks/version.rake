# frozen_string_literal: true

require_relative 'support/gem_spec_version_updater'

namespace :version do
  desc 'sync version with gemspec'
  task :sync do
    ActiveInteractor::Rake::GemSpecVersionUpdater.update!
  end

  desc 'bump patch version'
  task :bump do
    Rake::Task['version:bump:patch'].invoke
  end
end
