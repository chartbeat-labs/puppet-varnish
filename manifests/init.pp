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
# [*apt_location*]
#   The location of the varnish apt repository
#
# [*apt_repos*]
#   The repo names to use. If multiple, space separated string.
#
# [*apt_key*]
#   The public apt key of the repo.
#
# [*apt_key_source*]
#   A url key source for the apt key.
#
# [*apt_include_src*]
#   Whether to include the apt source.
#
class varnish (
  $packages = hiera('varnish::packages', $varnish::params::packages),
  $package_ensure = hiera('varnish::package_ensure',
                          $varnish::params::package_ensure),
  $apt_location = hiera('varnish::apt_location',
                        $varnish::params::apt_location),
  $apt_repos = hiera('varnish::apt_repos',
                      $varnish::params::apt_repos),
  $apt_key = hiera('varnish::apt_key', $varnish::params::apt_key),
  $apt_key_source = hiera('varnish::key_source',
                          $varnish::params::apt_key_source),
  $apt_include_src = hiera('varnish::apt_include_src', true),
) inherits varnish::params {

  # validate parameters here

  anchor { 'varnish::begin': } ->
  class { 'varnish::repo': } ->
  class { 'varnish::install': } ->
  class { 'varnish::config': } ->
  class { 'varnish::service': } ->
  anchor { 'varnish::end': }

  Anchor['varnish::begin']  ~> Class['varnish::service']
  Class['varnish::install'] ~> Class['varnish::service']
  Class['varnish::config']  ~> Class['varnish::service']
}
