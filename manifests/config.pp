# == Class varnish::config
#
# This class is called from varnish. It installs any necessary support files for
# varnish.
#
class varnish::config {
  include varnish::params

  file { '/usr/share/varnish/reload-vcl':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
    source => 'puppet:///modules/varnish/reload-vcl',
  }
}
