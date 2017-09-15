![ULAKBIM](../img/ulakbim.jpg)
# Ahtapot Projesinde Sistemlere Kurulan Paketler ve Bağımlılıkları
------

[TOC]

------

Bu dokümanda, Ahtapot Projesinde Sistemlere Kurulan Paketler ve Bağımlılıkları anlatılıyor.

### Base Rolü İle Yüklenen Paketler

* Base rolünde yüklenen paketler, MYS kapsamında yönetilen tüm makinalara kurulan ortak paketlerdir.
	* auditd : Loglama yapılması için yüklenmiş pakettir
		* Reverse Depends:

		|Paket Listesi  |                       |
		|---------------|-----------------------|
		|udispd-plugins |libvirt-daemon-system  |


		* Dependencies: 

		|Paket Listesi       |                 |          |         |
		|--------------------|-----------------|----------|---------|
        |init-system-helpers |libgssapi-krb5-2 |gawk      |libwrap0 |
		|libauparse0         |lsb-base         |libaudit1 |mawk     |
		|libc6               |audispd-plugins  |libkrb5-3 |         |

		
	* sysstat : Performans raporlaması için yüklenmiş pakettir
		* Reverse Depends:

		|Paket Listesi             |     |         |        |
		|--------------------------|-----|---------|--------| 
		|plainbox-provider-checkbox|isag |i3blocks |dtc-xen |

		
		* Dependencies: 

		|Paket Listesi |            |            |         |
		|--------------|------------|------------|---------|
		|bzip2         |debconf-2.0 |libc6       |lsb-base |
		|cron          |isag        |libsensors4 |ucf      |
		|debconf       |            |            |         |

		
	* ntp : Zaman senkranizasyonu için yüklenmiş pakettir
		* Reverse Depends:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|openstack-compute-node|fake-hwclock   |lava-dispatcher|aiccu|
		|gnome-system-tools |debci|lava-server|predict|
		|chrony|gnumed-client|mate-system-tools|predict-gsat|
		|bwctl-server|hobbit-plugins|netsniff-ng|radioclk|
		|dms-core|ircd-ratbox|openafs-fileserver|samba|
		|openstack-cloud-services|dovecot-core|openntpd|slony1-2-bin|
		|education-main-server|lava|jffnms|tucnak2|

		
		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|adduser |libc6 |libopts25|ntp-doc |
		|lsb-base |libcap2 |libssl1.0.0 |perl |
		|netbase |libedit2 |dpkg |dhcp3-client| 

		
	* bash : Bash bağımlılığı bulunan uygulmamları için yüklenmiş pakettir
		* Reverse Depends:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|autojump|diffmon|inxi|origami|
		|backupninja|dpatch|kernel-patch-viewos|plowshare4|
		|bash-builtins|emacs-goodies-el|libbash|podget|
		|bash-completion|fadecut|linux-patch-debianlogo|powerline|
		|bash-doc|fiaif|linux-patch-grsecurity2|prey|
		|bashburn|firehol|lrzip|rdup|biabam|
		|foomatic-db-engine|mason|s3dvt|colortest|
		|foomatic-filters|monotone|txt2regex|common-lisp-controller|
		|git-ftp|netscript-2.4|votca-csg-scripts|devscripts-el|
		|gt5|netscript-ipfilter|votca-csg-tutorials||

		
 		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|base-files|bash-doc |debianutils |libtinfo5| 
		|bash-completion |bash-doc|libc6|bash-completion|
		|dash |libncurses5 |||

		
	* rsyslog : Loglama yapılması için yüklenmiş pakettir
		* Reverse Depends:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|anacron|heartbeat|nullmailer|rsyslog-mongodb|
		|apparmor|initscripts|prelude-lml|rsyslog-mysql|
		|approx|ldirectord|psad|rsyslog-pgsql|
		|arno-iptables-firewall|loganalyzer|request-tracker4|rsyslog-relp|
		|auth2db|logcheck|rlinetd|sympa|
		|cloudprint|ltsp-client|rsyslog-elasticsearch|ufw|
		|education-common|ltsp-client-core|rsyslog-gnutls|xinetd|
		|fwlogwatch|lyskom-server|rsyslog-gssapi|xwatch|

		
		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|libc6 |libuuid1|rsyslog-mysql|rsyslog-gssapi| 
		|libestr0|liblogging-stdlog0|rsyslog-pgsql |rsyslog-relp| 
		|libjson-c2|init-system-helpers|liblognorm1|logrotate| 
		|lsb-base|linux-kernel-log-daemon|rsyslog-doc|zlib1g|
		|rsyslog-mongodb |initscripts|rsyslog-gnutls |system-log-daemon| 

		
	* sudo : Kullanıcı yetkilerini düzenleme amaçlı yüklenmiş pakettir.
		* Reverse Depends: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|apt-dater-host|etckeeper|mini-buildd|qemu-user|
		|apt-file|fvwm-crystal|mountpy|qemu-user-static|
		|apt-src|geximon|neutron-dhcp-agent|ranger|
		|neutron-plugin-linuxbridge-agent|gksu|neutron-l3-agent|smb4k|
		|neutron-plugin-nec-agent|gnumed-server|ara|sshuttle|
		|auto-apt|hobbit-plugins|arriero|sudo-ldap|
		|neutron-plugin-openvswitch-agent|inxi|bashburn|sudo-ldap|
		|bundler|kdesudo|ctdb|ubuntu-dev-tools|
		|ldap-account-manager-lamdaemon|lava-dispatcher|pconsole|wajig|
		|python-oslo.rootwrap|pbuilder|piuparts-slave|wicd-cli|
		|drobo-utils|libgksu2-0|python-nova|wicd-curses|
		|dtc-xen|linaro-image-tools|dkms|winetricks|
		|education-standalone|live-config|elida|xara-gtk|
		|python3-oslo.rootwrap|matlab-support|q4wine|xfce4-session|

		
		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|libpam-modules |libc6|libselinux1 |sudo-ldap| 
		|libaudit1|libpam0g|||

		
	* logrotate: Logların belirli periyotlar ile arşivlenmesi için gerekli pakettir
		* Reverse Depends:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|aolserver4-daemon|icecc|prayer|sympa|
		|apt-cacher-ng|ippl|privoxy|syslog-ng-core|
		|argus-server|kdm|pyca|tinyproxy|
		|atftpd|knockd|pygopherd|tor|
		|bareos-director|ldirectord|quagga|twatch|
		|bdii|leafnode|rabbitmq-server|uucp|
		|cacti|libvirt-daemon-system|radosgw|vsftpd|
		|ceph|libzypp|rsnapshot|xinetd|
		|clamav-base|liquidsoap|rsyslog|xtel|
		|clamav-freshclam|logstash|samba|xtide|
		|clamav-milter|logster|sendmail-base|yaws|
		|cricket|mailman|sipwitch|yrmcds|
		|cron|masqmail|sks|zabbix-agent|ctdb|
		|mgetty|slbackup|zabbix-proxy-mysql|cubemap|
		|muddleftpd|slony1-2-bin|zabbix-proxy-pgsql|distributed-net|
		|net-acct|squid3|zabbix-proxy-sqlite3|dsyslog|
		|ninja|sugarplum|zabbix-server-mysql|heartbeat|
		|pawserv|super|zabbix-server-pgsql|heimdal-kdc|
		|postgresql-common||||

		
		* Dependencies:
	
		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|libacl1|libselinux1|cron-daemon|postgresql-common|
		|libc6|cron|base-passwd|mailx|
		|libpopt0|anacron|||

		
	* apt-transport-https: https üzerinden bağlantı gönderimi için kurulan pakettir.
		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|libapt-pkg4.12|libc6|libcurl3-gnutls|libgcc1|
		|libstdc++6||||

		
	* rsyslog-gnutls : Rsyslog üzerinden TLS ile log gönderimi için kurulan pakettir.
		* Reverse Depends:

		|Paket Listesi        |
		|---------------------|
		|rsyslog|

		
		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|libc6|libgnutls-deb0-28|libjson-c2|rsyslog|
		|gnutls-bin||||

		
	* ahtapot-fusioninventory-agent: Açıklık tarama analizi için kullanılacak agentı barındıran pakettir.
		* Dependencies:

		|Paket Listesi                                  |                  |                 |
		|-----------------------------------------------|------------------|-----------------|
		|libfusioninventory-agent-task-netdiscovery-perl|libnet-cups-perl|ucf|
		|ibfusioninventory-agent-task-netinventory-perl|libparse-edid-perl|hdparml|
		|libfusioninventory-agent-task-network-per|libyaml-perl|pciutils|
		|libsocket-getaddrinfo-perl|libjson-perl|smartmontools|
		|libuniversal-require-perl|libhttp-daemon-perl|pciutils|read-edid|
		|libfusioninventory-agent-task-esx-perl|libio-socket-ssl-perl |perl|
		|libfusioninventory-agent-task-deploy-perl|libfile-which-perl|
		|libnet-ip-perl|libproc-daemon-perl|libproc-pid-file-perl|
		|libxml-treepp-perl|libtext-template-perl|libwww-perl|

###Ansible Rolü İle Yüklenen Paketler
			 
