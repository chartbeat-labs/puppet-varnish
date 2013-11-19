require 'spec_helper'

describe 'varnish::instance', :type => :define do
  let :title do
    'default'
  end

  let(:facts) {{
    :osfamily => 'Debian',
    :lsbdistcodename => 'precise',
  }}

  describe 'when installing a varnish instance' do
    it { should contain_varnish__instance('default').with({
           'ensure' => 'running'
      })
    }
  end

  describe 'when uninstalling a varnish instance' do
    let :params do
      { :ensure => 'purged' }
    end

    it { should contain_varnish__instance('default').with({
           'ensure' => 'purged'
       })
    }
  end
end
