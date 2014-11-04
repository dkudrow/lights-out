# puppet/manifests/site.pp

$NETWORK = '10.50.10.0'
$NETMASK = '255.255.255.0'
$IPADDR = '10.50.10.50'

$EUCALYPTUS_SRC = '/home/opt/eucalyptus'
$EUCALYPTUS = '/home/opt/euca4.0'

$EUCA_TAG = 'v4.0.2'

node 'oz.cs.ucsb.edu' {
	$HWADDR = '00:26:B9:3D:16:D2'
	$UUID = '99bb00f0-df2b-437b-9b35-1399c3be2ab2'

	include network
	include environment
	include eucalyptus
	include packages
}