* Ansible rolünde yüklenen paketler, MYS kapsamında yönetilen Ansible görevi verilen tüm makinalara kurulan ortak paketlerdir.
	* git : Merkezi Yönetim Sistemine ait playbookların depolanması için kullanılan git adresine erişim yapılması amacı ile yüklenmiş pakettir.
		* Reverse Depends: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|blogofile|git-el|gitweb|phpunit-git|
		|bugs-everywhere|git-email|grokmirror|pkg-perl-tools|
		|buildbot|git-extras|guilt|propellor|
		|bup|git-flow|hg-fast-export|prt|git-dpm|
		|calypso|git-ftp|hobbit-plugins|python-git|
		|commit-patch|git-gui|ikiwiki|python-setuptools-git|
		|dh-make-perl|git-man|ikiwiki-hosting-web|python-vcversioner|
		|dh-ocaml|git-mediawiki|julia|python3-setuptools-git|
		|drush|git-notifier|kdesrc-build|python3-vcversioner|
		|duck|git-reintegrate|kdevplatform8-libs|qgit|
		|etckeeper|git-remote-bzr|keyringer|qtcreator|
		|fdroidserver|git-remote-gcrypt|kgb-bot|rebar|
		|flashbake|git-remote-hg|kup-server|redmine|
		|fusionforge-plugin-scmgit|git-repair|lava-dev|ruby-git|
		|giggle|git-review|lava-dispatcher|ruby-grack|
		|git-all|git-sh|ldap-git-backup|sparkleshare|
		|git-annex|git-svn|libapp-nopaste-perl|sputnik|
		|git-arch|git2cl|libgit-repository-perl|stgit|
		|git-buildpackage|gitg|libgit-wrapper-perl|svn-all-fast-export|
		|git-core|github-backup|magit|tig|
		|git-cvs|gitit|myrepos|ui-auto|
		|git-cvs|gitk|opam|undertaker|
		|git-daemon-run|gitolite3|pass|vcsh|
		|git-daemon-sysvinit|gitpkg|pepper|zim|
		|git-doc|gitstats|php-monolog|zsh-antigen|

		
		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|zlib1g|git-daemon-sysvinit |git-doc |libexpat1 |
		|bash-completion|gitosis|gitpkg|libpcre3|
		|cogito |git-el |gitweb |patch |
		|gettext-base |git-email |gitweb|perl-modules |
		|git-arch |git-gui |gitweb|rsync |
		|git-buildpackage|git-man|guilt|ssh-client |
		|git-core|git-man|less |stgit|
		|git-core|git-mediawiki |libc6|stgit-contrib |
		|git-cvs |libcurl3-gnutls|git-svn |git-daemon-run|
		|gitk |liberror-perl |||

		
	* ansible : Merkezi Yönetim Sistemi, yönetim aracı rolünü üstlendiği için kurulmuş pakettir. 
		* Reverse Depends: 

		|Paket Listesi        |                  |
		|---------------------|------------------|
		|ahtapot-mys|ansible-fireball|

		
		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|python|python-jinja2|python-crypto|sshpass|
		|python|python-yaml|python-httplib2|python-selinux|
		|python-paramiko|python-pkg-resources|ansible-doc|| 

		
	* python-requests : ansible’ın bağımlılık paketi olduğu için yüklenmiş pakettir.
		* Reverse Depends: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|beets|python-ceilometer|python-mandrill|python-socketio-client|
		|cloud-init|python-ceph|python-neutron|python-softlayer|
		|dosage|python-cinder|python-neutronclient|python-sphinxcontrib.issuetracker|
		|encuentro|python-cinderclient|python-nova|python-stdeb|
		|epigrass|python-debiancontributors|python-novaclient|python-subliminal|
		|euca2ools|python-designateclient|python-openstackclient|python-swiftclient|
		|gertty|python-docker|python-pip|python-swiftsc|
		|git-review|python-fedmsg|python-plotly|python-troveclient|
		|httpie|python-fedora|python-pycarddav|python-tuskarclient|
		|lava-dispatcher|python-gcm-client|python-pypump|python-twitter|
		|linkchecker|python-geopy|python-pysaml2|python-weboob|
		|mopidy-beets|python-glance|python-pyvmomi|python-x2go|
		|mopidy-soundcloud|python-glanceclient|python-requestbuilder|python3-responses|
		|nikola|python-guessit|python-requests-kerberos|radicale|python-social-auth|
		|pybit-client|python-heat|python-requests-mock|slapos-client|
		|python-acoustid|python-heatclient|python-requests-oauthlib|ssh-import-id|
		|python-awsauth|python-influxdb|python-responses|streamtuner2|
		|python-barbicanclient|python-jenkinsapi|python-saharaclient|syslog-ng-mod-elasticsearch|
		|python-boto|python-keystoneclient|python-savannaclient|vim-youcompleteme|
		|python-botocore|python-keystonemiddleware|python-seamicroclient|wapiti|
		|python-braintree|python-libturpial|python-smstrade|python-catcher|
		|python-livestreamer||||

		
		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|python:any|ca-certificates|python-urllib3|python-openssl| 
		|python:any|python-chardet|python-ndg-httpsclient|python-pyasn1| 

		
	* rsync: Logların gönderilmesi için yüklenmiş pakettir.
		* Reverse Depends: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|backintime-common|flexbackup|live-tools|rsnapshot|
		|backupninja|gadmin-rsync|lsb-core|rssh|
		|backuppc|git|lsyncd|rsyncrypto|
		|barman|git-annex|luckybackup|simple-cdd|
		|bzrtools|git-remote-gcrypt|lxc|sisu|
		|clamav-unofficial-sigs|git-repair|mrb|slack|
		|clsync|gnumed-server|mrs|subversion-tools|
		|debaux|grml2usb|nanoc|swift-account|
		|debmirror|grsync|opam|swift-container|
		|dirvish|hdup|openssh-known-hosts|swift-object|
		|dms-core|inosync|python-poker-engine|swift-object-expirer|
		|dput|jailtool|python-tomahawk|tailor|
		|duplicity|ksplice|python3-tomahawk|vserver-debiantools|
		|education-common|libfile-rsync-perl|repmgr|vzctl|
		|fdroidserver|libguestfs-rsync|rsbackup|vzdump|
		|flashybrid|live-boot||||

		
		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|libacl1|lsb-base|openssh-client|openssh-server|
		|duplicity|libattr1|base-files|libpopt0|
		|libc6||||

		
###DHCP Rolü İle Yüklenen Paketler

* DHCP rolünde yüklenen paketler, MYS kapsamında yönetilen Dhcp görevi verilen tüm makinalara kurulan ortak paketlerdir.
	* Udhcpd : DHCP servisini kuran pakettir.
		* Reverse Depends: 

		|Paket Listesi        |                  |
		|---------------------|------------------|
		|di-netboot-assistant|dhcp-helper|

		
		* Dependencies:

		|Paket Listesi        |                  |
		|---------------------|------------------|
		|busybox|busybox-static|

		
###ElasticSearch Rolü İle Yüklenen Paketler

* ElasticSearch rolünde yüklenen paketler, MYS kapsamında yönetilen ElasticSearch görevi verilen tüm makinalara kurulan ortak paketlerdir.
	* Oracle-java8 : ElasticSearch için kurulmuş pakettir.
		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|java-common|ttf-sazanami-mincho|xulrunner|openjdk-7-jre-headless|
		|locales|ttf-arphic-uming|xulrunner-1.9|oracle-java7-bin|
		|wget|firefox|konqueror|oracle-java7-fonts|
		|binutils|firefox-2|chromium-browser|oracle-java7-jdk|
		|debconf|iceweasel|midori|oracle-java7-jre|
		|debconf-2.0|mozilla-firefox|google-chrome|oracle-java7-plugin|
		|binfmt-support|iceape-browser|gsfonts-x11|oracle-java8-bin|
		|visualvm|mozilla-browser|j2se-common|oracle-java8-fonts|
		|ttf-baekmuk|epiphany-gecko|icedtea-6-plugin|oracle-java8-jdk|
		|ttf-unfonts|epiphany-webkit|icedtea-7-plugin|oracle-java8-jre|
		|ttf-unfonts-core|epiphany-browser|openjdk-6-jre|oracle-java8-plugin|
		|ttf-kochi-gothic|galeon|openjdk-6-jre-headless|oracle-jdk7-installer|
		|ttf-sazanami-gothic|midbrowser|openjdk-7-jdk|oracle-jdk8-installer|
		|ttf-kochi-mincho|moblin-web-browser|openjdk-7-jre||

		
	* Elasticsearch : ElasticSearch uygulamasını barındıran pakettir.
		* Reverse Depends:

		|Paket Listesi        |
		|---------------------|
		|search-guard-ssl|

		
		* Dependencies:

		|Paket Listesi        |                  |
		|---------------------|------------------|
		|libc6|adduser|

		
	* Search-guard-ssl : Search Guard uygulamasının SSL üzerinden çalışmasını sağlayan pakettir.
		* Reverse Depends:

		|Paket Listesi        |
		|---------------------|
		|search-guard|

		
		* Dependencies:

		|Paket Listesi        |
		|---------------------|
		|elasticsearch|

				
	* Search-guard : Search Guard uygulamasını barındıran pakettir.
		* Dependencies:

		|Paket Listesi        |
		|---------------------|
		|search-guard-ssl|

		
###Firewall Rolü İle Yüklenen Paketler

* Firewall rolünde yüklenen paketler, MYS kapsamında yönetilen Firewall görevi verilen tüm makinalara kurulan ortak paketlerdir.
	* iptables : Güvenlik Duvarı kuralları için yüklenmiş pakettir.
		* Reverse Depends: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|apf-firewall|fwanalog|libxtables10|puppet-module-puppetlabs-firewall|
		|arno-iptables-firewall|fwknop-server|linux-igd|pyroman|
		|collectd|fwsnort|miniupnpd|python-netfilter|
		|collectd-core|heartbeat|mxallowd|shorewall|
		|concordance-common|ipkungfu|netscript-2.4|shorewall-core|
		|dtc-xen-firewall|ipset|netscript-ipfilter|shorewall-lite|
		|ebtables|iptables-dev|network-config|shorewall6|
		|education-main-server|iptables-dev|network-manager|shorewall6-lite|
		|education-thin-client-server|iptables-persistent|nova-compute|sshguard|
		|fail2ban|kvpnc|nova-network|sshuttle|
		|ferm|libiptables-ipv4-ipqueue-perl|olpc-powerd|ufw|
		|fiaif|libpam-shield|p3scan|uif|
		|firehol|libvirt-daemon-system|ppp-gatekeeper|uruk|
		|firewalld|libxtables10|psad|util-vserver|


		* Dependencies:

		|Paket Listesi        |                  |                 |
		|---------------------|------------------|-----------------|
		|libc6|libnfnetlink0|libxtables10|

	* iptables-persistent : Güvenlik Duvarı kuralları için yüklenmiş pakettir.
		* Reverse Depends: 

		|Paket Listesi        |                  |
		|---------------------|------------------|
		|netfilter-persistent|dms-core|

		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|netfilter-persistent|iptables|debconf|debconf-2.0|

	* rsync : Logların belirli periyotlarda merkez sunucuya gönderilmesi için yüklenmiş pakettir.
		* Reverse Depends: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|backintime-common|flexbackup|live-boot|rsnapshot|
		|backupninja|gadmin-rsync|live-tools|rssh|
		|backuppc|git|lsb-core|rsyncrypto|
		|barman|git|lsyncd|simple-cdd|
		|bzrtools|git-annex|luckybackup|sisu|
		|clamav-unofficial-sigs|git-remote-gcrypt|lxc|slack|
		|clsync|git-repair|mrb|subversion-tools|
		|debaux|gnumed-server|mrs|swift-account|
		|debmirror|grml2usb|nanoc|swift-container|
		|dirvish|grsync|opam|swift-object|
		|dms-core|hdup|openssh-known-hosts|swift-object-expirer|
		|dput|inosync|python-poker-engine|tailor|
		|duplicity|jailtool|python-tomahawk|vserver-debiantools|
		|education-common|ksplice|python3-tomahawk|vzctl|
		|fdroidserver|libfile-rsync-perl|repmgr|vzdump|
		|flashybrid|libguestfs-rsync|rsbackup||


		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|libacl1|libattr1|libc6|libpopt0|
		|lsb-base|base-files|openssh-client|openssh-server| 
		|duplicity||||

	* keepalived : Güvenlik Duvarı yedekliliği için yüklenmiş pakettir.
		* Reverse Depends: 

		|Paket Listesi        |                  |
		|---------------------|------------------| 
		|yrmcds|ipvsadm|

		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|iproute|ipvsadm|libc6|libnl-3-200|
		|libnl-genl-3-200|libpci3|libsensors4|ibsnmp30|
		|libssl1.0.0|libwrap0|||

	* iptraf : Güvenlik duvarı anlık izleme için yüklenmiş pakettir.
		* Dependencies: 

		|Paket Listesi        |                  |         |
		|---------------------|------------------|---------| 
		|libc6|libncurses5|libtinfo5|

	* ifenslave : Güvenlik duvarı arabirim yedekliliği için yüklenmiş pakettir.
		* Reverse Depends: 

		|Paket Listesi        |
		|---------------------|
		|ifenslave-2.6|

		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|ifupdown|iproute2|net-tools|ifenslave-2.6|

	* ahtapot-lkk : Güvenlik duvarı anlık izleme arayüzü için yüklenmiş pakettir.
		* Dependencies: 

		|Paket Listesi        |                |
		|---------------------|----------------| 
		|python|debconf|

	* Conntrackd : Güvenlik Duvarı yedekliliği için yüklenmiş pakettir.
		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|init-system-helpers|libc6|libmnl0|libnetfilter-conntrack3|
		|libnetfilter-cthelper0|libnetfilter-queue1|libnfnetlink0||

	* Atop : Güvenlik duvarı anlık izleme için yüklenmiş pakettir.
		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|libc6|libncurses5|libtinfo5|zlib1g
		|lsb-base|cron|||
	
	* Mtr-tiny : Güvenlik duvarı anlık izleme için yüklenmiş pakettir.
		* Reverse Depends: 

		|Paket Listesi        |           |
		|---------------------|-----------| 
		|mtr|education-common|

		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|libc6|libncurses5|libtinfo5|mtr|
