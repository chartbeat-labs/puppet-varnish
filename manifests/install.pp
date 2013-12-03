# == Class varnish::install
#
# This class is called from varnish. It installs necessary packages. It will
# fail if called on it's own.
#
class varnish::install {

  $packages = $::varnish::packages
  $ensure = $::varnish::package_ensure

  package { $packages :
    ensure => $ensure,
    tag    => 'varnish-install',
  }
}
