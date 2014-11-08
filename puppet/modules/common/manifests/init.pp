# modules/common/manifests/init.pp

class common {

  user { 'eucalyptus' :
    ensure => 'present'
  }

  file { "$EUCA_BASE" :
    ensure => 'directory'
  }

  file { "$EUCALYPTUS" :
    ensure  => 'directory',
  }

}
