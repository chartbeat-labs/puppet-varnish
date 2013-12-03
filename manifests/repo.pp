# == Class varnish::repo
#
# This class is called from varnish. It ensures the varnish apt repo is
# installed.
#
class varnish::repo(
  $location = hiera('varnish::apt_location', $varnish::params::apt_location),
  $repos = hiera('varnish::apt_repos', $varnish::params::apt_repos),
  $key = hiera('varnish::apt_key', $varnish::params::apt_key),
  $key_source = hiera('varnish::key_source', $varnish::params::apt_key_source),
  $include_src = hiera('varnish::apt_include_src', true),
) inherits varnish::params {

  include apt

  apt::source { 'varnish-cache':
    location    => $location,
    release     => $::lsbdistcodename,
    repos       => $repos,
    key         => $key,
    key_source  => $key_source,
    include_src => $include_src,
  }
}
