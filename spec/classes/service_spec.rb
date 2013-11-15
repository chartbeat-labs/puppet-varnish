require 'spec_helper'

describe 'varnish::service' do
  describe 'varnish::service class on Debian' do
    let(:facts) {{
      :osfamily => 'Debian',
    }}

    it { should contain_service('varnish') }
  end
end
