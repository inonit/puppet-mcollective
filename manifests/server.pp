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
class mcollective::server (

  $rabbitmq_password  = $mcollective::params::rabbitmq_password,
  $psk                = $mcollective::params::psk

) inherits mcollective::params {

  file {
    '/etc/puppetlabs/mcollective/server.cfg':
      ensure  => present,
      content => epp('mcollective/server.epp', {
        'rabbitmq_password' => $rabbitmq_password,
        'psk'               => $psk
      }),
      notify  => Service['mcollective'],
      mode    => '0440',
      owner   => root,
      group   => root;

    '/opt/puppetlabs/mcollective/plugins/mcollective':
      ensure  => directory,
      source  => 'puppet:///modules/mcollective/plugins',
      recurse => true,
      notify  => Service['mcollective'],
  }

  service {
    'mcollective':
      ensure     => running,
      hasrestart => true,
      hasstatus  => true,
      subscribe  => File['/etc/puppetlabs/mcollective/server.cfg'],
  }

  cron {
    'mcollective_update_facts':
      command => '/opt/puppetlabs/bin/facter -y > /etc/puppetlabs/mcollective/facts.yaml',
      user    => root,
      minute  => '*/10'
  }

  package {
    'net-ping':
      ensure   => installed,
      provider => puppet_gem,
  }
}
