# == Class varnish::params
#
# This class is meant to be called from varnish
# It sets variables according to platform
#
class varnish::params {
  case $::osfamily {
    'Debian': {
      $packages = ['varnish','libvarnishapi1']
      $package_ensure = 'present'
      $service_name = 'varnish'
      $vmod_dependencies = ['build-essential', 'dpkg-dev', 'libtool',
                            'pkg-config', 'libpcre3-dev', 'git-core']
      $apt_location = 'http://repo.varnish-cache.org/debian/'
      $apt_repos = 'varnish-3.0'
      $apt_key = 'E98C6BBBA1CBC5C3EB2DF21C60E7C096C4DEFFEB'
      $apt_key_source = 'http://repo.varnish-cache.org/debian/GPG-key.txt'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
