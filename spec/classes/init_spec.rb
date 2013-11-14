require 'spec_helper'

describe 'varnish' do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "varnish class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { should include_class('varnish::params') }

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

      it { expect { should }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
