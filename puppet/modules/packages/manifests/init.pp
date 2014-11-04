# puppet/modules/packages/manifests/init.pp

class packages {

	$misc_pkgs = [
		'ntp', 'bridge-utils', 'git'
	]

	$build_pkgs_nogpg = [
		'apache-ivy', 'axis2-adb', 'axis2-adb-codegen', 'axis2c-devel',
		'axis2-codegen', 'axis2c-devel'

	]

	$build_pkgs = [
		'ant', 'ant-nodeps', 'curl-devel', 'gawk', 'git',
		'java-1.6.0-openjdk-devel', 'java-1.7.0-openjdk-devel',
		'jpackage-utils', 'libvirt-devel', 'libxml2-devel',
		'libxslt-devel', 'm2crypto', 'openssl-devel', 'python-devel',
		'python-setuptools', 'rampartc-devel', 'swig', 'xalan-j2-xsltc'
	]


	$run_pkgs = [
		'gcc', 'make', 'ant', 'ant-nodeps', 'apache-ivy',
		'axis2-adb-codegen', 'axis2-codegen', 'axis2c', 'axis2c-devel',
		'bitstream-vera-fonts', 'bridge-utils', 'coreutils', 'curl',
		'curl-devel', 'dejavu-serif-fonts', 'device-mapper', 'dhcp',
		'drbd83', 'drbd83-kmod', 'drbd83-utils', 'e2fsprogs', 'euca2ools',
		'file', 'gawk', 'httpd', 'iptables', 'iscsi-initiator-utils',
		'java', 'java-1.7.0-openjdk', 'java-1.7.0-openjdk-devel',
		'java-devel', 'jpackage-utils', 'kvm', 'PyGreSQL', 'libcurl',
		'libvirt', 'libvirt-devel', 'libxml2-devel', 'libxslt-devel',
		'lvm2', 'm2crypto', 'openssl-devel', 'parted', 'patch',
		'perl-Crypt-OpenSSL-RSA', 'perl-Crypt-OpenSSL-Random',
		'postgresql91', 'postgresql91-server', 'python-boto',
		'python-devel', 'python-setuptools', 'rampartc', 'rampartc-devel',
		'rsync', 'scsi-target-utils', 'sudo', 'swig', 'util-linux',
		'vconfig', 'velocity', 'vtun', 'wget', 'which', 'xalan-j2-xsltc',
		'ipset', 'ebtables', 'bc'
	]

	file { '/etc/yum.repos.d/eucalyptus.repo' :
		source => 'puppet:///modules/packages/eucalyptus.repo',
		mode   => 0644
	}

	package { $misc_pkgs :
		ensure => 'present'
	}

	package { $build_pkgs :
		ensure => 'present'
	}

	package { $run_pkgs :
		ensure => 'present'
	}

	package { $build_pkgs_nogpg :
		ensure          => 'present'
		install_options => [ '--nogpgcheck' ]
	}
}
