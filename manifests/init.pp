# == Class: varnish
#
# Full description of class varnish here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class varnish (
) inherits varnish::params {

  # validate parameters here

  anchor { 'varnish::begin': } ->
  class { 'varnish::install': } ->
  class { 'varnish::config': }
  class { 'varnish::service': } ->
  anchor { 'varnish::end': }

  Anchor['varnish::begin']  ~> Class['varnish::service']
  Class['varnish::install'] ~> Class['varnish::service']
  Class['varnish::config']  ~> Class['varnish::service']
}
