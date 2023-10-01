# frozen_string_literal: true

require_relative '../support/version_manager'

namespace :version do
  namespace :set do
    desc 'set prerelease version'
    task :prerelease, [:prerelease] do |_, args|
      ActiveInteractor::Rake::VersionManager.new.write_prerelease(args[:prerelease])
      Rake::Task['version:sync'].invoke
    end

    desc 'set metadata version'
    task :metadata, [:metadata] do |_, args|
      ActiveInteractor::Rake::VersionManager.new.write_metadata(args[:metadata])
      Rake::Task['version:sync'].invoke
    end
  end
end
