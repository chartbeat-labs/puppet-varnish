# == Class varnish::service
#
# This class is meant to be called from varnish It ensure the service is stopped
# since we manage varnish instances from the varnish::instance resource.
#
class varnish::service {
  include varnish::params

  service { $varnish::params::service_name:
    ensure     => stopped,
    enable     => false,
    hasstatus  => true,
    hasrestart => true,
  }
}
