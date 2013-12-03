require 'spec_helper'

describe 'varnish::config' do
  let(:facts) {{
    :osfamily => 'Debian',
    :lsbdistcodename => 'precise',
  }}

  it { should contain_file('/usr/share/varnish/reload-vcl') }
end
