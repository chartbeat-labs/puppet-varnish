require 'spec_helper'

describe 'varnish::install' do
  describe 'varnish::install class on Debian' do
    let(:facts) {{
      :osfamily => 'Debian',
    }}

    it { should contain_package('varnish') }
  end
end
