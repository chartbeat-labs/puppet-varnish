# == Class varnish::repo
#
# This class is called from varnish. It ensures the varnish apt repo is
# installed.
#
class varnish::repo {
  include varnish::params
  include apt

  apt::source { 'varnish-cache':
    location    => $varnish::params::apt_location,
    release     => $::lsbdistcodename,
    repos       => $varnish::params::apt_repos,
    key         => $varnish::params::apt_key,
    key_source  => $varnish::params::apt_key_source,
    include_src => true,
  }
}
