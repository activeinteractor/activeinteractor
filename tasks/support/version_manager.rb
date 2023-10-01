# frozen_string_literal: true

require 'semver'

module ActiveInteractor
  module Rake
    class VersionManager
      def initialize
        @version = SemVer.find
      end

      def bump_major
        @version.major += 1
        @version.minor = 0
        @version.patch = 0
        reset_pre_meta
        save
      end

      def bump_minor
        @version.minor += 1
        @version.patch = 0
        reset_pre_meta
        save
      end

      def bump_patch
        @version.patch += 1
        reset_pre_meta
        save
      end

      def write_metadata(metadata)
        @version.metadata = metadata
        save
      end

      def write_prerelease(prerelease)
        @version.prerelease = prerelease
        @version.metadata = ''
        save
      end

      private

      def reset_pre_meta
        @version.prerelease = ''
        @version.metadata = ''
      end

      def save
        @version.save
      end
    end
  end
end
