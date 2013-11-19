# == Class: varnish
#
# This is the default class for varnish. It install the necessary varnish
# package and any additional support files. The main work is done in the
# varnish::instance resource.
#
class varnish (
) inherits varnish::params {

  # validate parameters here

  anchor { 'varnish::begin': } ->
  class { 'varnish::repo': } ->
  class { 'varnish::install': } ->
  class { 'varnish::config': }
  class { 'varnish::service': } ->
  anchor { 'varnish::end': }

  Anchor['varnish::begin']  ~> Class['varnish::service']
  Class['varnish::install'] ~> Class['varnish::service']
  Class['varnish::config']  ~> Class['varnish::service']
}
