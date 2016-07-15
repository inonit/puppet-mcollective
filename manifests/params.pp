class mcollective::params {

  $rabbitmq_password  = hiera('mcollective::rabbitmq_password', undef)
  $psk                = hiera('mcollective::psk', undef)

}
