require 'spec_helper'

describe 'varnish::service' do
  describe 'varnish::service class on Debian' do
    let(:facts) {{
      :osfamily => 'Debian',
      :lsbdistid => 'Ubuntu',
    }}

    it { should contain_service('varnish').with({
        :ensure => 'stopped',
        :enable => false,
      })
    }
  end
end
