source 'https://rubygems.org'

# Versions can be overridden with environment variables for matrix testing.
# Travis will remove Gemfile.lock before installing deps.

gem 'puppet', ENV['PUPPET_VERSION'] || '~> 3.7.0'

gem 'rake'
gem 'puppet-lint', '~> 1.0.1' # Until they fix regression for ignore_paths
gem 'serverspec'
gem 'rspec-puppet'
gem 'rspec-system-puppet'
gem 'rspec-system-serverspec'
gem 'puppetlabs_spec_helper'

# Needed since puppet 2.7 doesn't include hiera
gem 'hiera' if ENV['PUPPET_VERSION'] =~ /2.7/
gem 'hiera-puppet' if ENV['PUPPET_VERSION'] =~ /2.7/
