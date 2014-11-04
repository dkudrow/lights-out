# modules/eucalyptus/manifests/init.pp

class eucalyptus {

	user { 'eucalyptus' :
	}

	file { '/usr/include/apache2' :
		ensure  => 'link',
		target  => '/usr/include/httpd',
		require => Package[ 'httpd' ]
	}

	file { [ '/home/opt/', '/home/opt/euca4.0' ] :
		ensure => 'directory'
	}

	vcsrepo { "$EUCALYPTUS_SRC" :
		ensure   => 'present',
		provider => 'git',
		source   => 'https://github.com/eucalyptus/eucalyptus.git',
		revision => "$EUCA_TAG"
	}
}
