# puppet/modules/packages/manifests/init.pp

class packages {

  $repos = [ 'elrepo-release', 'epel-release' ]

  $pkgs_nogpg = [

    'axis2-adb', 'axis2-adb-codegen', 'axis2-codegen',
    'axis2c-devel', 'postgresql91', 'postgresql91-server',
    'axis2c'

  ]

  $pkgs = [

    'ntp', 'httpd-devel', 'ant', 'ant-nodeps', 'libcurl-devel',
    'gawk', 'git', 'java-1.6.0-openjdk-devel', 'gcc', 'make', 'apache-ivy',
    'bridge-utils', 'coreutils', 'curl', 'dejavu-serif-fonts',
    'device-mapper', 'dhcp', 'kmod-drbd83', 'drbd83-utils', 'e2fsprogs',
    'euca2ools', 'file', 'httpd', 'iptables', 'iscsi-initiator-utils',
    'java-1.7.0-openjdk', 'java-1.7.0-openjdk-devel', 'jpackage-utils',
    'PyGreSQL', 'libcurl', 'libvirt', 'libvirt-devel', 'libxml2-devel',
    'libxslt-devel', 'lvm2', 'm2crypto', 'openssl-devel', 'parted',
    'patch', 'perl-Crypt-OpenSSL-RSA', 'perl-Crypt-OpenSSL-Random',
    'python-boto', 'python-devel', 'python-setuptools', 'rampartc',
    'rampartc-devel', 'rsync', 'scsi-target-utils', 'sudo', 'swig',
    'util-linux-ng', 'vconfig', 'velocity', 'vtun', 'wget', 'which',
    'xalan-j2-xsltc', 'ipset', 'ebtables', 'bc'

  ]

  package { $repos :
    ensure => 'present',
    before => [ Package[ $pkgs ], Package[ $pkgs_nogpg ] ]
  }

  yumrepo { 'eucalyptus' :
    enabled  => 1,
    baseurl  => 'http://downloads.eucalyptus.com/software/eucalyptus/build-deps/3.4/rhel/$releasever/$basearch',
    descr    => 'Eucalyptus build dependencies',
    before => [ Package[ $pkgs ], Package[ $pkgs_nogpg ] ]
  }

  package { $pkgs :
    ensure  => 'present',
  }

  package { $pkgs_nogpg :
    ensure          => 'present',
    install_options => [ '--nogpgcheck' ],
  }
}
