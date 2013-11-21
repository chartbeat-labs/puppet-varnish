# == Define varnish::vmod
#
# Installs a varnish vmod
#
# === Parameters
#
# [*ensure*]
#   The package state, i.e. present, absent, purged
#
# [*depends*]
#   The list of packages this vmod depends upon
#
define varnish::vmod(
  $ensure = 'present',
  $depends = [],
) {
  require varnish

  ensure_packages($varnish::params::vmod_dependencies)
  ensure_packages($depends)

  package { $name:
    ensure => $ensure
  }

}
