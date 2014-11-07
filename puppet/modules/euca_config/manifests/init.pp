# modules/euca_config/manifests/init.pp

class euca_config {

  user { 'eucalyptus' :
	  ensure => 'present'
  }

  file { "$EUCALYPTUS/etc/eucalyptus/eucalyptus.conf" :
	  content => template('euca_config/eucalyptus.conf.erb'),
  }

  file { "$EUCA_BASE/db" :
	  ensure => 'directory',
	  owner  => 'eucalyptus'
  }

  file { "$EUCALYPTUS/db" :
	  ensure => 'link',
	  target => "$EUCA_BASE/db",
  }

  file { "$EUCA_BASE/bukkits" :
	  ensure => 'directory',
	  owner  => 'eucalyptus'
  }

  file { "$EUCALYPTUS/bukkits" :
	  ensure => 'link',
	  target => "$EUCA_BASE/bukkits",
  }

  file { "$EUCA_BASE/volumes" :
	  ensure => 'directory',
	  owner  => 'eucalyptus'
  }

  file { "$EUCALYPTUS/volumes" :
	  ensure => 'link',
	  target => "$EUCA_BASE/volumes",
  }
}
