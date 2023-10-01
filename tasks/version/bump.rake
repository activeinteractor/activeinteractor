# frozen_string_literal: true

require_relative '../support/version_manager'

namespace :version do
  namespace :bump do
    desc 'bump major version'
    task :major do
      ActiveInteractor::Rake::VersionManager.new.bump_major
    end

    desc 'bump minor version'
    task :minor do
      ActiveInteractor::Rake::VersionManager.new.bump_minor
      Rake::Task['version:sync'].invoke
    end

    desc 'bump patch version'
    task :patch do
      ActiveInteractor::Rake::VersionManager.new.bump_patch
      Rake::Task['version:sync'].invoke
    end
  end
end
