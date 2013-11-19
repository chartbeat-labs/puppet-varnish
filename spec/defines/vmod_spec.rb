require 'spec_helper'

describe 'varnish::vmod', :type => :define do
  let :title do
    'libvmod-test'
  end

  let :facts do
    { :osfamily => 'Debian' }
  end

  describe 'when installing a varnish vmod' do
    it { should contain_package('libvmod-test').with({
           'ensure' => 'present'
      })
    }
  end

  describe 'when uninstalling a varnish vmod' do
    let :params do
      { :ensure => 'absent' }
    end

    it { should contain_package('libvmod-test').with({
           'ensure' => 'absent'
       })
    }
  end

  describe 'when installing a varnish vmod with dependencies' do
    let :params do
      { :depends => ['libcurl'] }
    end

    it { should contain_package('libvmod-test') }
    it { should contain_package('libcurl') }
  end
end
