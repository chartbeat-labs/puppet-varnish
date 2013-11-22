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
           :ensure => 'running',
      })
    }
    it { should contain_file('/etc/init.d/varnish-default').with({
            :ensure => 'present',
            :owner => 'root',
            :group => 'root',
            :mode => '0700',
            :before => 'File[/etc/varnish/default.vcl]',
            :notify => 'Service[varnish-default]',
          }) \
          .with_content(/^NAME=varnishd-default$/) \
          .with_content(/^ulimit -n 131072$/) \
          .with_content(/^ulimit -l 82000$/) \
          .with_content(%r{/etc/default/varnish-default})
    }
    it { should contain_file('/etc/init.d/varnishlog-default').with({
            :ensure => 'present',
            :owner => 'root',
            :group => 'root',
            :mode => '0700',
            :notify => 'Service[varnishlog-default]',
          }) \
          .with_content(/^NAME=varnishlog-default$/)
    }
    it { should contain_file('/etc/init.d/varnishncsa-default').with({
            :ensure => 'present',
            :owner => 'root',
            :group => 'root',
            :mode => '0700',
            :notify => 'Service[varnishncsa-default]',
          }) \
          .with_content(/^NAME=varnishncsa-default$/)
    }
    it { should contain_file('/etc/default/varnish-default').with({
            :ensure => 'present',
            :owner => 'root',
            :group => 'root',
            :mode => '0644',
            :before => 'File[/etc/init.d/varnish-default]',
            :notify => 'Service[varnish-default]',
          }) \
          .with('ensure' => 'present') \
          .with_content(/-n default/) \
          .with_content(%r{-f /etc/varnish/default.vcl}) \
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
    it { should contain_file('/etc/default/varnishlog-default').with({
            :ensure => 'present',
            :owner => 'root',
            :group => 'root',
            :mode => '0644',
            :before => 'File[/etc/init.d/varnishlog-default]',
            :notify => 'Service[varnishlog-default]',
          }) \
          .with_content(/^VARNISHLOG_ENABLED=1$/)
    }
    it { should contain_file('/etc/default/varnishncsa-default').with({
            :ensure => 'present',
            :owner => 'root',
            :group => 'root',
            :mode => '0644',
            :before => 'File[/etc/init.d/varnishncsa-default]',
            :notify => 'Service[varnishncsa-default]',
          }) \
          .with_content(/^VARNISHNCSA_ENABLED=1$/)
    }
    it { should contain_file('/etc/varnish/default.vcl').with({
            :ensure => 'present',
            :owner => 'root',
            :group => 'root',
            :mode => '0644',
            :before => 'Service[varnish-default]',
            :notify => 'Exec[varnish-default safe reload]',
          }) \
          .with_content(%r{.url = "/alive"}) \
          .with_content(%r{.timeout = 300ms}) \
          .with_content(%r{.interval = 1s}) \
          .with_content(%r{.window = 10}) \
          .with_content(%r{.threshold = 6}) \
          .with_content(%r{.expected_response = 200}) \
          .with_content(/backend backend0.*host\ =\ "127\.0\.0\.1";.*port\ =\ "8080";.*first_byte_timeout\ =\ 60s;/sm) \
          .with_content(/backend = backend0;/) \
          .with_content(/acl purge \{\n\s*"localhost";\n\}/m)
    }
    it { should_not contain_file('/etc/varnish/default-extra.vcl') }
    it { should contain_service("varnish-default").with({
            :ensure => 'running',
            :enable => true,
          })
    }
    it { should contain_service("varnishlog-default").with({
            :ensure => 'stopped',
            :enable => false,
          })
    }
    it { should contain_service("varnishlog-default").with({
            :ensure => 'stopped',
            :enable => false,
          })
    }
  end

  describe 'when uninstalling a default varnish instance' do
    let :params do
      { :ensure => 'purged' }
    end

    it { should contain_varnish__instance('default').with({
           'ensure' => 'purged'
       })
    }

    [ '/etc/init.d/varnish-default',
      '/etc/init.d/varnishlog-default',
      '/etc/init.d/varnishncsa-default',
      '/etc/default/varnish-default',
      '/etc/default/varnishlog-default',
      '/etc/default/varnishncsa-default',
      '/etc/varnish/default.vcl',
    ].each do |file|
      it { should contain_file(file).with({
            :ensure => 'absent',
          })
      }
    end

    [ 'varnish-default',
      'varnishlog-default',
      'varnishncsa-default',
    ].each do |service|
      it { should contain_service(service).with({
            :ensure => 'stopped',
            :enable => false,
          })
      }
    end
  end

  describe 'default varnish instance installed but stopped' do
    let :params do
      { :ensure => 'stopped' }
    end

    it { should contain_varnish__instance('default').with({
           'ensure' => 'stopped'
       })
    }

    [ '/etc/init.d/varnish-default',
      '/etc/init.d/varnishlog-default',
      '/etc/init.d/varnishncsa-default',
      '/etc/default/varnish-default',
      '/etc/default/varnishlog-default',
      '/etc/default/varnishncsa-default',
      '/etc/varnish/default.vcl',
    ].each do |file|
      it { should contain_file(file).with({
            :ensure => 'present',
          })
      }
    end

    [ 'varnish-default',
      'varnishlog-default',
      'varnishncsa-default',
    ].each do |service|
      it { should contain_service(service).with({
            :ensure => 'stopped',
            :enable => false,
          })
      }
    end
  end

  describe "varnish instance with custom params" do
    let :title do
      'foo'
    end
    let :params do
      { :ensure => 'running',
        :init_method => 'sysvinit',
        :backends => ['127.0.0.1:8081', '127.0.0.1:8082'],
        :address => ['127.0.0.1:6081', '127.0.0.1:6082'],
        :admin_address => [':6083'],
        :purge_acls => ['"10.0.0.0"/8', '"192.168.0.1"'],
        :extra_conf => 'puppet:///modules/configs/fooserver/foo.vcl',
        :varnishlog => true,
        :varnishncsa => true,
        :vmods => ['libvmod-throttle'],
        :vmod_deps => ['libpcre3-dev'],
        :nfiles => '1',
        :memlock => '1',
        :health_check_url => '/ping',
        :health_check_timeout => '1s',
        :health_check_interval => '1d',
        :health_check_window => '2',
        :health_check_threshold => '1',
        :health_check_expected_response => '418',
        :storage => ['persistent,/mnt/varnish/foo_storage.bin,70%'],
        :default_ttl => '1',
        :thread_pool_min => '1',
        :thread_pool_max => '1',
        :thread_pool_timeout => '1',
        :auto_restart => 'off',
        :ban_dups => 'off',
        :ban_lurker_sleep => '1',
        :between_bytes_timeout => '1s',
        :cli_buffer => '1',
        :cli_timeout => '1s',
        :clock_skew => '1',
        :connect_timeout => '1s',
        :critbit_cooloff => '1',
        :default_grace => '1',
        :default_keep => '1',
        :diag_bitmap => '1',
        :esi_syntax => '1',
        :expiry_sleep => '0',
        :fetch_chunksize => '1',
        :fetch_maxchunksize => '1',
        :first_byte_timeout => '1s',
        :gzip_level => '1',
        :gzip_memlevel => '1',
        :gzip_stack_buffer => '1',
        :gzip_tmp_space => '1',
        :gzip_window => '1',
        :http_gzip_support => 'off',
        :http_max_hdr => '1',
        :http_range_support => 'off',
        :http_req_hdr_len => '1',
        :http_req_size => '1',
        :http_resp_hdr_len => '1',
        :http_resp_size => '1',
        :listen_depth => '1',
        :log_hashstring => 'off',
        :log_local_address => 'on',
        :lru_interval => '1',
        :max_esi_depth => '1',
        :max_restarts => '1',
        :nuke_limit => '1',
        :ping_interval => '1',
        :pipe_timeout => '1s',
        :prefer_ipv6 => 'on',
        :queue_max => '1',
        :rush_exponent => '1',
        :saintmode_threshold => '1',
        :send_timeout => '1s',
        :sess_timeout => '1s',
        :sess_workspace => '1',
        :session_linger => '1',
        :session_max => '1',
        :shm_reclen => '1',
        :shm_workspace => '1',
        :shortlived => '1',
        :syslog_cli_traffic => 'off',
        :thread_pool_add_delay => '1',
        :thread_pool_add_threshold => '1',
        :thread_pool_fail_delay => '1',
        :thread_pool_purge_delay => '1',
        :thread_pool_stack => '1',
        :thread_pool_workspace => '1',
        :thread_pools => '1',
        :thread_stats_rate => '1',
        :vcc_err_unref => 'off',
        :vcl_trace => 'on',

      }
    end
    it { should contain_varnish__instance('foo').with({
            :ensure => 'running',
      })
    }
    it { should contain_package('libpcre3-dev').with({
            :ensure => nil,
      })
    }
    it { should contain_package('libvmod-throttle').with({
            :ensure => 'present',
      })
    }
    it { should contain_varnish__vmod('libvmod-throttle').with({
            :ensure => 'present',
            :before => 'Service[varnish-foo]',
            :notify => 'Exec[varnish-foo safe reload]',
      })
    }
    it { should contain_file('/etc/init.d/varnish-foo').with({
            :ensure => 'present',
            :owner => 'root',
            :group => 'root',
            :mode => '0700',
          }) \
          .with_content(/^NAME=varnishd-foo$/) \
          .with_content(/^ulimit -n 1$/) \
          .with_content(/^ulimit -l 1$/) \
          .with_content(%r{/etc/default/varnish-foo})
    }
    it { should contain_file('/etc/init.d/varnishlog-foo').with({
            :ensure => 'present',
            :owner => 'root',
            :group => 'root',
            :mode => '0700',
          }) \
          .with_content(/^NAME=varnishlog-foo$/)
    }
    it { should contain_file('/etc/init.d/varnishncsa-foo').with({
            :ensure => 'present',
            :owner => 'root',
            :group => 'root',
            :mode => '0700',
          }) \
          .with_content(/^NAME=varnishncsa-foo$/)
    }
    it { should contain_file('/etc/default/varnish-foo').with({
            :ensure => 'present',
            :owner => 'root',
            :group => 'root',
            :mode => '0644',
          }) \
          .with('ensure' => 'present') \
          .with_content(/-n foo/) \
          .with_content(%r{-f /etc/varnish/foo.vcl}) \
          .with_content(/-a 127.0.0.1:6081,127.0.0.1:6082/) \
          .with_content(/-T :6083/) \
          .with_content(/-t 1/) \
          .with_content(/-w 1,1,1/) \
          .with_content(%r{-S /etc/varnish/secret}) \
          .with_content(%r{-s persistent,/mnt/varnish/foo_storage.bin,70%}) \
          .with_content(/-p auto_restart=off/) \
          .with_content(/-p ban_dups=off/) \
          .with_content(/-p ban_lurker_sleep=1/) \
          .with_content(/-p between_bytes_timeout=1s/) \
          .with_content(/-p cli_buffer=1/) \
          .with_content(/-p cli_timeout=1s/) \
          .with_content(/-p clock_skew=1/) \
          .with_content(/-p connect_timeout=1s/) \
          .with_content(/-p critbit_cooloff=1/) \
          .with_content(/-p default_grace=1/) \
          .with_content(/-p default_keep=1/) \
          .with_content(/-p diag_bitmap=1/) \
          .with_content(/-p esi_syntax=1/) \
          .with_content(/-p expiry_sleep=0/) \
          .with_content(/-p fetch_chunksize=1/) \
          .with_content(/-p fetch_maxchunksize=1/) \
          .with_content(/-p first_byte_timeout=1s/) \
          .with_content(/-p gzip_level=1/) \
          .with_content(/-p gzip_memlevel=1/) \
          .with_content(/-p gzip_stack_buffer=1/) \
          .with_content(/-p gzip_tmp_space=1/) \
          .with_content(/-p gzip_window=1/) \
          .with_content(/-p http_gzip_support=off/) \
          .with_content(/-p http_max_hdr=1/) \
          .with_content(/-p http_range_support=off/) \
          .with_content(/-p http_req_hdr_len=1/) \
          .with_content(/-p http_req_size=1/) \
          .with_content(/-p http_resp_hdr_len=1/) \
          .with_content(/-p http_resp_size=1/) \
          .with_content(/-p listen_depth=1/) \
          .with_content(/-p log_hashstring=off/) \
          .with_content(/-p log_local_address=on/) \
          .with_content(/-p lru_interval=1/) \
          .with_content(/-p max_esi_depth=1/) \
          .with_content(/-p max_restarts=1/) \
          .with_content(/-p nuke_limit=1/) \
          .with_content(/-p ping_interval=1/) \
          .with_content(/-p pipe_timeout=1s/) \
          .with_content(/-p prefer_ipv6=on/) \
          .with_content(/-p queue_max=1/) \
          .with_content(/-p rush_exponent=1/) \
          .with_content(/-p saintmode_threshold=1/) \
          .with_content(/-p send_timeout=1s/) \
          .with_content(/-p sess_timeout=1s/) \
          .with_content(/-p sess_workspace=1/) \
          .with_content(/-p session_linger=1/) \
          .with_content(/-p session_max=1/) \
          .with_content(/-p shm_reclen=1/) \
          .with_content(/-p shm_workspace=1/) \
          .with_content(/-p shortlived=1/) \
          .with_content(/-p syslog_cli_traffic=off/) \
          .with_content(/-p thread_pool_add_delay=1/) \
          .with_content(/-p thread_pool_add_threshold=1/) \
          .with_content(/-p thread_pool_fail_delay=1/) \
          .with_content(/-p thread_pool_purge_delay=1/) \
          .with_content(/-p thread_pool_stack=1/) \
          .with_content(/-p thread_pool_workspace=1/) \
          .with_content(/-p thread_pools=1/) \
          .with_content(/-p thread_stats_rate=1/) \
          .with_content(/-p vcc_err_unref=off/) \
          .with_content(/-p vcl_trace=on/)
    }
    it { should contain_file('/etc/default/varnishlog-foo').with({
            :ensure => 'present',
            :owner => 'root',
            :group => 'root',
            :mode => '0644',
          }) \
          .with_content(/^VARNISHLOG_ENABLED=1$/)
    }
    it { should contain_file('/etc/default/varnishncsa-foo').with({
            :ensure => 'present',
            :owner => 'root',
            :group => 'root',
            :mode => '0644',
          }) \
          .with_content(/^VARNISHNCSA_ENABLED=1$/)
    }
    it { should contain_file('/etc/varnish/foo.vcl').with({
            :ensure => 'present',
            :owner => 'root',
            :group => 'root',
            :mode => '0644',
          }) \
          .with_content(%r{.url = "/ping"}) \
          .with_content(%r{.timeout = 1s}) \
          .with_content(%r{.interval = 1d}) \
          .with_content(%r{.window = 2}) \
          .with_content(%r{.threshold = 1}) \
          .with_content(%r{.expected_response = 418}) \
          .with_content(/backend backend0.*host\ =\ "127\.0\.0\.1";.*port\ =\ "8081";.*first_byte_timeout\ =\ 1s;/sm) \
          .with_content(/backend backend1.*host\ =\ "127\.0\.0\.1";.*port\ =\ "8082";.*first_byte_timeout\ =\ 1s;/sm) \
          .with_content(/backend = backend0;/) \
          .with_content(/backend = backend1;/) \
          .with_content(/acl purge.*"10.0.0.0"\/8;.*"192.168.0.1";/sm)  \
          .with_content(/import throttle;/) \
          .with_content(/include "foo-extra.vcl";/)
    }
    it { should contain_file('/etc/varnish/foo-extra.vcl').with({
            :ensure => 'present',
            :owner => 'root',
            :group => 'root',
            :mode => '0644',
            :source => 'puppet:///modules/configs/fooserver/foo.vcl',
          })
    }
    it { should contain_service("varnish-foo").with({
            :ensure => 'running',
            :enable => true,
          })
    }
    it { should contain_service("varnishlog-foo").with({
            :ensure => 'running',
            :enable => true,
          })
    }
    it { should contain_service("varnishlog-foo").with({
            :ensure => 'running',
            :enable => true,
          })
    }
  end

  describe "varnish instance with custom vcl" do
    let :params do
      { :vcl_conf => 'puppet:///modules/configs/test/custom.vcl',
        :extra_conf => 'puppet:///modules/configs/test/subs.vcl'
      }
    end
    it { should contain_file('/etc/varnish/default.vcl').with({
            :source => 'puppet:///modules/configs/test/custom.vcl'
          })
    }
    it { should contain_file('/etc/varnish/default-extra.vcl').with({
            :source => 'puppet:///modules/configs/test/subs.vcl'
          })
    }
  end
  describe "it should fail" do
    context "when varnishlog is not a boolean" do
      let :params do
        { :varnishlog => 'foo' }
      end
      it { expect { should }.to raise_error(Puppet::Error,
                                            /"foo" is not a boolean/)
      }
    end
    context "when varnishncsa is not a boolean" do
      let :params do
        { :varnishlog => 'foo' }
      end
      it { expect { should }.to raise_error(Puppet::Error,
                                            /"foo" is not a boolean/)
      }
    end
    context "with unsupported init_method" do
      let :params do
        { :init_method => 'foo' }
      end
      it { expect { should }.to raise_error(
        Puppet::Error, /Varnish::Instance\[default\]: Unsupported init => foo/)
      }
    end
    context "with unsupported ensure" do
      let :params do
        { :ensure => 'foo' }
      end
      it { expect { should }.to raise_error(
        Puppet::Error, /Varnish::Instance\[default\]: Unsupported ensure => foo/)
      }
    end
  end
end
