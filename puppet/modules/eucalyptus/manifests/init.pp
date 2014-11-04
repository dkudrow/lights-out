# modules/eucalyptus/manifests/init.pp

class eucalyptus {

	file { '/home/opt/', '/home/opt/euca4.0' :
		ensure => 'directory'
	}
}
