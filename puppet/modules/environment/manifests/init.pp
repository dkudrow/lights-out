# puppet/modules/environment/manifests/init.pp

class environment {
	file { '/etc/profile.d/eucalyptus.sh' :
		source => 'puppet:///modules/environment/files/eucalyptus.sh',
		mode   => 0644
	}
}
