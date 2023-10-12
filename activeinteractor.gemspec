# frozen_string_literal: true

GEM_VERSION = '2.0.0.alpha.2.3.1'
SEMVER = '2.0.0-alpha.2.3.1'
REPO = 'https://github.com/activeinteractor/activeinteractor'

Gem::Specification.new do |spec|
  spec.name = 'activeinteractor'
  spec.version = GEM_VERSION
  spec.summary       = 'Ruby interactors with ActiveModel::Validations'
  spec.description   = <<~DESC
    An implementation of the Command Pattern for Ruby with ActiveModel::Validations inspired by the interactor gem.
    Rich support for attributes, callbacks, and validations, and thread safe performance methods.
  DESC

  spec.required_ruby_version = '>= 3.0'

  spec.license = 'MIT'

  spec.authors       = ['Aaron Allen']
  spec.email         = ['hello@aaronmallen.me']
  spec.homepage      = REPO

  spec.files = Dir['CHANGELOG.md', 'LICENSE', 'README.md', 'lib/**/*', 'sig/**/*']
  spec.require_paths = ['lib']

  spec.metadata = {
    'bug_tracker_uri' => "#{REPO}/issues",
    'changelog_uri' => "#{REPO}/blob/v#{SEMVER}/CHANGELOG.md",
    'homepage_uri' => REPO,
    'source_code_uri' => "#{REPO}/tree/v#{SEMVER}",
    'wiki_uri' => "#{REPO}/wiki",
    'rubygems_mfa_required' => 'true'
  }

  spec.add_dependency 'activemodel', '>= 6.1', '< 8'
  spec.add_dependency 'activesupport', '>= 6.1', '< 8'
end
