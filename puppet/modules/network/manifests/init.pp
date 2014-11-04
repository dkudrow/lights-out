# puppet/modules/network/manifests/init.pp

class network {

	$HWADDR=00:26:B9:3D:16:D2
	$UUID=99bb00f0-df2b-437b-9b35-1399c3be2ab2

	$NETWORK=10.50.10.0
	$NETMASK=255.255.255.0
	$IPADDR=10.50.10.50

	file { '/etc/sysconfig/network-scripts/ifcfg-br0' :
		source => 'puppet:///modules/network/ifcfg-br0',
		mode   => 0644
	}

	file { '/etc/sysconfig/network-scripts/ifcfg-eth1' :
		content = template('network/ifcfg-eth1.erb'),
		mode   => 0644
	}

	service { 'ntpd' :
		requires => Package[ 'ntp' ],
		ensure   => 'running',
		enable   => 'true'
	}

	# hackosaurus rex
	exec {
		command => "/bin/echo 'ifup br0' >> /etc/rc.local",
		unless  => "/bin/grep 'ifup br0' /etc/rc.local"
	}
}
