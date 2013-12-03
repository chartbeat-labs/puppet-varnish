require 'spec_helper'

describe 'varnish::install' do
  let(:facts) {{
    :osfamily => 'Debian'
  }}

  context 'with no parameters' do
    let(:params) {{ }}

    it { should contain_package('varnish').with({
        :ensure => 'present',
      })
    }
  end

  context 'with ensure parameter' do
    let(:params) {{
      :ensure => '3.0.4-1'
    }}

    it { should contain_package('varnish').with({
        :ensure => '3.0.4-1',
      })
    }
  end
end
