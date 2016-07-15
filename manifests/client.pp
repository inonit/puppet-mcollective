# == Class: mcollective
#
# This class is simple, but well begunm. None of the forge modules
# work well with puppet4 and rabbitmq and ssl.
#
# === Parameters
#
# Document parameters here.
#
# [*rabbitmq_password*, string]
#   password to used to authenticate to rabbitmq. A string.
#
# === Examples
#
#  class { 'mcollective':
#    rabbitmq_password => '$fubar',
#  }
#
# === Authors
#
# Lars Bahner <lars.bahner@gmail.com>
#
# === Copyright
#
# Copyright 2016 Inonit AS
#
class mcollective::client (

  $rabbitmq_password  = $mcollective::params::rabbitmq_password,
  $psk                = $mcollective::params::psk

) inherits mcollective::params {

  file {
    '/etc/puppetlabs/mcollective/client.cfg':
      ensure  => present,
      content => epp('mcollective/client.epp', {
        'rabbitmq_password' => $rabbitmq_password,
        'psk'               => $psk
      }),
      mode    => '0440',
      owner   => root,
      group   => root,
  }
}
