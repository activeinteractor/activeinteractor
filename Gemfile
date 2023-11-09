# frozen_string_literal: true

source 'https://rubygems.org'

group :development, :test do
  gem 'code-scanning-rubocop', '~> 0.6'
  gem 'rake', '~> 13.0'
  gem 'rbs', '~> 3.2'
  gem 'rspec', '~> 3.12'
  gem 'rubocop', '~> 1.56'
  gem 'rubocop-performance', '~> 1.19'
  gem 'rubocop-rake', '~> 0.6'
  gem 'rubocop-rspec', '~> 2.21'
  gem 'rubocop-yard', '~> 0.7'
  gem 'semver2', git: 'https://github.com/haf/semver', branch: 'master'
end

group :test do
  gem 'simplecov', '~> 0.22'
end

group :doc do
  gem 'github-markup', '~> 4.0'
  gem 'redcarpet', '~> 3.6'
  gem 'yard', '~> 0.9'
  gem 'yard-activesupport-concern', '<= 1'
  gem 'yard-delegate', '~> 0.0.1'
end

# Specify your gem's dependencies in activeinteractor.gemspec
gemspec
