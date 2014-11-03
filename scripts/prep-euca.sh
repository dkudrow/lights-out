#!/bin/bash -x

USER=dkudrow
NODES=(oz objc scala)
EUCA_REPO=/etc/yum.repos.d/eucalyptus
EUCA_PROFILE=/etc/profile.d/euca.sh
EUCA_BR=br0
EUCA_ETH=eth1
NETWORK=10.50.10.0
NETMASK=255.255.255.0
IPADDR=10.50.10.50

######################################################################
#
# Miscellaneous configuration
#
######################################################################

# Disable SELinux
sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config

# Disable iptables
service iptables stop
chkconfig iptables off

## Add Eucalyptus repo
#if [[ -e $EUCA_REPO ]]; then
	#cat >$EUCA_REPO <<EOF
	#[eucalyptus]
	#name=Eucalpytus
	#baseurl=http://downloads.eucalyptus.com/software/eucalyptus/build-deps/3.4/rhel/$releasever/$basearch
#EOF

######################################################################
#
# From the Google Doc (in order)
#
######################################################################

# 1. SSH access across all nodes
# FIXME: I probably don't work as intended
for node in "${NODES[@]}"; do
	ssh-copy-id $USER@$node
done

# 2. Sync time
yum -y install ntp
ntpdate $NTP_SERVER
service ntpd start
chkconfig ntpd on

# 3. Environment setup
cat >$EUCA_PROFILE <<"EOF"
export EUCALYPTUS_SRC=/home/opt/eucalyptus
export EUCALYPTUS=/home/opt/euca4.0
export JAVA_HOME="/usr/lib/jvm/java-1.7.0"
export JAVA="$JAVA_HOME/bin/java"
export PATH=$JAVA_HOME/bin:$EUCALYPTUS/usr/sbin:$PATH
export AXIS2C_HOME=$EUCALYPTUS/packages/axis2c-1.6.0
export LD_LIBRARY_PATH=$EUCALYPTUS/packages/axis2c-1.6.0/lib/:$EUCALYPTUS/packages/axis2c-1.6.0/modules/rampart/
export APACHE_INCLUDES=/usr/include/apache2
export APR_INCLUDES=/usr/include/apr-1
EOF
source $EUCA_PROFILE

# 4. Update CentOS
yum -y update

# 5. Set up the Ethernet interface
yum -y install bridge-utils
sed -i '/BRIDGE=.*/d' /etc/sysconfig/network-scripts/ifcfg-$EUCA_ETH
sed -i '/ONBOOT=.*/d' /etc/sysconfig/network-scripts/ifcfg-$EUCA_ETH
sed -i '/NM_CONTROLLED=.*/d' /etc/sysconfig/network-scripts/ifcfg-$EUCA_ETH
sed -i '/BOOTPROTO=.*/d' /etc/sysconfig/network-scripts/ifcfg-$EUCA_ETH
cat >>/etc/sysconfig/network-scripts/ifcfg-$EUCA_ETH <<EOF
BRIDGE=br0
ONBOOT=yes
NM_CONTROLLED=no
BOOTPROTO=none
EOF

# 6. Set up the bridge interface
cat >/etc/sysconfig/network-scripts/ifcfg-$EUCA_BR <<EOF
DEVICE=br0
TYPE=BRIDGE
ONBOOT=yes
NM_CONTROLLED=no
BOOTPROTO=static
NETWORK=$EUCA_NET
NETMASK=$EUCA_MASK
IPADDR=$NODE_IP
EOF

# 7. Stand up the bridge at boot
sed -i "/ifup $EUCA_BR/d" /etc/rc.local
echo "ifup $EUCA_BR" >> /etc/rc.local
