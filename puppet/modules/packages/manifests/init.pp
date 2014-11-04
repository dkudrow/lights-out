# puppet/modules/packages/manifests/init.pp

class packages {

	$pkgs_nogpg = [

		'axis2-adb', 'axis2-adb-codegen', 'axis2-codegen',
		'axis2c-devel', 'postgresql91', 'postgresql91-server',
		'axis2c'

	]

	$pkgs = [

		'ntp', 'httpd-devel', 'ant', 'ant-nodeps', 'curl-devel',
		'gawk', 'git', 'java-1.6.0-openjdk-devel', 'gcc', 'make',
		'apache-ivy', 'bitstream-vera-fonts', 'bridge-utils',
		'coreutils', 'curl', 'dejavu-serif-fonts', 'device-mapper',
		'dhcp', 'drbd83', 'drbd83-kmod', 'drbd83-utils',
		'e2fsprogs', 'euca2ools', 'file', 'httpd', 'iptables',
		'iscsi-initiator-utils', 'java', 'java-1.7.0-openjdk',
		'java-1.7.0-openjdk-devel', 'java-devel', 'jpackage-utils',
		'kvm', 'PyGreSQL', 'libcurl', 'libvirt', 'libvirt-devel',
		'libxml2-devel', 'libxslt-devel', 'lvm2', 'm2crypto',
		'openssl-devel', 'parted', 'patch',
		'perl-Crypt-OpenSSL-RSA', 'perl-Crypt-OpenSSL-Random',
		'python-boto', 'python-devel', 'python-setuptools',
		'rampartc', 'rampartc-devel', 'rsync', 'scsi-target-utils',
		'sudo', 'swig', 'util-linux', 'vconfig', 'velocity',
		'vtun', 'wget', 'which', 'xalan-j2-xsltc', 'ipset',
		'ebtables', 'bc'

	]

	file { '/etc/yum.repos.d/eucalyptus.repo' :
		source => 'puppet:///modules/packages/eucalyptus.repo',
		mode   => 0644
	}

	package { $pkgs :
		ensure => 'present'
	}

	package { $pkgs_nogpg :
		ensure          => 'present',
		install_options => [ '--nogpgcheck' ]
	}
}