|		suidmanager||||

	* Iptstate : Güvenlik duvarı anlık izleme için yüklenmiş pakettir.
		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|libc6|libgcc1|libncurses5|libnetfilter-conntrack3| 
		|libstdc++6|libtinfo5||| 
		
	* Bmon : Güvenlik duvarı anlık izleme için yüklenmiş pakettir.
		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|libc6|libconfuse0|libncurses5|libnl-3-200|
		|libnl-route-3-200|libtinfo5|||

###FirewallBuilder rolünde yüklenen paketler

* FirewallBuilder rolünde yüklenen paketler, MYS kapsamında yönetilen FirewallBuilder görevi verilen tüm makinalara kurulan ortak paketlerdir.
	* fwbuilder : Güvenlik Duvarı Yönetim arayüzü için kurulmuş pakettir.
		* Reverse Depends: 

		|Paket Listesi        |
		|---------------------| 
		|fwbuilder-dbg|

		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|libc6|fwbuilder-doc|libqtcore4|libxml2|
		|fwbuilder-backend|fwbuilder-linux|libqtgui4|libxslt1.1|
		|fwbuilder-bsd|libfwbuilder9|libsnmp30|rcs|
		|fwbuilder-cisco|libgcc1|libssl1.0.0|zlib1g|
		|fwbuilder-common|libqt4-network|libstdc++6||

	* git : Güvenlik Duvarı Yönetim Sistemi için kullanılan git adresine erişim yapılması amacı ile yüklenmiş pakettir.
		* Reverse Depends: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|blogofile|git-el|gitweb|phpunit-git|
		|bugs-everywhere|git-email|grokmirror|pkg-perl-tools|
		|buildbot|git-extras|guilt|propellor|
		|bup|git-flow|hg-fast-export|prt|git-dpm|
		|calypso|git-ftp|hobbit-plugins|python-git|
		|commit-patch|git-gui|ikiwiki|python-setuptools-git|
		|dh-make-perl|git-man|ikiwiki-hosting-web|python-vcversioner|
		|dh-ocaml|git-mediawiki|julia|python3-setuptools-git|
		|drush|git-notifier|kdesrc-build|python3-vcversioner|
		|duck|git-reintegrate|kdevplatform8-libs|qgit|
		|etckeeper|git-remote-bzr|keyringer|qtcreator|
		|fdroidserver|git-remote-gcrypt|kgb-bot|rebar|
		|flashbake|git-remote-hg|kup-server|redmine|
		|fusionforge-plugin-scmgit|git-repair|lava-dev|ruby-git|
		|giggle|git-review|lava-dispatcher|ruby-grack|
		|git-all|git-sh|ldap-git-backup|sparkleshare|
		|git-annex|git-svn|libapp-nopaste-perl|sputnik|
		|git-arch|git2cl|libgit-repository-perl|stgit|
		|git-buildpackage|gitg|libgit-wrapper-perl|svn-all-fast-export|
		|git-core|github-backup|magit|tig|
		|git-cvs|gitit|myrepos|ui-auto|
		|git-cvs|gitk|opam|undertaker|
		|git-daemon-run|gitolite3|pass|vcsh|
		|git-daemon-sysvinit|gitpkg|pepper|zim|
		|git-doc|gitstats|php-monolog|zsh-antigen|

		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|zlib1g|git-daemon-sysvinit|git-doc|libexpat1|
		|bash-completion|gitosis|gitpkg|ibpcre3|
		|cogito|git-el|gitweb|patch|
		|gettext-base|git-email|gitweb|perl-modules|
		|git-arch|git-gui|gitweb|rsync|
		|git-buildpackage|git-man|guilt|ssh-client|
		|git-core|git-man|less|stgit|
		|git-core|git-mediawiki|libc6|stgit-contrib|
		|git-cvs|libcurl3-gnutls|git-svn|git-daemon-run|
		|gitk|iberror-perl|||

	* python-qt4 : GDYS Gui kullanımı için yüklenmiş pakettir.
		* Reverse Depends: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|anki|kde-config-touchpad|python-coherence|python-whiteboard|
		|apt-offline-gui|laptop-mode-tools|python-electrum|python-yade|
		|autokey-qt|libqgis-dev|python-hachoir-metadata|qbzr|
		|babiloo|linkchecker-gui|python-kde4|qct|
		|binwalk|maptransfer|python-kde4|qtqr|
		|buildnotify|minirok|python-matplotlib|qweborf|
		|code-saturne|mnemosyne|python-mecavideo|relational|
		|cyclograph-qt4|monkeystudio|python-pdftools|reportbug-ng|
		|dff|ninja-ide|python-poppler-qt4|seascope|
		|drobo-utils|nuitkapython-pyface|series60-remote|eficas|
		|onionshare|python-pyqtgraph|subdownloader|encuentro|
		|openlp|python-pyudev|tortoisehg|ffado-mixer-qt4|
		|openmolar|python-qgis|treeline|frescobaldi|
		|opensesame|python-qscintilla2|trimage|git-cola|
		|openteacher|python-qt4-dbg|turpial|gns3|
		|picard|python-qt4-gl|uicilibris|gnuradio|
		|polybori-gui|python-qt4-phonon|ulatencygr-air-modes|
		|puddletag|python-qt4-sqlveusz|hgview|
		|pyfai|python-qt4reactor|veusz-helpers|hplip-gui|
		|pymca|python-qwt5-qt4|veusz-helpers-dbg|ioapps|
		|pynagram|python-sip|vistrails|ipython-qtconsole|
		|pypibrowser|python-skimage|vitables|ipython-qtconsole|
		|pyqt4-dev-tools|python-spyderlib|writetype|ipython-qtconsole|
		|python-avc|python-taurus|kanyremote|python-avogadro|
		|python-vigra||||

		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|python|libqt4-network|libqtgui4|python-qt4-gl-dbg|
		|python|libqt4-script|ibqt4-xmlpatterns|python-qt4-phonon|
		|libc6|libqt4-scripttools|libqt4-declarative|python-qt4-sql|
		|libgcc1|libqt4-svg|sip-api-11.1|python-qt4-sql-dbg|
		|libpython2.7|libqt4-test|python-qt4-dbg|libqt4-designer|
		|libqt4-dbus|libqt4-xml|python-kde4|libstdc++6|
		|python-qwt5-qt4|libqtwebkit4|python-qscintilla2|python-sip4|
		|python-qwt3d-qt4|libqtassistantclient4|python-qt4-dbg|python-qt4-dev|
		|libqt4-help|libqtcore4|python-qt4-gl||

	* python-requests : ansible’ın bağımlılık paketi olduğu için yüklenmiş pakettir.
		* Reverse Depends: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|beets|python-ceilometer|python-mandrill|python-socketio-client|
		|cloud-init|python-ceph|python-neutron|python-softlayer|
		|dosage|python-cinder|python-neutronclient|python-sphinxcontrib.issuetracker|
		|encuentro|python-cinderclient|python-nova|python-stdeb|
		|epigrass|python-debiancontributors|python-novaclient|python-subliminal|
		|euca2ools|python-designateclient|python-openstackclient|python-swiftclient|
		|gertty|python-docker|python-pip|python-swiftsc|
		|git-review|python-fedmsg|python-plotly|python-troveclient|
		|httpie|python-fedora|python-pycarddav|python-tuskarclient|
		|lava-dispatcher|python-gcm-client|python-pypump|python-twitter|
		|linkchecker|python-geopy|python-pysaml2|python-weboob|
		|mopidy-beets|python-glance|python-pyvmomi|python-x2go|
		|mopidy-soundcloud|python-glanceclient|python-requestbuilder|python3-responses|
		|nikola|python-guessit|python-requests-kerberos|radicale|python-social-auth|
		|pybit-client|python-heat|python-requests-mock|slapos-client|
		|python-acoustid|python-heatclient|python-requests-oauthlib|ssh-import-id|
		|python-awsauth|python-influxdb|python-responses|streamtuner2|
		|python-barbicanclient|python-jenkinsapi|python-saharaclient|syslog-ng-mod-elasticsearch|
		|python-boto|python-keystoneclient|python-savannaclient|vim-youcompleteme|
		|python-botocore|python-keystonemiddleware|python-seamicroclient|wapiti|
		|python-braintree|python-libturpial|python-smstrade|python-catcher|
		|python-livestreamer||||

		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|python:any|ca-certificates|python-urllib3|python-openssl|
		|python-chardet|python-ndg-httpsclient|python-pyasn1||

	* python-pexpect : GDYS Gui kullanımı için yüklenmiş pakettir.
		* Reverse Depends: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|cinnamon|ipython|mysql-workbench|python-smartpm|
		|cman|lava-dispatcher|python-pexpect-doc|python-tomahawk|
		|fence-agents|lavapdu-daemon|python-pexpect-doc|python-trove|
		|hplip||||
	
		* Dependencies: 

		|Paket Listesi        |                   |
		|---------------------|-------------------| 
		|python:any|python-pexpect-doc|

	* Xauth : GDYS Gui kullanımı için yüklenmiş pakettir.
		* Reverse Depends: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|dropbear|ltsp-server-standalone|openssh-server|slim|
		|kdm-gdmcompat|oar-node|openssh-server|tightvncserver|
		|ldm-server|oar-user|pkpgcounter|xbase-clients|
		|libgksu2-0|open-vm-tools-desktop|python-mne|xinit|
		|libkdesu5|openssh-client|python-nemu|xorg|
		|ltsp-server|openssh-client|||

		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|libc6|libx11-6|libxau6|libxext6|
		|libxmuu1||||

	* ahtapot-gdys-gui : GDYS Kontrol Panelini barındıran pakettir.
		* Dependencies: 

		|Paket Listesi        |                       |
		|---------------------|-----------------------| 
		|python|debconf|

