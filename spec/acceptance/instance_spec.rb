require 'spec_helper_acceptance'

describe 'instance tests: 1 instance install' do
  it 'should work with no errors and be idempotent' do
    pp = <<-EOS
      varnish::instance { 'default': }
    EOS

    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes  => true)
  end

  describe service('varnish-default') do
    it { should be_enabled }
    it { should be_running }
  end
end

describe 'instance test: 1 instance removal' do
  it 'should safely remove itself' do
    pp = <<-EOS
      varnish::instance { 'default': ensure => 'purged' }
    EOS

    apply_manifest(pp, :catch_failures => true)
  end

  describe service('varnish-default') do
    it { should_not be_running }
  end
end

describe 'instance test: 2 instances install' do
  it 'should work with no errors and be idempotent' do
    pp = <<-EOS
      varnish::instance { 'inst1': }
      varnish::instance { 'inst2':
        address => [ ':6083' ],
        admin_address => '127.0.0.1:6084',
      }
    EOS

    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes  => true)
  end

  describe service('varnish-inst1') do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('varnish-inst2') do
    it { should be_enabled }
    it { should be_running }
  end
end

describe 'instance test: 2 instances removal' do
  it 'should safely remove itself' do
    pp = <<-EOS
      varnish::instance { 'inst1': ensure => 'purged' }
      varnish::instance { 'inst2': ensure => 'purged' }
    EOS

    apply_manifest(pp, :catch_failures => true)
  end

  describe service('varnish-inst1') do
    it { should_not be_running }
  end

  describe service('varnish-inst2') do
    it { should_not be_running }
  end

end

describe 'instance install: with a dependent package installed independently' do
  it 'should work with no errors and be idempotent' do
    pp = <<-EOS
      package { 'git-core':
        ensure => 'installed',
        before => Varnish::Instance[inst1],
      }
      varnish::instance { 'inst1': }
    EOS

    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes  => true)
  end

  describe package('git-core') do
    it { should be_installed }
  end
end

describe 'instance install: purged instance should not remove package' do
  it 'should safely remove itself' do
    pp = <<-EOF
      varnish::instance { 'inst1': ensure => 'purged' }
    EOF

    apply_manifest(pp, :catch_failures => true)
  end

  describe package('git-core') do
    it { should be_installed }
  end
end

describe 'instance install with custom request' do
  it 'should work with no errors and be idempotent' do
    pp = <<-EOS
      varnish::instance { 'custom_request' :
        health_check_request => [ 'GET / HTTP/1.1',
                                  'Host: foo.bar.com',
                                  'Connection: close'
                                ]
      }
    EOS

    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes  => true)
  end
end
