# == Class varnish::params
#
# This class is meant to be called from varnish
# It sets variables according to platform
#
class varnish::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'varnish'
      $package_ensure = 'present'
      $service_name = 'varnish'
      $vmod_dependencies = ['build-essential', 'dpkg-dev', 'libtool',
                            'pkg-config', 'libpcre3-dev', 'git']
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
