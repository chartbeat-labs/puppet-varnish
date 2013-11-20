# == Define varnish::instance
#
# Installs a varnish instance
#
# === Parameters
#
# [*ensure*]
#   The instance state, i.e. running, stopped, purged.
#
# [*init_method*]
#   The init method to use, supported methods are sysvinit, runit, and upstart
#
# [*address*]
#   An array of address:port's to listen on. Defaults to :80 which is all Ipv4
#   addresses on port 6081.
#
# [*admin_address*]
#   The address:port for the admin interface to listen on.
#
# [*backends*]
#   An array of address:port's to configure as backends.
#
# [*varnishlog*]
#   Whether to enable the varnishlog daemon.
#
# [*varnishncsa*]
#   Whether to enable the varnishncsa daemon.
#
# [*main_conf*]
#   You can set a custom vcl file to use here. Valid values are from a
#   fileserver resource, e.g. 'puppet:///...', or a path to a template. Raw
#   string content is not supported. This is the file for defining backends,
#   directors, purge acls, vmod imports etc. Be sure to include your subs conf
#   in this file since this is the main vcl file that varnish uses.
#
# [*subs_conf*]
#   You can set a custom vcl file to use here. Valid values are from a
#   fileserver resource, e.g. 'puppet:///...', or a path to a template. Raw
#   string content is not supported. DO NOT include import or backend configs
#   in this document. Those are set by backend/vmods parameters. This is a conf
#   for strictly defining subroutines, e.g. vcl_recv/vcl_fetch.
#
# [*purge_acls*]
#   Set an array of ip addresses or netblocks to allow purge access from.
#   Varnish is a littly finnicky about netblock representations. They need to be
#   the network surrounded in double quotes, followed by bare slash notation,
#   i.e "10.0.0.0"/8. So for an array of these, e.g. [ '"10.0.0.0"/8',
#   '"192.168.0.2"/24', '"127.0.0.1"' ]
#
# [*vmods*]
#   A list of vmod packages to install.
#
# [*vmod_deps*]
#   A list of vmod package dependencies to install.
#
# [*nfiles*]
#   Max open files
#
# [*memlock*]
#   Maximum locked memory size for shared memory log
#
define varnish::instance(
  $ensure = 'running',
  $init_method = 'sysvinit',
  $backends = ['127.0.0.1:8080'],
  $address = [':6081'],
  $admin_address = '127.0.0.1:6082',
  $main_conf = 'varnish/vcl/main.erb',
  $subs_conf = 'varnish/vcl/subs.erb',
  $secret_file = '/etc/varnish/secret',
  $purge_acls = ['"localhost"'],
  $varnishlog = false,
  $varnishncsa = false,
  $vmods = [],
  $vmod_deps = [],
  $nfiles = '131072',
  $memlock = '82000',
  $health_check_url = '/alive',
  $health_check_timeout = '300ms',
  $health_check_interval = '1s',
  $health_check_window = '10',
  $health_check_threshold = '6',
  $health_check_expected_response = '200',
  $storage = [],
  $default_ttl = '120',
  $thread_pool_min = '5',
  $thread_pool_max = '500',
  $thread_pool_timeout = '300',
  $auto_restart = 'on',
  $ban_dups = 'on',
  $ban_lurker_sleep = '0.01',
  $between_bytes_timeout = '60s',
  $cli_buffer = '8192',
  $cli_timeout = '10s',
  $clock_skew = '10',
  $connect_timeout = '0.7s',
  $critbit_cooloff = '180.0',
  $default_grace = '10',
  $default_keep = '0',
  $diag_bitmap = '0',
  $esi_syntax = '0',
  $expiry_sleep = '1',
  $fetch_chunksize = '128',
  $fetch_maxchunksize = '262144',
  $first_byte_timeout = '60s',
  $gzip_level = '6',
  $gzip_memlevel = '8',
  $gzip_stack_buffer = '32768',
  $gzip_tmp_space = '0',
  $gzip_window = '15',
  $http_gzip_support = 'on',
  $http_max_hdr = '64',
  $http_range_support = 'on',
  $http_req_hdr_len = '8192',
  $http_req_size = '32768',
  $http_resp_hdr_len = '8192',
  $http_resp_size = '32768',
  $listen_depth = '1024',
  $log_hashstring = 'on',
  $log_local_address = 'off',
  $lru_interval = '2',
  $max_esi_depth = '5',
  $max_restarts = '4',
  $nuke_limit = '50',
  $ping_interval = '3',
  $pipe_timeout = '60s',
  $prefer_ipv6 = 'off',
  $queue_max = '100',
  $rush_exponent = '3',
  $saintmode_threshold = '10',
  $send_timeout = '60s',
  $sess_timeout = '5s',
  $sess_workspace = '65536',
  $session_linger = '50',
  $session_max = '100000',
  $shm_reclen = '255',
  $shm_workspace = '8192',
  $shortlived = '10.0',
  $syslog_cli_traffic = 'on',
  $thread_pool_add_delay = '2',
  $thread_pool_add_threshold = '2',
  $thread_pool_fail_delay = '200',
  $thread_pool_purge_delay = '500',
  $thread_pool_stack = '-1',
  $thread_pool_workspace = '65536',
  $thread_pools = '2',
  $thread_stats_rate = '10',
  $vcc_err_unref = 'on',
  $vcl_trace = 'off',
) {
  include varnish

  validate_bool($varnishlog, $varnishncsa)

  # Determine whether it's a fileserver path or template path.
  case $main_conf {
    /puppet:\/\/\// : {
      $main_file_type = 'source'
    }
    default : {
      $main_file_type = 'template'
    }
  }

  case $subs_conf {
    /puppet:\/\/\// : {
      $subs_file_type = 'source'
    }
    default : {
      $subs_file_type = 'template'
    }
  }

  # Determine the instance state
  case $ensure {
    'running': {
      $package_ensure = 'present'
      $file_ensure = 'present'
      $service_ensure = 'running'
      $service_enable = true
    }
    'stopped': {
      $package_ensure = 'present'
      $file_ensure = 'present'
      $service_ensure = 'stopped'
      $service_enable = false
    }
    'purged' : {
      $package_ensure = 'purged'
      $file_ensure = 'absent'
      $service_ensure = 'stopped'
      $service_enable = false
    }
    default : {
      fail("Varnish::Instance[${instance}]: Unsupported ensure => ${ensure}")
    }
  }

  if $varnishlog {
    $log_service_ensure = 'running'
    $log_service_enable = true
  } else {
    $log_service_ensure = 'stopped'
    $log_service_enable = false
  }

  if $varnishncsa {
    $ncsa_log_service_ensure = 'running'
    $ncsa_log_service_enable = true
  } else {
    $ncsa_log_service_ensure = 'stopped'
    $ncsa_log_service_enable = false
  }


  # Assign a more intuitive variable
  $instance = $name

  # Instance variables
  $daemon_conf = "/etc/default/varnish-${instance}"
  $log_daemon_conf = "/etc/default/varnishlog-${instance}"
  $ncsa_log_daemon_conf = "/etc/default/varnishncsa-${instance}"
  $main_vcl = "/etc/varnish/main-${instance}.vcl"
  $subs_vcl = "/etc/varnish/subs-${instance}.vcl"

  # Determine init method
  case $init_method {
    'sysvinit' : {
      $service_provider = 'debian'
      $service_conf = "/etc/init.d/varnish-${instance}"
      $log_service_conf = "/etc/init.d/varnishlog-${instance}"
      $ncsa_log_service_conf = "/etc/init.d/varnishncsa-${instance}"
    }
    'runit' : {
      $service_provider = 'runit'
      $service_conf = "/etc/sv/varnish-${instance}/run"
      $log_service_conf = "/etc/sv/varnishlog-${instance}/run"
      $ncsa_log_service_conf = "/etc/sv/varnishncsa-${instance}/run"
    }
    'upstart' : {
      $service_provider = 'upstart'
      $service_conf = "/etc/init/varnish-${instance}.conf"
      $log_service_conf = "/etc/init/varnishlog-${instance}.conf"
      $ncsa_log_service_conf = "/etc/init/varnishncsa-${instance}.conf"
    }
    default : {
      fail("Varnish::Instance[${instance}]: Unsupported init => ${init_method}")
    }
  }

  # Determine storage file
  if empty($storage) {
    $storage_real = [
      "file,/var/lib/varnish/${instance}/varnish_storage.bin,70%"
    ]
  } else {
    $storage_real = $storage
  }

  # Resource Defaults
  File {
    ensure => $file_ensure,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # Optional Vmods
  varnish::vmod { $vmods :
    ensure   => $package_ensure,
    depends  => $vmod_deps,
    tag      => 'varnish-vmod',
  }

  # Config files
  file { $daemon_conf :
    content => template('varnish/default/varnish.erb'),
  }

  file { $log_daemon_conf :
    content => template('varnish/default/varnishlog.erb'),
  }

  file { $ncsa_log_daemon_conf :
    content => template('varnish/default/varnishncsa.erb'),
  }

  # VCL Config files
  case $main_file_type {
    'source' : {
      file { $main_vcl : source => $main_conf }
    }
    default : {
      file { $main_vcl : content => template($main_conf) }
    }
  }

  case $subs_file_type {
    'source' : {
      file { $subs_vcl : source => $subs_conf }
    }
    default : {
      file { $subs_vcl : content => template($subs_conf) }
    }
  }

  # Service configs
  file { $service_conf :
    ensure  => $file_ensure,
    mode    => '0700',
    content => template("varnish/${init_method}/varnish.erb"),
  }

  file { $log_service_conf :
    ensure  => $file_ensure,
    mode    => '0700',
    content => template("varnish/${init_method}/varnishlog.erb"),
  }

  file { $ncsa_log_service_conf :
    ensure  => $file_ensure,
    mode    => '0700',
    content => template("varnish/${init_method}/varnishncsa.erb"),
  }

  # Services
  service { "varnish-${instance}" :
    ensure     => $service_ensure,
    enable     => $service_enable,
    hasstatus  => true,
    hasrestart => true,
    provider   => $service_provider,
  }

  service { "varnishlog-${instance}" :
    ensure     => $log_service_ensure,
    enable     => $log_service_enable,
    hasstatus  => true,
    hasrestart => true,
    provider   => $service_provider,
  }

  service { "varnishncsa-${instance}" :
    ensure     => $ncsa_log_service_ensure,
    enable     => $ncsa_log_service_enable,
    hasstatus  => true,
    hasrestart => true,
    provider   => $service_provider,
  }

  exec { "varnish-${instance} safe reload" :
    command     => "/usr/share/varnish/reload-vcl -f ${main_vcl}",
    refreshonly => true,
  }

  # Setup resource ordering
  case $ensure {
    # For purged resources, need to stop the service before removing files
    'purged' : {
      Service["varnish-${instance}"]
        -> Service["varnishlog-${instance}"]
        -> Service["varnishncsa-${instance}"]
        -> File[$daemon_conf]
        -> File[$log_daemon_conf]
        -> File[$ncsa_log_daemon_conf]
        -> File[$subs_vcl]
        -> File[$main_vcl]
        -> File[$service_conf]
        -> File[$log_service_conf]
        -> File[$ncsa_log_service_conf]
        -> Class[varnish]
    }
    default : {
      # $daemon_conf and $service_conf should do a hard restart of varnish
      Class[varnish]
        -> File[$daemon_conf]
        -> File[$service_conf]
        -> Service["varnish-${instance}"]

      # vmods and vcl confs should do a safe reload
      Class[varnish]
        -> Package <| tag == 'varnish-vmod' |>
        -> File[$main_vcl]
        -> File[$subs_vcl]
        ~> Exec["varnish-${instance} safe reload"]

      Class[varnish]
        -> File[$log_daemon_conf]
        -> File[$log_service_conf]
        ~> Service["varnishlog-${instance}"]

      Class[varnish]
        -> File[$ncsa_log_daemon_conf]
        -> File[$ncsa_log_service_conf]
        ~> Service["varnishncsa-${instance}"]
    }
  }
}
