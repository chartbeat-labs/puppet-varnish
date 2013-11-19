require 'spec_helper'

describe 'varnish::repo' do
  describe 'varnish::repo class on Debian' do
    let(:facts) {{
      :osfamily => 'Debian',
      :lsbdistcodename => 'precise',
    }}

    it { should include_class('apt') }

    it { should contain_apt__source('varnish-cache').with({
        'location' => 'http://repo.varnish-cache.org/debian/',
        'release' => 'precise',
        'repos' => 'varnish-3.0',
        'key' => 'C4DEFFEB',
        'key_source' => 'http://repo.varnish-cache.org/debian/GPG-key.txt',
        'include_src' => true,
      })
    }
  end
end