###Gitlab rolünde yüklenen paketler

* GitLab rolünde yüklenen paketler, MYS kapsamında yönetilen GitLab görevi verilen tüm makinalara kurulan ortak paketlerdir.
	* git : Merkezi Yönetim Sistemine ait playbookların depolanması için kullanılan git adresine erişim yapılması amacı ile yüklenmiş pakettir.
		* Reverse Depends: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|blogofile|git-el|gitweb|phpunit-git|
		|bugs-everywhere|git-email|grokmirror|pkg-perl-tools|
		|buildbot|git-extras|guilt|propellor|
		|bup|git-flow|hg-fast-export|prt|git-dpm|
		|calypso|git-ftp|hobbit-plugins|python-git|
		|commit-patch|git-gui|ikiwiki|python-setuptools-git|
		|dh-make-perl|git-man|ikiwiki-hosting-web|python-vcversioner|
		|dh-ocaml|git-mediawiki|julia|python3-setuptools-git|
		|drush|git-notifier|kdesrc-build|python3-vcversioner|
		|duck|git-reintegrate|kdevplatform8-libs|qgit|
		|etckeeper|git-remote-bzr|keyringer|qtcreator|
		|fdroidserver|git-remote-gcrypt|kgb-bot|rebar|
		|flashbake|git-remote-hg|kup-server|redmine|
		|fusionforge-plugin-scmgit|git-repair|lava-dev|ruby-git|
		|giggle|git-review|lava-dispatcher|ruby-grack|
		|git-all|git-sh|ldap-git-backup|sparkleshare|
		|git-annex|git-svn|libapp-nopaste-perl|sputnik|
		|git-arch|git2cl|libgit-repository-perl|stgit|
		|git-buildpackage|gitg|libgit-wrapper-perl|svn-all-fast-export|
		|git-core|github-backup|magit|tig|
		|git-cvs|gitit|myrepos|ui-auto|
		|git-cvs|gitk|opam|undertaker|
		|git-daemon-run|gitolite3|pass|vcsh|
		|git-daemon-sysvinit|gitpkg|pepper|zim|
		|git-doc|gitstats|php-monolog|zsh-antigen|
		
		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|zlib1g|git-daemon-sysvinit|git-doc|libexpat1|
		|bash-completion|gitosis|gitpkg|libpcre3|
		|cogito|git-el|gitweb|patch|
		|gettext-base|git-email|gitweb|perl-modules|
		|git-arch|git-gui|gitweb|rsync|
		|git-buildpackage|git-man|guilt|ssh-client|
		|git-core|git-man|less|stgit|
		|git-core|git-mediawiki|libc6|stgit-contrib|
		|git-cvs|libcurl3-gnutls|git-svn|git-daemon-run|
		|gitk|liberror-perl|||
		
	* gitlab-ce :Merkezi Yönetim Sistemi, versiyon kontrol rolünü üstlendiği için kurulmuş pakettir. 
		* Dependencies: 

		|Paket Listesi        |                  |                                |
		|---------------------|------------------|--------------------------------| 
		|openssh-server|gitlab-ee|gitlab|

###Geçici Kural Tanımlama Sistemi (GKTS) rolü ile kurulan paketler

* GKTS rolünde yüklenen paketler, MYS kapsamında yönetilen GKTS görevi verilen tüm makinalara kurulan ortak paketlerdir.
	* python-django : GKTS uygulmasında kullanılan pakettir.
		* Reverse Depends:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|ahtapot-ocs-wb|python-django-braces|python-django-markupfield|python-django-threaded-multihost|
		|ahtapot-portscan|python-django-captcha|python-django-model-utils|python-django-threadedcomments|
		|autoradio|python-django-celery|python-django-mptt|python-django-tinymce|
		|bcfg2-server|python-django-classy-tags|python-django-mumble|python-django-treebeard|
		|bcfg2-web|python-django-common|python-django-mumble|python-django-uuidfield|
		|dicoweb|python-django-contact-form|python-django-nose|python-django-websocket|
		|djagios|python-django-countries|python-django-picklefield|python-django-xmlrpc|
		|django-testproject|python-django-crispy-forms|python-django-polymorphic|python-djangorestframework|
		|django-testscenarios|python-django-dajaxice|python-django-pyscss|python-fs-plugin-django|
		|graphite-web|python-django-debug-toolbar|python-django-ratelimit|python-jingo|
		|lava-server|python-django-discover-runner|python-django-registration|python-kombu|
		|mini-buildd|python-django-djapian|python-django-restricted-resource|python-model-mommy|
		|planet-venus|python-django-extdirect|python-django-reversion|python-mongoengine|
		|python-ajax-select|python-django-extensions|python-django-rosetta|python-openstack-auth|
		|python-appconf|python-django-filters|python-django-sekizai|python-pytils|
		|python-bootstrapform|python-django-floppyforms|python-django-shorturls|python-scrapy|
		|python-compressor|python-django-formfieldset|python-django-shortuuidfield|python-wtforms|
		|python-django-adminaudit|python-django-genshi|python-django-sitetree|python3-django-jsonfield|
		|python-django-app-plugins|python-django-guardian|python-django-south|python3-django-nose|
		|python-django-auth-ldap|python-django-haystack|python-django-tables2|python3-django-xmlrpc|
		|python-django-auth-openid|python-django-horizon|python-django-tagging|python-django-tastypie|
		|python-django-authority|python-django-jsonfield|python-django-taggit|python-django-macaddress|
		|python-django-bitfield||||

		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|bpython|libgdal1|python-flup|python-sqlite|
		|dpkg|libjs-jquery|python-memcache|python-sqlparse|
		|geoip-database-contrib|python-bcrypt|python-mysqldb|python-tz|
		|geoip-database-extra|python-django-common|python-pil|python-yaml|
		|gettext|python-django-doc|python-psycopg2|python:any|
		|ipython||||

	* uwsgi : GKTS uygulmasında kullanılan pakettir.
		* Dependencies:

		|Paket Listesi        |                                  |               |
		|---------------------|----------------------------------|---------------| 
		|uwsgi-core|lsb-base|initscripts|

	* python-sqlite : GKTS uygulmasında kullanılan pakettir.
		* Reverse Depends:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|python-django|python-sqlobject|python-kaa-base|griffith|
		|yum|python-sqlite-dbg|python-freevo|dtc-xen|
		|thuban|python-pysqlite1.1|python-django|datapm|
		|supybot|python-pycarddav|openlp|bcfg2-web|
		|python-webpy||||

		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|libc6|libsqlite0|python|python-sqlite-dbg|
		|python-pysqlite1.1|python2.3-pysqlite1.1|python2.3-sqlite|python2.4-pysqlite1.1|
		|python2.4-sqlite||||

	* django-jet
		* Dependencies:

		|Paket Listesi                     |
		|----------------------------------| 
		|python|

###Kibana rolü ile kurulan paketler

* Kibana rolünde yüklenen paketler, MYS kapsamında yönetilen Kibana görevi verilen tüm makinalara kurulan ortak paketlerdir.
	* kibana : Kibana arayüzünü barındıran pakettir.
	* nginx : Kibana Web Servisi için kurulan pakettir.
       	* Reverse Depends:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|samizdat|pyblosxom|puppetmaster-common|photofloat|
		|nginx-light|nginx-full|nginx-extras|nginx-common|
		|fusiondirectory|fcgiwrap|coquelicot|collectd-core|
		|cacti||||

		* Dependencies:

		|Paket Listesi                          |                 |               |
		|---------------------------------------|-----------------|---------------| 
		|nginx-full|nginx-light|nginx-extras|

###Logstash rolü ile kurulan paketler

* Logstash rolünde yüklenen paketler, MYS kapsamında yönetilen Logstash görevi verilen tüm makinalara kurulan ortak paketlerdir.
	* logstash : logstash uygulamasını barındıran pakettir.
		* Dependencies:

		|Paket Listesi        |
		|---------------------|
		|logrotate|

	* openjdk-7-jre : java scriptlerinin çalışması için kurulan pakettir.

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|openjdk-7-jre-headless|ibasound2|libatk1.0-0|libc6|
		|ibcairo2|libfontconfig1|libfreetype6|libgdk-pixbuf2.0-0|
		|libgif4|libglib2.0-0|libgtk2.0-0|libjpeg62-turbo|
		|libpango-1.0-0|libpangocairo-1.0-0|libpangoft2-1.0-0|libpng12-0 |
		|libx11-6|libxcomposite1|ibxext6|libxi6|
		|libxrender1|libxtst6|zlib1g|libxrandr2|
		|libxinerama1|libgl1-mesa-glx|libgl1|libatk-wrapper-java-jni|

###NTP rolü ile kurulan paketler

* NTP rolünde yüklenen paketler, MYS kapsamında yönetilen NTP görevi verilen tüm makinalara kurulan ortak paketlerdir.
	* ntp : Zaman senkranizasyonu için yüklenmiş pakettir
		* Reverse Depends: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|aiccu|fake-hwclock|lava-dispatcher|openstack-compute-node|
		|bwctl-server|gnome-system-tools|lava-server|predict|
		|chrony|gnumed-client|mate-system-tools|predict-gsat|
		|debci|hobbit-plugins|netsniff-ng|radioclk|
		|dms-core|ircd-ratbox|openafs-fileserver|samba|
		|dovecot-core|jffnms|openntpd|slony1-2-bin|
		|education-main-server|lava|openstack-cloud-services|tucnak2|

		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|adduser |libc6 |libopts25|ntp-doc |
		|lsb-base |libcap2 |libssl1.0.0 |perl |
		|netbase |libedit2 |dpkg |dhcp3-client| 

