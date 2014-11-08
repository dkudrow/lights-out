# manifests/site.pp

# network
$NETWORK = '10.50.10.0'
$NETMASK = '255.255.255.0'
$IPADDR = '10.50.10.50'

# euca_build
$EUCA_BASE = '/home/opt'
$EUCALYPTUS_SRC = "$EUCA_BASE/eucalyptus"
$EUCA_TAG = 'v4.0.2'
$EUCALYPTUS = "$EUCA_BASE/euca4.0"
$AXIS2C_HOME = "/usr/lib64/axis2c"
$LD_LIBRARY_PATH = "$EUCALYPTUS/packages/axis2c-1.6.0/lib/:$EUCALYPTUS/packages/axis2c-1.6.0/modules/rampart/"

# euca_config
$CLOUD_OPTS = '--db-home=/usr/pgsql-9.1/ --java-home=/usr/lib/jvm/java-1.7.0'
$LOGLEVEL = 'DEBUG'
$HYPERVISOR = 'kvm'
$VNET_MODE = 'MANAGED-NOVLAN'
$VNET_PRIVINTERFACE = 'br0'
$VNET_PUBLICIPS = '...'
$VNET_DNS = '128.111.41.10'

File {
  owner => 'root',
  group => 'root'
}

Exec {
  path => "$path"
}

node 'common' {
  include packages
  include network
  include common
}

node 'oz.cs.ucsb.edu' inherits 'common' {
  $HWADDR = '00:26:B9:3D:16:D2'
  $UUID = '99bb00f0-df2b-437b-9b35-1399c3be2ab2'

  include head
}

node 'objc.cs.ucsb.edu' inherits 'common' {
  $HWADDR = '00:26:B9:3D:16:D8'
  $UUID = '2755b147-5f3a-4dd8-b408-df050c283421'

  include nc
}
