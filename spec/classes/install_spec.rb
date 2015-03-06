require 'spec_helper'

describe 'varnish', :type => :class do
  let(:facts) {{
    :osfamily => 'Debian',
    :lsbdistid => 'Ubuntu',
    :lsbdistcodename => 'precise',
  }}

  context 'with no parameters' do
    let(:params) {{ }}

    it { should contain_package('varnish').with({
        :ensure => 'present',
      })
    }

    it { should contain_package('libvarnishapi1').with({
        :ensure => 'present',
      })
    }
  end

  context 'with ensure parameter' do
    let(:params) {{
      :package_ensure => '3.0.4-1'
    }}

    it { should contain_package('varnish').with({
        :ensure => '3.0.4-1',
      })
    }

    it { should contain_package('libvarnishapi1').with({
        :ensure => '3.0.4-1',
      })
    }
  end
end