###Oscwb rolü ile kurulan paketler

* Ocswb rolünde yüklenen paketler, MYS kapsamında yönetilen Ocswb görevi verilen tüm makinalara kurulan ortak paketlerdir.
	* python-sqlite : Ocswb uygulmasında kullanılan pakettir.
		* Reverse Depends:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|python-django|python-sqlobject|python-kaa-base|griffith|
		|yum|python-sqlite-dbg|python-freevo|dtc-xen|
		|thuban|python-pysqlite1.1|python-django|datapm|
		|supybot|python-pycarddav|openlp|bcfg2-web|
		|python-webpy||||

		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|libc6|libsqlite0|python|python-sqlite-dbg|
		|python-pysqlite1.1|python2.3-pysqlite1.1|python2.3-sqlite|python2.4-pysqlite1.1|
		|python2.4-sqlite||||

	* python-django : Ocswb uygulmasında kullanılan pakettir.
		* Reverse Depends:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|ahtapot-ocs-wb|python-django-braces|python-django-markupfield|python-django-threaded-multihost|
		|ahtapot-portscan|python-django-captcha|python-django-model-utils|python-django-threadedcomments|
		|autoradio|python-django-celery|python-django-mptt|python-django-tinymce|
		|bcfg2-server|python-django-classy-tags|python-django-mumble|python-django-treebeard|
		|bcfg2-web|python-django-common|python-django-mumble|python-django-uuidfield|
		|dicoweb|python-django-contact-form|python-django-nose|python-django-websocket|
		|djagios|python-django-countries|python-django-picklefield|python-django-xmlrpc|
		|django-testproject|python-django-crispy-forms|python-django-polymorphic|python-djangorestframework|
		|django-testscenarios|python-django-dajaxice|python-django-pyscss|python-fs-plugin-django|
		|graphite-web|python-django-debug-toolbar|python-django-ratelimit|python-jingo|
		|lava-server|python-django-discover-runner|python-django-registration|python-kombu|
		|mini-buildd|python-django-djapian|python-django-restricted-resource|python-model-mommy|
		|planet-venus|python-django-extdirect|python-django-reversion|python-mongoengine|
		|python-ajax-select|python-django-extensions|python-django-rosetta|python-openstack-auth|
		|python-appconf|python-django-filters|python-django-sekizai|python-pytils|
		|python-bootstrapform|python-django-floppyforms|python-django-shorturls|python-scrapy|
		|python-compressor|python-django-formfieldset|python-django-shortuuidfield|python-wtforms|
		|python-django-adminaudit|python-django-genshi|python-django-sitetree|python3-django-jsonfield|
		|python-django-app-plugins|python-django-guardian|python-django-south|python3-django-nose|
		|python-django-auth-ldap|python-django-haystack|python-django-tables2|python3-django-xmlrpc|
		|python-django-auth-openid|python-django-horizon|python-django-tagging|python-django-tastypie|
		|python-django-authority|python-django-jsonfield|python-django-taggit|python-django-macaddress|
		|python-django-bitfield||||

		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|bpython|libgdal1|python-flup|python-sqlite|
		|dpkg|libjs-jquery|python-memcache|python-sqlparse|
		|geoip-database-contrib|python-bcrypt|python-mysqldb|python-tz|
		|geoip-database-extra|python-django-common|python-pil|python-yaml|
		|gettext|python-django-doc|python-psycopg2|python:any|
		|ipython||||

	* uwsgi : Ocswb uygulmasında kullanılan pakettir.
       	* Reverse Depends:

		|Paket Listesi        |                  |                 |
		|---------------------|------------------|-----------------|
		|libapache2-mod-uwsgi|libapache2-mod-ruwsgi|libapache2-mod-proxy-uwsgi|
	
		* Dependencies:

		|Paket Listesi        |                  |                                |
		|---------------------|------------------|--------------------------------| 
		|uwsgi-core|lsb-base|initscripts|

	* uwsgi-plugin-python
        * Reverse Depends:

		|Paket Listesi        |                  |                               |
		|---------------------|------------------|-------------------------------| 
		|uwsgi-plugin-greenlet-python|uwsgi-app-integration-plugins|python-uwsgidecorators|

       	* Dependencies:

		|Paket Listesi        |                  |                                |
		|---------------------|------------------|--------------------------------| 
		|libc6|libpython2.7|uwsgi-core|

	* django-jet
       	* Reverse Depends:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|ahtapot-portscan|ahtapot-ocs-wb|ahtapot-ocs-wb|ahtapot-portscan|
		|ahtapot-portscan|ahtapot-ocs-wb|||
	
		* Dependencies:

		|Paket Listesi               |
		|----------------------------| 
		|python|

    * python-requests : ansible’ın bağımlılık paketi olduğu için yüklenmiş pakettir.
		* Reverse Depends: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|beets|python-ceilometer|python-mandrill|python-socketio-client|
		|cloud-init|python-ceph|python-neutron|python-softlayer|
		|dosage|python-cinder|python-neutronclient|python-sphinxcontrib.issuetracker|
		|encuentro|python-cinderclient|python-nova|python-stdeb|
		|epigrass|python-debiancontributors|python-novaclient|python-subliminal|
		|euca2ools|python-designateclient|python-openstackclient|python-swiftclient|
		|gertty|python-docker|python-pip|python-swiftsc|
		|git-review|python-fedmsg|python-plotly|python-troveclient|
		|httpie|python-fedora|python-pycarddav|python-tuskarclient|
		|lava-dispatcher|python-gcm-client|python-pypump|python-twitter|
		|linkchecker|python-geopy|python-pysaml2|python-weboob|
		|mopidy-beets|python-glance|python-pyvmomi|python-x2go|
		|mopidy-soundcloud|python-glanceclient|python-requestbuilder|python3-responses|
		|nikola|python-guessit|python-requests-kerberos|radicale|python-social-auth|
		|pybit-client|python-heat|python-requests-mock|slapos-client|
		|python-acoustid|python-heatclient|python-requests-oauthlib|ssh-import-id|
		|python-awsauth|python-influxdb|python-responses|streamtuner2|
		|python-barbicanclient|python-jenkinsapi|python-saharaclient|syslog-ng-mod-elasticsearch|
		|python-boto|python-keystoneclient|python-savannaclient|vim-youcompleteme|
		|python-botocore|python-keystonemiddleware|python-seamicroclient|wapiti|
		|python-braintree|python-libturpial|python-smstrade|python-catcher|
		|python-livestreamer||||

		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 			
		|python:any|ca-certificates|python-urllib3|python-openssl| 
		|python:any|python-chardet|python-ndg-httpsclient|python-pyasn1| 
    
    * nginx :  Ocswb Web Servisi için kurulan pakettir.
       	* Reverse Depends:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|samizdat|pyblosxom|puppetmaster-common|photofloat|
		|nginx-light|nginx-full|nginx-extras|nginx-common|
		|fusiondirectory|fcgiwrap|coquelicot|collectd-core|
		|cacti||||

		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|nginx-full|nginx-light|nginx-extras||

	* ahtapot-ocs-wb : Ocswb uygulamasını barındıran pakettir.
		* Dependencies:

		|Paket Listesi        |                           |
		|---------------------|---------------------------| 
		|python|python-pymysql|

	* ahtapot-ocs-wb-alarm : Ocswb alarm uygulamasını barındıran pakettir.
		* Dependencies:

		|Paket Listesi        |                  |
		|---------------------|------------------|
		|python|python-pymysql|

###OpenVPN rolü ile kurulan paketler

* OpenVPN rolünde yüklenen paketler, MYS kapsamında yönetilen OpenVPN görevi verilen tüm makinalara kurulan ortak paketlerdir.
	* openvpn : OpenVPN uygulamasını barındıran pakettir.
		* Reverse Depends:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|alienvault-dummy-common|openvpn-auth-radius|openvpn-auth-ldap|network-manager-openvpn|
		|kvpnc|gadmin-openvpn-server|gadmin-openvpn-client|eurephia|
		|collectd-core||||

		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|debconf|libc6|iblzo2-2|libpam0g|
		|ibpkcs11-helper1|ibssl1.0.0|init-system-helpers|
		|initscripts|iproute2|||
		
	* openvpn-auth-ldap : OpenVPN LDAP kimlik doğrulama uygulamasını barındıran pakettir.
		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|gnustep-base-runtime|libc6|libgcc1|libgnustep-base1.24|
		|libldap-2.4-2|libobjc4|openvpn||

###Ossec rolü ile kurulan paketler

* Ossec rolünde yüklenen paketler, MYS kapsamında yönetilen Ossec görevi verilen tüm makinalara kurulan ortak paketlerdir.
	* python-crypto : Python uygulaması için kriptolu algortima ve protokoller içeren pakettir.
		* Reverse Depends:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|ansible|bitpim|bittornado|bittornado-gui|
		|dtc-xen|emesene|gajim|glipper|
		|kedpm|keysync|obfsproxy|ossec-auto-server|
		|ossec-hids-agent|pwman3|pyaimt|pyicqt|
		|pymsnt|python-beaker|python-crypto-dbg|python-crypto-doc|
		|python-elixir|python-gdata|python-glance|python-heat|
		|python-impacket|python-keyczar|python-keyring|python-keystone|
		|python-libcloud|python-livestreamer|python-oauthlib|python-openstackclient|
		|python-paramiko|python-potr|python-pskc|python-pyghmi|
		|python-pyhsm|python-pysaml2|python-pysnmp4|python-recaptcha|
		|python-samba|python-scapy|python-secretstorage|python-twisted-conch|
		|revelation|salt-master|salt-minion|sat-xmpp-core|
		|subdownloader|svtplay-dl|tahoe-lafs|volatility|
		|winpdb|winswitch|yokadi||

		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|python|python:any|libc6|libgmp10|
	
	* ossec-hids-agent : Ossec Agent uygulamasını barındıran pakettir.
		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|python|python-crypto|libc6|libssl1.0.0|
		|expect|debconf|adduser||

###Ossimcik rolü ile kurulan paketler

