# puppet/modules/environment/manifests/init.pp

class environment {
	file { '/etc/profile.d/eucalyptus.sh' :
		content => template('environment/eucalyptus.sh.erb'),
		mode   => 0644
	}
}
