class mcollective::params {

  $rabbitmq_password = hiera('profiles::rabbitmq::users.mcollective.password')
}
