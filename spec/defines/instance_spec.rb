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
    it { should contain_file('/etc/default/varnish-default') \
          .with_content(/-n default/) \
          .with_content(%r{-f /etc/varnish/main-default.vcl}) \
          .with_content(/-a :6081/) \
          .with_content(/-T 127.0.0.1:6082/) \
          .with_content(/-t 120/) \
          .with_content(/-w 5,500,300/) \
          .with_content(%r{-S /etc/varnish/secret}) \
          .with_content(%r{-s file,/var/lib/varnish/default_storage.bin,70%}) \
          .with_content(/-p auto_restart=on/) \
          .with_content(/-p ban_dups=on/) \
          .with_content(/-p ban_lurker_sleep=0.01/) \
          .with_content(/-p between_bytes_timeout=60s/) \
          .with_content(/-p cli_buffer=8192/) \
          .with_content(/-p cli_timeout=10s/) \
          .with_content(/-p clock_skew=10/) \
          .with_content(/-p connect_timeout=0.7s/) \
          .with_content(/-p critbit_cooloff=180.0/) \
          .with_content(/-p default_grace=10/) \
          .with_content(/-p default_keep=0/) \
          .with_content(/-p diag_bitmap=0/) \
          .with_content(/-p esi_syntax=0/) \
          .with_content(/-p expiry_sleep=1/) \
          .with_content(/-p fetch_chunksize=128/) \
          .with_content(/-p fetch_maxchunksize=262144/) \
          .with_content(/-p first_byte_timeout=60s/) \
          .with_content(/-p gzip_level=6/) \
          .with_content(/-p gzip_memlevel=8/) \
          .with_content(/-p gzip_stack_buffer=32768/) \
          .with_content(/-p gzip_tmp_space=0/) \
          .with_content(/-p gzip_window=15/) \
          .with_content(/-p http_gzip_support=on/) \
          .with_content(/-p http_max_hdr=64/) \
          .with_content(/-p http_range_support=on/) \
          .with_content(/-p http_req_hdr_len=8192/) \
          .with_content(/-p http_req_size=32768/) \
          .with_content(/-p http_resp_hdr_len=8192/) \
          .with_content(/-p http_resp_size=32768/) \
          .with_content(/-p listen_depth=1024/) \
          .with_content(/-p log_hashstring=on/) \
          .with_content(/-p log_local_address=off/) \
          .with_content(/-p lru_interval=2/) \
          .with_content(/-p max_esi_depth=5/) \
          .with_content(/-p max_restarts=4/) \
          .with_content(/-p nuke_limit=50/) \
          .with_content(/-p ping_interval=3/) \
          .with_content(/-p pipe_timeout=60s/) \
          .with_content(/-p prefer_ipv6=off/) \
          .with_content(/-p queue_max=100/) \
          .with_content(/-p rush_exponent=3/) \
          .with_content(/-p saintmode_threshold=10/) \
          .with_content(/-p send_timeout=60s/) \
          .with_content(/-p sess_timeout=5s/) \
          .with_content(/-p sess_workspace=65536/) \
          .with_content(/-p session_linger=50/) \
          .with_content(/-p session_max=100000/) \
          .with_content(/-p shm_reclen=255/) \
          .with_content(/-p shm_workspace=8192/) \
          .with_content(/-p shortlived=10.0/) \
          .with_content(/-p syslog_cli_traffic=on/) \
          .with_content(/-p thread_pool_add_delay=2/) \
          .with_content(/-p thread_pool_add_threshold=2/) \
          .with_content(/-p thread_pool_fail_delay=200/) \
          .with_content(/-p thread_pool_purge_delay=500/) \
          .with_content(/-p thread_pool_stack=-1/) \
          .with_content(/-p thread_pool_workspace=65536/) \
          .with_content(/-p thread_pools=2/) \
          .with_content(/-p thread_stats_rate=10/) \
          .with_content(/-p vcc_err_unref=on/) \
          .with_content(/-p vcl_trace=off/)
    }
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
          .with_content(/backend backend0.*host\ =\ "127\.0\.0\.1";.*port\ =\ "8080";.*first_byte_timeout\ =\ 60s;/sm) \
          .with_content(/backend = backend0;/) \
          .with_content(/acl purge \{\n\s*"localhost";\n\}/m) \
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
