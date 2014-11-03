#!/bin/bash -x

USER=dkudrow
NODES=(oz objc scala)
EUCA_REPO=/etc/yum.repos.d/eucalyptus
EUCA_PROFILE=/etc/profile.d/euca.sh
EUCA_BR=br0
EUCA_ETH=eth1
EUCA_NET=10.50.10.0
EUCA_MASK=255.255.255.0
NODE_IP=${1:-10.50.10.50}

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
#export JAVA_HOME="java-1.7.0-openjdk-1.7.0.71.x86_64"
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

# 9. Install git
yum -y install git

# 10. Clone the repo
mkdir -p /home/opt/
cd /home/opt
git clone --recursive https://github.com/eucalyptus/eucalyptus.git
git checkout v4.0.1

#11. Make the target directory
mkdir -p $EUCALYPTUS

# 12. Install eucalyptus-src-deps
cd $EUCALYPTUS_SRC
wget http://www.cs.ucsb.edu/~rich/eucalyptus-src-deps-circa4.0.tgz
tar xzvf eucalyptus-src-deps # TODO add to google doc
mkdir -p $EUCALYPTUS/packages
yum -y install httpd-devel
ln -s /usr/include/httpd /usr/include/apache2

# FIXME TODO COMBAK XXX: these packages are in the eucalyptus repo
#yum -y install axis2 axis2c-devel

# 13. Install axis2, axis2c, and rampart
cd $EUCALYPTUS/packages
tar zxvf $EUCALYPTUS_SRC/eucalyptus-src-deps/axis2-1.4.tgz
cd $EUCALYPTUS_SRC/eucalyptus-src-deps/
tar zvxf axis2c-src-1.6.0.tar.gz
tar zvxf rampartc-src-1.3.0-0euca2.tar.gz

# 14. Install build dependencies
yum -y groupinstall development

yum -y install ant ant-nodeps apache-ivy  curl-devel gawk \
git java-1.6.0-openjdk-devel java-1.7.0-openjdk-devel jpackage-utils \
libvirt-devel libxml2-devel libxslt-devel m2crypto openssl-devel \
python-devel python-setuptools rampartc-devel swig xalan-j2-xsltc
yum -y install --nogpgcheck axis2-adb axis2-adb-codegen axis2c-devel axis2-codegen axis2c-devel

# 15. Install Postgres
yum -y install \
http://yum.pgrpms.org/9.1/redhat/rhel-6-x86_64/pgdg-centos91-9.1-4.noarch.rpm
yum install -y --nogpgcheck postgresql91 postgresql91-server

# 16. Install runtime dependencies
yum -y install gcc make ant ant-nodeps apache-ivy axis2-adb-codegen \
axis2-codegen axis2c axis2c-devel bitstream-vera-fonts bridge-utils \
coreutils curl curl-devel  dejavu-serif-fonts device-mapper dhcp41 \
dhcp41-common e2fsprogs euca2ools file gawk httpd iptables \
iscsi-initiator-utils java java-1.7.0-openjdk java-1.7.0-openjdk-devel \
java-devel jpackage-utils kvm PyGreSQL libcurl libvirt libvirt-devel \
libxml2-devel libxslt-devel lvm2 m2crypto openssl-devel parted patch \
perl-Crypt-OpenSSL-RSA perl-Crypt-OpenSSL-Random postgresql91 \
postgresql91-server python-boto python-devel python-setuptools rampartc \
rampartc-devel rsync scsi-target-utils sudo swig util-linux vconfig \
velocity vtun wget which xalan-j2-xsltc ipset ebtables bc

# 17. Install euca2-tools
yum -y install \
http://downloads.eucalyptus.com/software/euca2ools/2.1/rhel/6/x86_64/epel-release-6.noarch.rpm
yum -y install \
http://downloads.eucalyptus.com/software/euca2ools/3.0/rhel/6/x86_64/euca2ools-release-3.0.noarch.rpm
yum -y install euca2ools
yum -y install python-boto

<<EOF
# 20a. Build axis2
cd $EUCALYPTUS_SRC/eucalyptus-src-deps/axis2c-src-1.6.0
CFLAGS="-w" ./configure --prefix=${AXIS2C_HOME} \
--with-apache2=$APACHE_INCLUDES --with-apr=$APR_INCLUDES \
--enable-multi-thread=no
make all; make install

# 20b. Build axis2c
cd $EUCALYPTUS_SRC/eucalyptus-src-deps/axis2c-src-1.6.0
CFLAGS="-w" ./configure --prefix=${AXIS2C_HOME} \
--with-apache2=$APACHE_INCLUDES --with-apr=$APR_INCLUDES \
--enable-multi-thread=no
make all; make install

# 20c. Build rampartc
cd $EUCALYPTUS_SRC/eucalyptus-src-deps/rampartc-src-1.3.0
./configure --prefix=${AXIS2C_HOME} --enable-static=no \
--with-axis2=${AXIS2C_HOME}/include/axis2-1.6.0
make; make install
sed -i 's/<!--phase name="Security"-->/<phase name="Security">/' $AXIS2C_HOME/axis2.xml
EOF

# 21. Install Eucalyptus
cd $EUCALYPTUS_SRC
make clean
./configure --with-axis2=$EUCALYPTUS/packages/axis2-1.4 \
--with-axis2c=$EUCALYPTUS/packages/axis2c-1.6.0 --enable-debug \
--prefix=$EUCALYPTUS --with-db-home=/usr/lib/postgresql/9.1 \
--with-wsdl2c-sh=${AXIS2C_HOME}/bin/tools/wsdl2c/WSDL2C.sh
make all; make install

# 22. Add Eucalyptus user
useradd eucalyptus

# 23
