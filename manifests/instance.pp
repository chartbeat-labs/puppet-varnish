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
# [*vcl_conf*]
#   You can set a custom vcl file to use here. Valid values are from a
#   fileserver resource, e.g. 'puppet:///...', or a path to a template. Raw
#   string content is not supported. This is the file for defining backends,
#   directors, purge acls, vmod imports and subroutines. If you specify a file
#   resource then then the parameters like backends, health check params, purge
#   acls etc will need to be statically specified in the vcl config. The default
#   template used here uses those params as template vars. You can also specify
#   a custom template so if you plan on using those parameters be sure to setup
#   you template to consume them.
#
# [*extra_conf*]
#   You can set a custom vcl file to use here. Valid values are from a
#   fileserver resource, e.g. 'puppet:///...', or a path to a template. Raw
#   string content is not supported. This is for the use case where you want to
#   keep the default vcl conf but want to extend subroutines. The subroutines as
#   defined in the default vcl conf do not return so you can extend subroutines
#   here and they will be appeneded at varnish compile time to the subroutines
#   defined in the default vcl. The only exception is a return statement in
#   vcl_recv when the req.request is PURGE, which immediately returns a lookup.
#
# [*purge_acls*]
#   Set an array of ip addresses or netblocks to allow purge access from.
#   Varnish is a littly finnicky about netblock representations. They need to be
#   the network surrounded in double quotes, followed by bare slash notation,
#   i.e "10.0.0.0"/8. So for an array , e.g. [ '"10.0.0.0"/8',
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
# [*health_check_url*]
#   Specify a URL to request from the backend. Defaults to "/".
#
# [*health_check_request*]
#   Specify a full HTTP request using multiple strings. .request will have \r\n
#   automatically inserted after every string.  If specified, .request will take
#   precedence over .url.
#
# [*health_check_timeout*]
#   How fast each probe times out. Default is 2 seconds.
#
# [*health_check_interval*]
#   Defines how often the probe should check the backend. Default is every 5
#   seconds.
#
# [*health_check_window*]
#   How many of the latest polls we examine to determine backend health.
#   Defaults to 8.
#
# [*health_check_threshold*]
#   How many of the polls in .window must have succeeded for us to consider the
#   backend healthy. Defaults to 3.
#
# [*health_check_expected_response*]
#   The expected backend HTTP response code. Defaults to 200.
#
# [*lb_method*]
#   The load balancing method of the director. Defaults to round-robin. Possible
#   values are random, client, hash, round-robin, and fallback. You can specify
#   dns but the additional options to the dns director are not supported at this
#   time. Patches are welcome. Or you can just override the main template with
#   your own. Read vcl(7) for more info.
#
# [*healthy_grace*]
#   This is the amount of time that we will serve a stale object when fetching
#   a fresh object from the backend. Examples, 5s, 2m, 4h, 1d.
#
# [*unhealthy_grace*]
#   This value affects both vcl_recv and vcl_fetch. So it means 2 different
#   things but ideally these values should be the same. For vcl_recv, it means
#   that this is amount of time we will serve a stale object when the backend is
#   unhealthy. In vcl_fetch it is the amount of time to keep a stale object in
#   cache. Examples, 5s, 2m, 4h, 1d.
#
# [*saintmode_blacklist*]
#   This is the amount of time to blacklist an unhealthy backend. This is needed
#   if the backend's health check is good but requests for resources return
#   50x's. This will ban varnish from fetching from a failing backend for an
#   amount of time. Default is 20s.
#
# [*storage*]
#   An Array of storage types. Current storage types are malloc, file,
#   persistent and transient. If you specify file or persistent, you will need
#   to specify the file path to the varnish_storage.bin file and either the size
#   of the file in K, M, G, or T or a percentage of the size of the filesystem.
#
#   Examples:
#     file,/var/lib/varnish/varnish_storage.bin,700M
#     persistent,/var/lib/varnish/varnish_storage.bin,60%
#
#   Please read varnishd(1) for more information.
#
# [*remaining options*]
#   The remaining options are all standard varnishd run time prameters, please
#   check out varnishd(1) for documenation.
#
define varnish::instance(
  $ensure = 'running',
  $init_method = 'sysvinit',
  $backends = ['127.0.0.1:8080'],
  $address = [':6081'],
  $admin_address = '127.0.0.1:6082',
  $vcl_conf = 'varnish/vcl/default.erb',
  $extra_conf = undef,
  $secret_file = '/etc/varnish/secret',
  $purge_acls = ['"localhost"'],
  $varnishlog = false,
  $varnishncsa = false,
  $vmods = [],
  $vmod_deps = [],
  $nfiles = '131072',
  $memlock = '82000',
  $health_check_url = '/',
  $health_check_request = undef,
  $health_check_timeout = '2s',
  $health_check_interval = '5s',
  $health_check_window = '8',
  $health_check_threshold = '3',
  $health_check_expected_response = '200',
  $lb_method = 'round-robin',
  $healthy_grace = '30s',
  $unhealthy_grace = '4h',
  $saintmode_blacklist = '20s',
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
  require varnish

  # Assign a more intuitive variable
  $instance = $name

  # Instance variables
  $daemon_conf = "/etc/default/varnish-${instance}"
  $log_daemon_conf = "/etc/default/varnishlog-${instance}"
  $ncsa_log_daemon_conf = "/etc/default/varnishncsa-${instance}"
  $vcl = "/etc/varnish/${instance}.vcl"
  $extra_vcl = "/etc/varnish/${instance}-extra.vcl"

  # Validations
  validate_bool($varnishlog, $varnishncsa)

  # Determine whether it's a fileserver path or template path.
  case $vcl_conf {
    /puppet:\/\/\// : {
      $vcl_file_type = 'source'
    }
    default : {
      $vcl_file_type = 'template'
    }
  }

  case $extra_conf {
    /puppet:\/\/\// : {
      $extra_file_type = 'source'
    }
    default : {
      $extra_file_type = 'template'
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
    ensure  => $package_ensure,
    depends => $vmod_deps,
    tag     => 'varnish-vmod',
    before  => Service["varnish-${instance}"],
    notify  => Exec["varnish-${instance} safe reload"],
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
  case $vcl_file_type {
    'source' : {
      file { $vcl : source => $vcl_conf }
    }
    default : {
      file { $vcl : content => template($vcl_conf) }
    }
  }

  if $extra_conf {
    case $extra_file_type {
      'source' : {
        file { $extra_vcl : source => $extra_conf }
      }
      default : {
        file { $extra_vcl : content => template($extra_conf) }
      }
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
    command     => "/usr/share/varnish/reload-vcl -f ${daemon_conf}",
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
      -> File[$vcl]
      -> File[$service_conf]
      -> File[$log_service_conf]
      -> File[$ncsa_log_service_conf]

      if defined(File[$extra_vcl]) {
        Service["varnish-${instance}"] -> File[$extra_vcl]
      }
    }
    default : {
      File[$daemon_conf]
      -> File[$service_conf]
      -> File[$vcl]
      -> Service["varnish-${instance}"]

      if defined(File[$extra_vcl]) {
        File[$extra_vcl] -> Service["varnish-${instance}"]
      }

      # $daemon_conf and $service_conf should do a hard restart of varnish
      File[$daemon_conf] ~> Service["varnish-${instance}"]
      File[$service_conf] ~> Service["varnish-${instance}"]

      # Ensure the service is running before any calls to safe reload
      Service["varnish-${instance}"] -> Exec["varnish-${instance} safe reload"]

      # vcl confs should do a safe reload
      File[$vcl] ~> Exec["varnish-${instance} safe reload"]

      if defined(File[$extra_vcl]) {
        File[$extra_vcl] ~> Exec["varnish-${instance} safe reload"]
      }

      File[$log_daemon_conf]
      -> File[$log_service_conf]

      File[$log_daemon_conf] ~> Service["varnishlog-${instance}"]
      File[$log_service_conf] ~> Service["varnishlog-${instance}"]

      File[$ncsa_log_daemon_conf]
      -> File[$ncsa_log_service_conf]

      File[$ncsa_log_daemon_conf] ~> Service["varnishncsa-${instance}"]
      File[$ncsa_log_service_conf] ~> Service["varnishncsa-${instance}"]
    }
  }
}
