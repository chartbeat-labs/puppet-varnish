# == Class varnish::repo
#
# This class is called from varnish. It ensures the varnish apt repo is
# installed. It will fail if called on it's own.
#
class varnish::repo {
  include apt

  apt::source { 'varnish-cache':
    location    => $::varnish::apt_location,
    release     => $::lsbdistcodename,
    repos       => $::varnish::apt_repos,
    key         => {
      'id'      => $::varnish::apt_key,
      'source'  => $::varnish::apt_key_source,
    },
    include => {
      'deb' => 'true',
      'src' => $::varnish::apt_include_src,
    },
  }
}
