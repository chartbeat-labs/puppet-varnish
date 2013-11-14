require 'spec_helper'

describe 'varnish::install' do
  describe 'varnish::install class on RedHat' do
    let(:facts) {{
      :osfamily => 'RedHat',
    }}

    it { should contain_package('varnish') }
  end

  describe 'varnish::install class on Debian' do
    let(:facts) {{
      :osfamily => 'Debian',
    }}

    it { should contain_package('varnish') }
  end
end
