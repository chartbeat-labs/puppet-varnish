require 'spec_helper'

describe 'varnish', :type => :class do
  describe 'varnish::repo class on Debian' do
    let(:facts) {{
      :osfamily => 'Debian',
      :lsbdistcodename => 'precise',
    }}

    it { should contain_class('apt') }

    context 'with no parameters' do
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

    context 'with parameters specified' do
      let(:params) {{
        :apt_location => 'http://example.com/debian',
        :apt_repos => 'main',
        :apt_key => 'XXXXXXX',
        :apt_key_source => 'http://example.com/foo.txt',
        :apt_include_src => false,
      }}

      it { should contain_apt__source('varnish-cache').with({
        'location' => 'http://example.com/debian',
        'release' => 'precise',
        'repos' => 'main',
        'key' => 'XXXXXXX',
        'key_source' => 'http://example.com/foo.txt',
        'include_src' => false,
        })
      }
    end
  end
end
