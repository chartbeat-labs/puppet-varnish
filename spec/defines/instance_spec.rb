require 'spec_helper'

describe 'varnish::instance', :type => :define do
  let :title do
    'default'
  end

  let(:facts) {{
    :osfamily => 'Debian',
    :lsbdistcodename => 'precise',
  }}

  describe 'when installing a default varnish instance' do
    it { should contain_varnish__instance('default').with({
           'ensure' => 'running'
      })
    }
    it { should contain_file('/etc/init.d/varnish-default') \
          .with_content(/^NAME=varnishd-default$/) \
          .with_content(/^ulimit -n 131072$/) \
          .with_content(/^ulimit -l 82000$/) \
          .with_content(%r{/etc/default/varnish-default})
    }
    it { should contain_file('/etc/init.d/varnishlog-default') \
          .with_content(/^NAME=varnishlog-default$/)
    }
    it { should contain_file('/etc/init.d/varnishncsa-default') \
          .with_content(/^NAME=varnishncsa-default$/)
    }
    it { should contain_file('/etc/default/varnish-default') }
    it { should contain_file('/etc/default/varnishlog-default') \
          .with_content(/^# VARNISHLOG_ENABLED=1$/)
    }
    it { should contain_file('/etc/default/varnishncsa-default') \
          .with_content(/^# VARNISHNCSA_ENABLED=1$/)
    }
    it { should contain_file('/etc/varnish/main-default.vcl') \
          .with_content(%r{.url = "/alive"}) \
          .with_content(%r{.timeout = 300ms}) \
          .with_content(%r{.interval = 1s}) \
          .with_content(%r{.window = 10}) \
          .with_content(%r{.threshold = 6}) \
          .with_content(%r{.expected_response = 200}) \
          .with_content(/backend backend0 \{\n\s*\.host = "127\.0\.0\.1";\n\s*\.port = "8080"/m) \
          .with_content(/backend = backend0;/) \
          .with_content(/acl purge \{\n\s*localhost;\n\}/m) \
          .with_content(/include "subs-default.vcl";/)


    }
    it { should contain_file('/etc/varnish/subs-default.vcl') }
  end

  describe 'when uninstalling a default varnish instance' do
    let :params do
      { :ensure => 'purged' }
    end

    it { should contain_varnish__instance('default').with({
           'ensure' => 'purged'
       })
    }
  end
end
