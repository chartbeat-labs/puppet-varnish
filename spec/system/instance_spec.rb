require 'spec_helper_system'

describe 'instance tests' do
  context "with 1 instance" do
    it 'should work with no errors and be idempotent' do
      pp = <<-EOS
        varnish::instance { 'default': }
      EOS

      puppet_apply(pp) do |r|
        r.exit_code.should == 2
        r.refresh
        r.exit_code.should be_zero
      end
    end

    describe service('varnish-default') do
      it { should be_enabled }
      it { should be_running }
    end

    it 'should safely remove itself' do
      pp = <<-EOS
        varnish::instance { 'default': ensure => 'purged' }
      EOS

      puppet_apply(pp) do |r|
        r.exit_code.should == 2
      end
    end
  end
  context "with 2 instances" do
    it 'should work with no errors and be idempotent' do
      pp = <<-EOS
        varnish::instance { 'inst1': }
        varnish::instance { 'inst2':
          address => [ ':6083' ],
          admin_address => '127.0.0.1:6084',
        }
      EOS

      puppet_apply(pp) do |r|
        r.exit_code.should == 2
        r.refresh
        r.exit_code.should be_zero
      end
    end
    it 'should safely remove itself' do
      pp = <<-EOS
        varnish::instance { 'inst1': ensure => 'purged' }
        varnish::instance { 'inst2': ensure => 'purged' }
      EOS

      puppet_apply(pp) do |r|
        r.exit_code.should == 2
      end
    end
  end
  context "with a dependent package installed by another means" do
    it 'should work with no errors and be idempotent' do
      pp = <<-EOS
        package { 'git-core':
          ensure => 'installed',
          before => Varnish::Instance[inst1],
        }
        varnish::instance { 'inst1': }
      EOS

      puppet_apply(pp) do |r|
        r.exit_code.should == 2
        r.refresh
        r.exit_code.should be_zero
      end
    end
    it 'should safely remove itself' do
      pp = <<-EOF
        package { 'git-core': ensure => 'purged' }
        varnish::instance { 'inst1': ensure => 'purged' }
      EOF

      puppet_apply(pp) do |r|
        r.exit_code.should == 2
      end
    end
  end
end