* Ossimcik rolünde yüklenen paketler, MYS kapsamında yönetilen Ossimcik görevi verilen tüm makinalara kurulan ortak paketlerdir.
	* ossec-hids : Ossec Server uygulamasını barındıran pakettir.
		* Reverse Depends:

		|Paket Listesi                       |                 |
		|------------------------------------|-----------------|
		|ossim-framework|alienvault-ossec|
		
		* Dependencies:

		|Paket Listesi        |                  |                                |
		|---------------------|------------------|--------------------------------| 
		|libc6|ibssl1.0.0|expect|
		
	* alienvault-ossec : Alienvault Ossec uygulamasını barındıran pakettir.
		* Reverse Depends:

		|Paket Listesi               |
		|----------------------------| 
		|alienvault-dummy-sensor|
		
		* Dependencies:

		|Paket Listesi               |
		|----------------------------| 
		|ossec-hids|
		
	* nxlog-ce : Nxlog uygulamasını barındıran pakettir.
		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|ibapr1|libc6|libcap2|ibdbi1|
		|ibexpat1|libpcre3|libperl5.20|libssl1.0.0|
		|zlib1g|adduser|openssl|lsb-base|
		|libdbd-mysql|libdbd-pgsql|libdbd-sqlite3|libdbd-freetds|
		
	* rsyslog-gnutls : Rsyslog üzerinden TLS ile log gönderimi için kurulan pakettir.
		* Reverse Depends:

		|Paket Listesi            |
		|-------------------------| 
		|rsyslog|
		
		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|libc6|libgnutls-deb0-28|libjson-c2|rsyslog|
		|gnutls-bin|

###PortScanner rolü ile kurulan paketler

* PortScanner rolünde yüklenen paketler, MYS kapsamında yönetilen PortScanner görevi verilen tüm makinalara kurulan ortak paketlerdir.
	* python-sqlite : PortScanner uygulmasında kullanılan pakettir.
		* Reverse Depends:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|python-django|python-sqlobject|python-kaa-base|griffith|
		|yum|python-sqlite-dbg|python-freevo|dtc-xen|
		|thuban|python-pysqlite1.1|python-django|datapm|
		|supybot|python-pycarddav|openlp|bcfg2-web|
		|python-webpy||||

		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|libc6|libsqlite0|python|python-sqlite-dbg|
		|python-pysqlite1.1|python2.3-pysqlite1.1|python2.3-sqlite|python2.4-pysqlite1.1|
		|python2.4-sqlite||||
		
	* python-django : PortScanner uygulmasında kullanılan pakettir.
		* Reverse Depends:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|ahtapot-ocs-wb|python-django-braces|python-django-markupfield|python-django-threaded-multihost|
		|ahtapot-portscan|python-django-captcha|python-django-model-utils|python-django-threadedcomments|
		|autoradio|python-django-celery|python-django-mptt|python-django-tinymce|
		|bcfg2-server|python-django-classy-tags|python-django-mumble|python-django-treebeard|
		|bcfg2-web|python-django-common|python-django-mumble|python-django-uuidfield|
		|dicoweb|python-django-contact-form|python-django-nose|python-django-websocket|
		|djagios|python-django-countries|python-django-picklefield|python-django-xmlrpc|
		|django-testproject|python-django-crispy-forms|python-django-polymorphic|python-djangorestframework|
		|django-testscenarios|python-django-dajaxice|python-django-pyscss|python-fs-plugin-django|
		|graphite-web|python-django-debug-toolbar|python-django-ratelimit|python-jingo|
		|lava-server|python-django-discover-runner|python-django-registration|python-kombu|
		|mini-buildd|python-django-djapian|python-django-restricted-resource|python-model-mommy|
		|planet-venus|python-django-extdirect|python-django-reversion|python-mongoengine|
		|python-ajax-select|python-django-extensions|python-django-rosetta|python-openstack-auth|
		|python-appconf|python-django-filters|python-django-sekizai|python-pytils|
		|python-bootstrapform|python-django-floppyforms|python-django-shorturls|python-scrapy|
		|python-compressor|python-django-formfieldset|python-django-shortuuidfield|python-wtforms|
		|python-django-adminaudit|python-django-genshi|python-django-sitetree|python3-django-jsonfield|
		|python-django-app-plugins|python-django-guardian|python-django-south|python3-django-nose|
		|python-django-auth-ldap|python-django-haystack|python-django-tables2|python3-django-xmlrpc|
		|python-django-auth-openid|python-django-horizon|python-django-tagging|python-django-tastypie|
		|python-django-authority|python-django-jsonfield|python-django-taggit|python-django-macaddress|
		|python-django-bitfield||||
			
		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|bpython|libgdal1|python-flup|python-sqlite|
		|dpkg|libjs-jquery|python-memcache|python-sqlparse|
		|geoip-database-contrib|python-bcrypt|python-mysqldb|python-tz|
		|geoip-database-extra|python-django-common|python-pil|python-yaml|
		|gettext|python-django-doc|python-psycopg2|python:any|
		|ipython||||
		
	* uwsgi : PortScanner uygulmasında kullanılan pakettir.
       	* Reverse Depends:

		|Paket Listesi        |                  |                                |
		|---------------------|------------------|--------------------------------| 
		|libapache2-mod-uwsgi|libapache2-mod-ruwsgi|libapache2-mod-proxy-uwsgi|
		
		* Dependencies:

		|Paket Listesi        |                  |                               |
		|---------------------|------------------|-------------------------------| 
		|uwsgi-core|lsb-base|initscripts|

	* uwsgi-plugin-python : PortScanner uyluması için python plugindir.
       	* Reverse Depends:

		|Paket Listesi        |                  |                                |
		|---------------------|------------------|--------------------------------| 
		|uwsgi-plugin-greenlet-python|uwsgi-app-integration-plugins|python-uwsgidecorators|

       	* Dependencies:

		|Paket Listesi        |                  |                                |
		|---------------------|------------------|--------------------------------| 
		|libc6|libpython2.7|uwsgi-core|

	* django-jet : ProtScanner arayüzü için kullanılan pakettir.
        * Reverse Depends:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|ahtapot-portscan|ahtapot-ocs-wb|ahtapot-ocs-wb|ahtapot-portscan|
		|ahtapot-portscan|ahtapot-ocs-wb|||
			
		* Dependencies:

		|Paket Listesi                   |
		|--------------------------------| 
		|python|

	* python-requests : PortScanner uygulamasında bulunan Python scriptler için yüklenmiş pakettir.
		* Reverse Depends: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|beets|python-ceilometer|python-mandrill|python-socketio-client|
		|cloud-init|python-ceph|python-neutron|python-softlayer|
		|dosage|python-cinder|python-neutronclient|python-sphinxcontrib.issuetracker|
		|encuentro|python-cinderclient|python-nova|python-stdeb|
		|epigrass|python-debiancontributors|python-novaclient|python-subliminal|
		|euca2ools|python-designateclient|python-openstackclient|python-swiftclient|
		|gertty|python-docker|python-pip|python-swiftsc|
		|git-review|python-fedmsg|python-plotly|python-troveclient|
		|httpie|python-fedora|python-pycarddav|python-tuskarclient|
		|lava-dispatcher|python-gcm-client|python-pypump|python-twitter|
		|linkchecker|python-geopy|python-pysaml2|python-weboob|
		|mopidy-beets|python-glance|python-pyvmomi|python-x2go|
		|mopidy-soundcloud|python-glanceclient|python-requestbuilder|python3-responses|
		|nikola|python-guessit|python-requests-kerberos|radicale|python-social-auth|
		|pybit-client|python-heat|python-requests-mock|slapos-client|
		|python-acoustid|python-heatclient|python-requests-oauthlib|ssh-import-id|
		|python-awsauth|python-influxdb|python-responses|streamtuner2|
		|python-barbicanclient|python-jenkinsapi|python-saharaclient|syslog-ng-mod-elasticsearch|
		|python-boto|python-keystoneclient|python-savannaclient|vim-youcompleteme|
		|python-botocore|python-keystonemiddleware|python-seamicroclient|wapiti|
		|python-braintree|python-libturpial|python-smstrade|python-catcher|
		|python-livestreamer||||
		
		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|python:any|ca-certificates|python-urllib3|python-openssl| 
		|python:any|python-chardet|python-ndg-httpsclient|python-pyasn1| 
		
	* nmap : Portların taranması için kullanılan servisi içeren pakettir.
		* Reverse Depends:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|ahtapot-portscan|alienvault-dummy-framework|alienvault-dummy-sensor|atheist|
		|education-common|fusioninventory-agent-task-network|gnome-nettool|ibid|
		|jffnms|libnmap-parser-perl|lsat|ndiff|
		|nikto|nmapsi4|ocsinventory-agent|ocsinventory-reports|
		|ocsinventory-server|openvas-scanner|ossim-agent|ossim-framework|
		|pbnj|plainbox-provider-checkbox|zenmap||
		
		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|libc6|libgcc1|liblinear1|liblua5.2-0|
		|libpcap0.8|libpcre3|libssl1.0.0|libstdc++6|
		|ndiff||||
		
	* nginx : PortScanner Web Servisi için kurulan pakettir.
       	* Reverse Depends:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|samizdat|pyblosxom|puppetmaster-common|photofloat|
		|nginx-light|nginx-full|nginx-extras|nginx-common|
		|fusiondirectory|fcgiwrap|coquelicot|collectd-core|
		|cacti||||
		
		* Dependencies:

		|Paket Listesi        |                  |                                |
		|---------------------|------------------|--------------------------------| 
		|nginx-full|nginx-light|nginx-extras|
		
	* ahtapot-portscan : PortScanner uygulamasını barındıran pakettir.
		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|python|django-jet|python-django|nmap|
		|sqlite3||||

###PWLM rolü ile kurulan paketler

