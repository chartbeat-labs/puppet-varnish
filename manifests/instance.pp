# == Define varnish::instance
#
# Installs a varnish instance
#
# === Parameters
#
# [*ensure*]
#   The instance state, i.e. running, stopped, purged.
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
  $backends = ['127.0.0.1:8080'],
  $address = [':6081'],
  $admin_address = '127.0.0.1:6082',
  $main_conf = 'varnish/vcl/main.erb',
  $subs_conf = 'varnish/vcl/subs.erb',
  $purge_acls = ['localhost'],
  $varnishlog = false,
  $varnishncsa = false,
  $vmods = [],
  $vmod_deps = [],
  $nfiles = '131072',
  $memlock = '82000',
) {
  include varnish

  validate_bool($varnishlog, $varnishncsa)

  # Assign a more intuitive variable
  $instance = $name

  # Instance variables
  $daemon_conf = "/etc/default/${instance}-varnish"
  $log_daemon_conf = "/etc/default/${instance}-varnishlog"
  $ncsa_log_daemon_conf = "/etc/default/${instance}-varnishncsa"
  $main_vcl = "/etc/varnish/main-${instance}.vcl"
  $subs_vcl = "/etc/varnish/${instance}.vcl"
  $service_conf = "/etc/init/varnish-${instance}.conf"
  $log_service_conf = "/etc/init/varnishlog-${instance}.conf"
  $ncsa_log_service_conf = "/etc/init/varnishncsa-${instance}.conf"

  # Determine whether it's a fileserver path or template path.
  case $conf {
    /puppet:\/\/\// : {
      $vcl_file_type = 'source'
    }
    default : {
      $vcl_file_type = 'template'
    }
  }

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
  file { $main_vcl :
    content => template($main_conf),
  }

  case $vcl_file_type {
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
    content => template('varnish/init/varnish.erb'),
  }

  file { $log_service_conf :
    ensure  => $file_ensure,
    mode    => '0700',
    content => template('varnish/init/varnishlog.erb'),
  }

  file { $ncsa_log_service_conf :
    ensure  => $file_ensure,
    mode    => '0700',
    content => template('varnish/init/varnishncsa.erb'),
  }

  # Services
  service { "${instance}-varnish" :
    ensure     => $service_ensure,
    enable     => $service_enable,
    hasstatus  => true,
    hasrestart => true,
  }

  service { "${instance}-varnishlog" :
    ensure     => $log_service_ensure,
    enable     => $log_service_enable,
    hasstatus  => true,
    hasrestart => true,
  }

  service { "${instance}-varnishncsa" :
    ensure => $ncsa_log_service_ensure,
    enable => $ncsa_log_service_enable,
    hasstatus  => true,
    hasrestart => true,
  }

  exec { "${instance}-varnish safe reload" :
    command     => "/usr/share/varnish/reload_vcl -f ${main_vcl}",
    refreshonly => true,
  }

  # Setup resource ordering
  case $ensure {
    # For purged resources, need to stop the service before removing files
    'purged' : {
      Service["${instance}-varnish"]
        -> Service["${instance}-varnishlog"]
        -> Service["${instance}-varnishncsa"]
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
        -> Service["${instance}-varnish"]

      # vmods and vcl confs should do a safe reload
      Class[varnish]
        -> Package <| tag == 'varnish-vmod' |>
        -> File[$main_vcl]
        -> File[$subs_vcl]
        ~> Exec["${instance}-varnish safe reload"]

      Class[varnish]
        -> File[$log_daemon_conf]
        -> File[$log_service_conf]
        ~> Service["${instance}-varnishlog"]

      Class[varnish]
        -> File[$ncsa_log_daemon_conf]
        -> File[$ncsa_log_service_conf]
        ~> Service["${instance}-varnishncsa"]
    }
  }
}
