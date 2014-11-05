# puppet/manifests/site.pp

$NETWORK = '10.50.10.0'
$NETMASK = '255.255.255.0'
$IPADDR = '10.50.10.50'

$EUCA_BASE = '/home/opt'
$EUCALYPTUS_SRC = "$EUCA_BASE/eucalyptus"
$EUCALYPTUS = "$EUCA_BASE/euca4.0"
$AXIS2C_HOME = "$EUCALYPTUS/packages/axis2c-1.6.0"
$LD_LIBRARY_PATH = "$EUCALYPTUS/packages/axis2c-1.6.0/lib/:$EUCALYPTUS/packages/axis2c-1.6.0/modules/rampart/"

$EUCA_TAG = 'v4.0.2'

File {
  owner => 'root',
  group => 'root'
}

Exec {
  path => "$path"
}

node 'oz.cs.ucsb.edu' {
  $HWADDR = '00:26:B9:3D:16:D2'
  $UUID = '99bb00f0-df2b-437b-9b35-1399c3be2ab2'

  include network
  include environment
  include eucalyptus
  include packages
}

