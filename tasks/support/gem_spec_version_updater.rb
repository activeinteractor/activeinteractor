# frozen_string_literal: true

require 'semver'

module ActiveInteractor
  module Rake
    module GemSpecVersionUpdater
      GEMSPEC = File.expand_path('../../activeinteractor.gemspec', __dir__)

      class << self
        def update!
          version = SemVer.find
          File.write(GEMSPEC, generate_gem_spec(version))
        end

        private

        def change_version_line(line, version)
          return gem_version_line(version) if line.include?('GEM_VERSION =')
          return semver_line(version) if line.include?('SEMVER =')

          line
        end

        def generate_gem_spec(version)
          File.readlines(GEMSPEC).map { |line| change_version_line(line, version) }.join
        end

        def gem_version_line(version)
          parts = [version.major, version.minor, version.patch, version.prerelease, version.metadata]
                  .map(&:to_s)
                  .reject(&:empty?)
          "GEM_VERSION = '#{parts.join('.')}'\n"
        end

        def semver_line(version)
          version_string = [version.major, version.minor, version.patch].map(&:to_s).reject(&:empty?).join('.')
          version_string = "#{version_string}-#{version.prerelease}" unless version.prerelease.empty?
          version_string = "#{version_string}+#{version.metadata}" unless version.metadata.empty?
          "SEMVER = '#{version_string}'\n"
        end
      end
    end
  end
end