* PWLM rolünde yüklenen paketler, MYS kapsamında yönetilen PWLM görevi verilen tüm makinalara kurulan ortak paketlerdir.
	* python-sqlite : PWLM uygulmasında kullanılan pakettir.
		* Reverse Depends:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|python-django|python-sqlobject|python-kaa-base|griffith|
		|yum|python-sqlite-dbg|python-freevo|dtc-xen|
		|thuban|python-pysqlite1.1|python-django|datapm|
		|supybot|python-pycarddav|openlp|bcfg2-web|
		|python-webpy||||

		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|libc6|libsqlite0|python|python-sqlite-dbg|
		|python-pysqlite1.1|python2.3-pysqlite1.1|python2.3-sqlite|python2.4-pysqlite1.1|
		|python2.4-sqlite||||
        
	* django-jet : PWLM uygulmasında kullanılan pakettir.
		* Dependencies:

		|Paket Listesi              |
		|---------------------------| 
		|python|
		
	* python-django : PWLM uygulmasında kullanılan pakettir.
		* Reverse Depends:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|ahtapot-ocs-wb|python-django-braces|python-django-markupfield|python-django-threaded-multihost|
		|ahtapot-portscan|python-django-captcha|python-django-model-utils|python-django-threadedcomments|
		|autoradio|python-django-celery|python-django-mptt|python-django-tinymce|
		|bcfg2-server|python-django-classy-tags|python-django-mumble|python-django-treebeard|
		|bcfg2-web|python-django-common|python-django-mumble|python-django-uuidfield|
		|dicoweb|python-django-contact-form|python-django-nose|python-django-websocket|
		|djagios|python-django-countries|python-django-picklefield|python-django-xmlrpc|
		|django-testproject|python-django-crispy-forms|python-django-polymorphic|python-djangorestframework|
		|django-testscenarios|python-django-dajaxice|python-django-pyscss|python-fs-plugin-django|
		|graphite-web|python-django-debug-toolbar|python-django-ratelimit|python-jingo|
		|lava-server|python-django-discover-runner|python-django-registration|python-kombu|
		|mini-buildd|python-django-djapian|python-django-restricted-resource|python-model-mommy|
		|planet-venus|python-django-extdirect|python-django-reversion|python-mongoengine|
		|python-ajax-select|python-django-extensions|python-django-rosetta|python-openstack-auth|
		|python-appconf|python-django-filters|python-django-sekizai|python-pytils|
		|python-bootstrapform|python-django-floppyforms|python-django-shorturls|python-scrapy|
		|python-compressor|python-django-formfieldset|python-django-shortuuidfield|python-wtforms|
		|python-django-adminaudit|python-django-genshi|python-django-sitetree|python3-django-jsonfield|
		|python-django-app-plugins|python-django-guardian|python-django-south|python3-django-nose|
		|python-django-auth-ldap|python-django-haystack|python-django-tables2|python3-django-xmlrpc|
		|python-django-auth-openid|python-django-horizon|python-django-tagging|python-django-tastypie|
		|python-django-authority|python-django-jsonfield|python-django-taggit|python-django-macaddress|
		|python-django-bitfield||||
			
		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|bpython|libgdal1|python-flup|python-sqlite|
		|dpkg|libjs-jquery|python-memcache|python-sqlparse|
		|geoip-database-contrib|python-bcrypt|python-mysqldb|python-tz|
		|geoip-database-extra|python-django-common|python-pil|python-yaml|
		|gettext|python-django-doc|python-psycopg2|python:any|
		|ipython||||
		
	* uwsgi : PWLM uygulmasında kullanılan pakettir.
       	* Reverse Depends:

		|Paket Listesi        |                  |                                |
		|---------------------|------------------|--------------------------------| 
		|libapache2-mod-uwsgi|libapache2-mod-ruwsgi|libapache2-mod-proxy-uwsgi|
		
		* Dependencies:

		|Paket Listesi                          |                 |               |
		|---------------------------------------|-----------------|---------------| 
		|uwsgi-core|lsb-base|initscripts|
        
	* uwsgi-plugin-python : WLM uygulmasında kullanılan uwsgi paketi için python plug-in pakettir.
       	* Reverse Depends:

		|Paket Listesi        |                  |                                |
		|---------------------|------------------|--------------------------------| 
		|uwsgi-plugin-greenlet-python|uwsgi-app-integration-plugins|python-uwsgidecorators|
        
       	* Dependencies:

		|Paket Listesi        |                  |                                |
		|---------------------|------------------|--------------------------------| 
		|libc6|libpython2.7|uwsgi-core|
		
	* python-requests : PWLM uygulamasında bulunan Python scriptler için yüklenmiş pakettir.
		* Reverse Depends: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|beets|python-ceilometer|python-mandrill|python-socketio-client|
		|cloud-init|python-ceph|python-neutron|python-softlayer|
		|dosage|python-cinder|python-neutronclient|python-sphinxcontrib.issuetracker|
		|encuentro|python-cinderclient|python-nova|python-stdeb|
		|epigrass|python-debiancontributors|python-novaclient|python-subliminal|
		|euca2ools|python-designateclient|python-openstackclient|python-swiftclient|
		|gertty|python-docker|python-pip|python-swiftsc|
		|git-review|python-fedmsg|python-plotly|python-troveclient|
		|httpie|python-fedora|python-pycarddav|python-tuskarclient|
		|lava-dispatcher|python-gcm-client|python-pypump|python-twitter|
		|linkchecker|python-geopy|python-pysaml2|python-weboob|
		|mopidy-beets|python-glance|python-pyvmomi|python-x2go|
		|mopidy-soundcloud|python-glanceclient|python-requestbuilder|python3-responses|
		|nikola|python-guessit|python-requests-kerberos|radicale|python-social-auth|
		|pybit-client|python-heat|python-requests-mock|slapos-client|
		|python-acoustid|python-heatclient|python-requests-oauthlib|ssh-import-id|
		|python-awsauth|python-influxdb|python-responses|streamtuner2|
		|python-barbicanclient|python-jenkinsapi|python-saharaclient|syslog-ng-mod-elasticsearch|
		|python-boto|python-keystoneclient|python-savannaclient|vim-youcompleteme|
		|python-botocore|python-keystonemiddleware|python-seamicroclient|wapiti|
		|python-braintree|python-libturpial|python-smstrade|python-catcher|
		|python-livestreamer||||
			
		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|python:any|ca-certificates|python-urllib3|python-openssl| 
		|python:any|python-chardet|python-ndg-httpsclient|python-pyasn1| 
		
	* nginx : PWLM Web Servisi için kurulan pakettir.
       	* Reverse Depends:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|samizdat|pyblosxom|puppetmaster-common|photofloat|
		|nginx-light|nginx-full|nginx-extras|nginx-common|
		|fusiondirectory|fcgiwrap|coquelicot|collectd-core|
		|cacti||||
			
		* Dependencies:

		|Paket Listesi        |                  |                                |
		|---------------------|------------------|--------------------------------| 
		|nginx-full|nginx-light|nginx-extras|
		
	* git : PWLM üzerinde yapılan değişikliklerin MYS sistemine entegre edilmesi için kurulmuş pakettir.
		* Reverse Depends: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------|
		|blogofile|git-el|gitweb|phpunit-git|
		|bugs-everywhere|git-email|grokmirror|pkg-perl-tools|
		|buildbot|git-extras|guilt|propellor|
		|bup|git-flow|hg-fast-export|prt|git-dpm|
		|calypso|git-ftp|hobbit-plugins|python-git|
		|commit-patch|git-gui|ikiwiki|python-setuptools-git|
		|dh-make-perl|git-man|ikiwiki-hosting-web|python-vcversioner|
		|dh-ocaml|git-mediawiki|julia|python3-setuptools-git|
		|drush|git-notifier|kdesrc-build|python3-vcversioner|
		|duck|git-reintegrate|kdevplatform8-libs|qgit|
		|etckeeper|git-remote-bzr|keyringer|qtcreator|
		|fdroidserver|git-remote-gcrypt|kgb-bot|rebar|
		|flashbake|git-remote-hg|kup-server|redmine|
		|fusionforge-plugin-scmgit|git-repair|lava-dev|ruby-git|
		|giggle|git-review|lava-dispatcher|ruby-grack|
		|git-all|git-sh|ldap-git-backup|sparkleshare|
		|git-annex|git-svn|libapp-nopaste-perl|sputnik|
		|git-arch|git2cl|libgit-repository-perl|stgit|
		|git-buildpackage|gitg|libgit-wrapper-perl|svn-all-fast-export|
		|git-core|github-backup|magit|tig|
		|git-cvs|gitit|myrepos|ui-auto|
		|git-cvs|gitk|opam|undertaker|
		|git-daemon-run|gitolite3|pass|vcsh|
		|git-daemon-sysvinit|gitpkg|pepper|zim|
		|git-doc|gitstats|php-monolog|zsh-antigen|

		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|zlib1g|git-daemon-sysvinit |git-doc |libexpat1 |
		|bash-completion|gitosis|gitpkg|libpcre3|
		|cogito |git-el |gitweb |patch |
		|gettext-base |git-email |gitweb|perl-modules |
		|git-arch |git-gui |gitweb|rsync |
		|git-buildpackage|git-man|guilt|ssh-client |
		|git-core|git-man|less |stgit|
		|git-core|git-mediawiki |libc6|stgit-contrib |
		|git-cvs |libcurl3-gnutls|git-svn |git-daemon-run|
		|gitk |liberror-perl |||
		
	* ahtapot-pwlm : PWLM uygulamasını barındıran pakettir.
		* Dependencies:

		|Paket Listesi                  |
		|-------------------------------| 
		|Python|

###Rsyslog rolü ile kurulan paketler

