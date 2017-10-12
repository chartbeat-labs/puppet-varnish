# == Class: varnish
#
# This is the default class for varnish. It install the necessary varnish
# package and any additional support files. The main work is done in the
# varnish::instance resource.
#
# === Parameters
#
# [*packages*]
#   The packages to install. Can be specified manually or use hiera.
#
# [*package_ensure*]
#   You can ensure a specific package version here, defaults to 'present'.
#
class varnish (
  $packages = hiera('varnish::packages', $varnish::params::packages),
  $package_ensure = hiera('varnish::package_ensure',
                          $varnish::params::package_ensure),
) inherits varnish::params {

  # validate parameters here

  anchor { 'varnish::begin': } ->
  class { 'varnish::install': } ->
  class { 'varnish::config': } ->
  class { 'varnish::service': } ->
  anchor { 'varnish::end': }

  Anchor['varnish::begin']  ~> Class['varnish::service']
  Class['varnish::install'] ~> Class['varnish::service']
  Class['varnish::config']  ~> Class['varnish::service']
}
