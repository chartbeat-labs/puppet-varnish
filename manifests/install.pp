# == Class varnish::install
#
class varnish::install(
  $packages = hiera('varnish::packages', $varnish::params::packages),
  $ensure = hiera('varnish::package_ensure', $varnish::params::package_ensure),
) inherits varnish::params {

  package { $packages :
    ensure => $ensure,
    tag    => 'varnish-install',
  }
}
