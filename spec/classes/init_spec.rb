require 'spec_helper'

describe 'varnish' do
  context 'supported operating systems' do
    ['Debian'].each do |osfamily|
      describe "varnish class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
          :lsbdistid => 'Ubuntu',
          :lsbdistcodename => 'precise',
        }}

        it { should contain_class('varnish::params') }
        it { should contain_class('varnish::repo') }
        it { should contain_class('varnish::install') }
        it { should contain_class('varnish::config') }
        it { should contain_class('varnish::service') }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'varnish class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should raise_error(Puppet::Error, /Nexenta not supported/) } }
    end
  end
  context 'invalid parameter' do
    describe 'varnish class with invalid parameters' do
      let :params do
        { :foo => 'bar' }
      end
      it { expect { should raise_error(Puppet::Error, /Invalid parameter foo/) } }
    end
  end
end
