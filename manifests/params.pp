# == Class varnish::params
#
# This class is meant to be called from varnish
# It sets variables according to platform
#
class varnish::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'varnish'
      $service_name = 'varnish'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