* Rsyslog rolünde yüklenen paketler, MYS kapsamında yönetilen Rsyslog görevi verilen tüm makinalara kurulan ortak paketlerdir. 
	* logrotate: Logların belirli periyotlar ile arşivlenmesi için gerekli pakettir
		* Reverse Depends:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|aolserver4-daemon|icecc|prayer|sympa|
		|apt-cacher-ng|ippl|privoxy|syslog-ng-core|
		|argus-server|kdm|pyca|tinyproxy|
		|atftpd|knockd|pygopherd|tor|
		|bareos-director|ldirectord|quagga|twatch|
		|bdii|leafnode|rabbitmq-server|uucp|
		|cacti|libvirt-daemon-system|radosgw|vsftpd|
		|ceph|libzypp|rsnapshot|xinetd|
		|clamav-base|liquidsoap|rsyslog|xtel|
		|clamav-freshclam|logstash|samba|xtide|
		|clamav-milter|logster|sendmail-base|yaws|
		|cricket|mailman|sipwitch|yrmcds|
		|cron|masqmail|sks|zabbix-agent|
		|ctdb|mgetty|slbackup|zabbix-proxy-mysql|
		|cubemap|muddleftpd|slony1-2-bin|zabbix-proxy-pgsql|
		|distributed-net|net-acct|squid3|zabbix-proxy-sqlite3|
		|dsyslog|ninja|sugarplum|zabbix-server-mysql|
		|heartbeat|pawserv|super|zabbix-server-pgsql|
		|heimdal-kdc|postgresql-common|||

		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|libacl1|libselinux1|cron-daemon|postgresql-common|
		|libc6|cron|base-passwd|mailx|
		|libpopt0|anacron|||

	* rsyslog_gnutls: Rsyslog üzerinden TLS ile log gönderimi için kurulan pakettir.
		* Reverse Depends:

		|Paket Listesi                       |
		|------------------------------------| 
		|rsyslog|
		
		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|libc6|libgnutls-deb0-28|libjson-c2|rsyslog|
		|gnutls-bin|

	* rsyslog : Loglama yapılması için yüklenmiş pakettir
		* Reverse Depends:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|anacron|heartbeat|nullmailer|rsyslog-mongodb|
		|apparmor|initscripts|prelude-lml|rsyslog-mysql|
		|approx|ldirectord|psad|rsyslog-pgsql|
		|arno-iptables-firewall|loganalyzer|request-tracker4|rsyslog-relp|
		|auth2db|logcheck|rlinetd|sympa|
		|cloudprint|ltsp-client|rsyslog-elasticsearch|ufw|
		|education-common|ltsp-client-core|rsyslog-gnutls|xinetd|
		|fwlogwatch|lyskom-server|rsyslog-gssapi|xwatch|
		
		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|libc6 |libuuid1|rsyslog-mysql|rsyslog-gssapi| 
		|libestr0|liblogging-stdlog0|rsyslog-pgsql |rsyslog-relp| 
		|libjson-c2|init-system-helpers|liblognorm1|logrotate| 
		|lsb-base|linux-kernel-log-daemon|rsyslog-doc|zlib1g|
		|rsyslog-mongodb |initscripts|rsyslog-gnutls |system-log-daemon| 
		
	* oracle-java8-installer : İmzalama için kurulan pakettir.
		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|binfmt-support|binutils|chromium-browser|debconf|
		|debconf-2.0|epiphany-browser|epiphany-gecko|epiphany-webkit|
		|firefox|firefox-2|galeon|google-chrome|
		|gsfonts-x11|iceape-browser|icedtea-6-plugin|icedtea-7-plugin|
		|iceweasel|j2se-common|java-common|konqueror|
		|locales|midbrowser|midori|moblin-web-browser|
		|mozilla-browser|mozilla-firefox|openjdk-6-jre|openjdk-6-jre-headless|
		|openjdk-7-jdk|openjdk-7-jre|openjdk-7-jre-headless|oracle-java7-bin|
		|oracle-java7-fonts|oracle-java7-jdk|oracle-java7-jre|oracle-java7-plugin|
		|oracle-java8-bin|oracle-java8-fonts|oracle-java8-jdk|oracle-java8-jre|
		|oracle-java8-plugin|oracle-jdk7-installer|oracle-jdk8-installer|ttf-arphic-uming|
		|ttf-baekmuk|ttf-kochi-gothic|ttf-kochi-mincho|ttf-sazanami-gothic|
		|ttf-sazanami-mincho|ttf-unfonts|ttf-unfonts-core|visualvm|
		|wget|xulrunner|xulrunner-1.9||
		
	* zamaneconsole : KamuSM tarafından geliştirilmiş 5651 Log imzalama uygulamasıdır.
		* Dependecies:

		|Paket Listesi                       |
		|------------------------------------| 
		|openjdk-7-jre|
		
	* rsync : Logların belirli periyotlarda merkez sunucuya gönderilmesi için yüklenmiş pakettir.
		* Reverse Depends: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|backintime-common|flexbackup|live-boot|rsnapshot|
		|backupninja|gadmin-rsync|live-tools|rssh|
		|backuppc|git|lsb-core|rsyncrypto|
		|barman|git|lsyncd|simple-cdd|bzrtools|
		|git-annex|luckybackup|sisu|clamav-unofficial-sigs|
		|git-remote-gcrypt|lxc|slack|clsync|
		|git-repair|mrb|subversion-tools|debaux|
		|gnumed-server|mrs|swift-account|debmirror|
		|grml2usb|nanoc|swift-container|dirvish|grsync|
		|opam|swift-object|dms-core|hdup|
		|openssh-known-hosts|swift-object-expirer|dput|inosync|
		|python-poker-engine|tailor|duplicity|jailtool|python-tomahawk|
		|vserver-debiantools|education-common|ksplice|python3-tomahawk|
		|vzctl|fdroidserver|libfile-rsync-perl|repmgr|
		|vzdump|flashybrid|libguestfs-rsync|rsbackup|
		
		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|libacl1|libattr1|libc6|libpopt0|
		|lsb-base|base-files|openssh-client|openssh-server|
		|duplicity||||

###Proxy rolü ile kurulan paketler

* Proxy rolünde yüklenen paketler, MYS kapsamında yönetilen Proxy görevi verilen tüm makinalara kurulan ortak paketlerdir. 
	* squid3 : Proxy görevini üstlenen uygulamayı barındıran pakettir.
		* Reverse Depends:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|alienvault-dummy-framework|squidguard|squid3-dbg|squid-deb-proxy|
		|jesred|education-main-server|calamaris|c-icap|
			
		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|adduser|ibc6|libcap2|libcomerr2|
		|libdb5.3|libecap2|libexpat1|libgcc1|
		|libgssapi-krb5-2|libk5crypto3|libkrb5-3|libldap-2.4-2|
		|libltdl7|libnetfilter-conntrack3|libnettle4|libpam0g|
		|libsasl2-2|libstdc++6|libxml2|logrotate|
		|lsb-base|netbase|resolvconf|smbclient|
		|squid-cgi|squid-purge|squid3-common|squidclient|
		|ufw|winbindd|||
		
	* nginx : Proxy Web Servisi için kurulan pakettir.
       	* Reverse Depends:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|samizdat|pyblosxom|puppetmaster-common|photofloat|
		|nginx-light|nginx-full|nginx-extras|nginx-common|
		|fusiondirectory|fcgiwrap|coquelicot|collectd-core|
		|cacti||||
			
		* Dependencies:

		|Paket Listesi        |                  |                                |
		|---------------------|------------------|--------------------------------| 
		|nginx-full|nginx-light|nginx-extras|
		
	* dansguardian : Proxy Listeleme yapısını barındıran pakettir.
		* Reverse Depends:

		|Paket Listesi                      |
		|-----------------------------------| 
		|education-services|
		
		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|adduser|clamav|perl|libc6|
		|libclamav7|libgcc1|libpcre3|libstdc++6|
		|zlib1g|clamav-freshclam|squid||
		
	* sarg : Proxy İstatistik uygumalasını barındıran pakettir.
		* Reverse Depends:

		|Paket Listesi                       |
		|------------------------------------| 
		|education-main-server|
		
		* Dependencies:

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|libc6|libgd3|libldap-2.4-2|ttf-dejavu-core|
		|ttf-freefont|squid|httpd|apache2|
		|squidguard|ibapache2-mod-php5|sqmgrlog||

###TestFirewall rolü ile kurulan paketler

* TestFirewall rolünde yüklenen paketler, MYS kapsamında yönetilen TestFirewall görevi verilen tüm makinalara kurulan ortak paketlerdir. 
	* iptables : Güvenlik Duvarı kuralları için yüklenmiş pakettir.
		* Reverse Depends: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|apf-firewall|fwanalog|libxtables10|puppet-module-puppetlabs-firewall|
		|arno-iptables-firewall|fwknop-server|linux-igd|pyroman|
		|collectd|fwsnort|miniupnpd|python-netfilter|
		|collectd-core|heartbeat|mxallowd|shorewall|
		|concordance-common|ipkungfu|netscript-2.4|shorewall-core|
		|dtc-xen-firewall|ipset|netscript-ipfilter|shorewall-lite|
		|ebtables|iptables-dev|network-config|shorewall6|
		|education-main-server|iptables-dev|network-manager|shorewall6-lite|
		|education-thin-client-server|iptables-persistent|nova-compute|sshguard|
		|fail2ban|kvpnc|nova-network|sshuttle|
		|ferm|libiptables-ipv4-ipqueue-perl|olpc-powerd|ufw|
		|fiaif|libpam-shield|p3scan|uif|
		|firehol|libvirt-daemon-system|ppp-gatekeeper|uruk|
		|firewalld|libxtables10|psad|util-vserver|
			
		* Dependencies: 

		|Paket Listesi        |                                   |               |
		|---------------------|-----------------------------------|---------------| 
		|libc6|libnfnetlink0|libxtables10|
		
	* iptables-persistent : Güvenlik Duvarı kuralları için yüklenmiş pakettir.
		* Reverse Depends: 

		|Paket Listesi        |                                 |
		|---------------------|---------------------------------| 
		|netfilter-persistent|dms-core|
			
		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|netfilter-persistent|iptables|debconf|debconf-2.0|
		
	* rsync : Logların belirli periyotlarda merkez sunucuya gönderilmesi için yüklenmiş pakettir.
		* Reverse Depends: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|backintime-common|flexbackup|live-boot|rsnapshot|
		|backupninja|gadmin-rsync|live-tools|rssh|
		|backuppc|git|lsb-core|rsyncrypto|
		|barman|git|lsyncd|simple-cdd|
		|bzrtools|git-annex|luckybackup|sisu|
		|clamav-unofficial-sigs|git-remote-gcrypt|lxc|slack|
		|clsync|git-repair|mrb|subversion-tools|
		|debaux|gnumed-server|mrs|swift-account|
		|debmirror|grml2usb|nanoc|swift-container|
		|dirvish|grsync|opam|swift-object|
		|dms-core|hdup|openssh-known-hosts|swift-object-expirer|
		|dput|inosync|python-poker-engine|tailor|
		|duplicity|jailtool|python-tomahawk|vserver-debiantools|
		|education-common|ksplice|python3-tomahawk|vzctl|
		|fdroidserver|libfile-rsync-perl|repmgr|vzdump|
		|flashybrid|libguestfs-rsync|rsbackup||
		
		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|libacl1|libattr1|libc6|libpopt0|
		|lsb-base|base-files|openssh-client|openssh-server| 
		|duplicity||||
		
	* keepalived : Güvenlik Duvarı yedekliliği için yüklenmiş pakettir.
		* Reverse Depends: 

		|Paket Listesi        |                  |
		|---------------------|------------------|
		|yrmcds|ipvsadm|
		
		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|iproute|ipvsadm|libc6|libnl-3-200|
		|libnl-genl-3-200|libpci3|libsensors4|ibsnmp30|
		|libssl1.0.0|libwrap0|||

	* iptraf : Güvenlik duvarı anlık izleme için yüklenmiş pakettir.
		* Dependencies: 

		|Paket Listesi        |                  |                                |
		|---------------------|------------------|--------------------------------| 
		|libc6|libncurses5|libtinfo5|
		
	* ifenslave : Güvenlik duvarı arabirim yedekliliği için yüklenmiş pakettir.
		* Reverse Depends: 

		|Paket Listesi                      |
		|-----------------------------------| 
		|ifenslave-2.6|
		
		* Dependencies: 

		|Paket Listesi        |                  |                 |               |
		|---------------------|------------------|-----------------|---------------| 
		|ifupdown|iproute2|net-tools|ifenslave-2.6|

**Sayfanın PDF versiyonuna erişmek için [buraya](paketler.pdf) tıklayınız.**
