source "https://rubygems.org"

group :test do
  gem "rake", '< 11.0'
  gem "puppet", ENV['PUPPET_VERSION'] || '~> 3.7.0'
  gem "rspec", '< 3.2.0'
  gem "rspec-puppet", :git => 'https://github.com/rodjek/rspec-puppet.git'
  gem "puppetlabs_spec_helper"
  gem "metadata-json-lint", '<= 0.0.19'
  gem "rspec-puppet-facts"
end

group :development do
  gem "travis"
  gem "travis-lint"
  gem "vagrant-wrapper"
  gem "puppet-blacksmith"
  gem "guard-rake"
end

group :system_tests do
  gem "beaker"
  gem "beaker-rspec"
end
