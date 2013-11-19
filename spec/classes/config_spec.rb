require 'spec_helper'

describe 'varnish::config' do
  describe 'varnish::install class on Debian' do
    let(:facts) {{
      :osfamily => 'Debian',
    }}

    it { should contain_file('/usr/share/varnish/reload_vcl') }
  end
end
