# IDS
Ahtapot projesi kapsamında IDS işlevinin kurulumunu ve yönetimini sağlayan playbook’dur. “**/etc/ansible/playbooks/**” dizini altında bulunan “**ids.yml**” dosyasına bakıldığında, “**hosts**” satırında Ansible’a ait “**/etc/ansible/**” altında bulunan “**hosts**” dosyasında “**[surcata_ids]**” satırı altına yazılmış tüm sunucularda bu playbookun oynatılacağı belirtilir. “**sudo**” satırı ile çalışacak komutların sudo yetkisi ile çalışması belirlenir. “**vars_files**” satırı ids playbookunun değişken dosyalarını belirtmektedir. “**roles**” satırı altında bulunan satırlarda ise bu playbook çalıştığında “**base**”, “**ids**”, “**barnyard2**” ve “**pulledpork**”rollerinin çalışacağı belirtilmektedir.


```
- hosts: suricata_ids
  sudo: yes
  vars_files:
  - /etc/ansible/roles/base/vars/group.yml
  - /etc/ansible/roles/base/vars/user.yml
  - /etc/ansible/roles/base/vars/repo.yml
  - /etc/ansible/roles/base/vars/rsyslog.yml
  - /etc/ansible/roles/base/vars/ntp.yml
  - /etc/ansible/roles/base/vars/package.yml
  - /etc/ansible/roles/base/vars/kernelmodules_remove.yml
  - /etc/ansible/roles/base/vars/kernelmodules_blacklist.yml
  - /etc/ansible/roles/base/vars/host.yml
  - /etc/ansible/roles/base/vars/audit.yml
  - /etc/ansible/roles/base/vars/sudo.yml
  - /etc/ansible/roles/base/vars/ssh.yml
  - /etc/ansible/roles/base/vars/grub.yml
  - /etc/ansible/roles/base/vars/logger.yml
  - /etc/ansible/roles/base/vars/logrotate.yml
  - /etc/ansible/roles/base/vars/directory.yml
  - /etc/ansible/roles/base/vars/profile.yml
  - /etc/ansible/roles/base/vars/fusioninventory.yml
  - /etc/ansible/roles/ids/vars/main.yml
  - /etc/ansible/roles/pulledpork/vars/main.yml
  - /etc/ansible/roles/barnyard2/vars/main.yml
  - /etc/ansible/roles/snorby/vars/main.yml
  - /etc/ansible/roles/mysql/vars/main.yml
  - /etc/ansible/roles/ids/vars/blocked-domains.yml
  - /etc/ansible/roles/ids/vars/protocol-anomaly.rules.yml
  - /etc/ansible/roles/ids/vars/fileblacklist.sha256.yml
  - /etc/ansible/roles/ids/vars/fileblacklist.sha1.yml
  - /etc/ansible/roles/ids/vars/fileblacklist.md5.yml
  - /etc/ansible/roles/ids/vars/local.rules.yml
  - /etc/ansible/roles/ids/vars/content.yml
  roles:
    - role: base
    - role: ids
    - role: barnyard2
    - role: pulledpork

```

#### IDS Rolü Değişkenleri
Bu roldeki değişkenler “**/etc/ansible/roles/ids/vars/**” dizini altında bulunan yml dosyalarında belirtilmiştir. yml dosyalarının içerikleri ve değişken bilgileri aşağıdaki gibidir;

-   “**blocked-domains.yml**” dosyasına engellenmesi istenen alan adları girilir. Her satırda bir alan adı olacak şekilde ekleme yapılır.
```
---
suricata_blocked_domains:
  - testsite123.com
  - badsitetesting.com

```

-   “**content.yml**” dosyasına engellenmesi veya alarm oluşturulması istenen içerikler girilir. Burada "**suricata_keyword_action**" alert veya drop olabilir. "**alert**" yazılırsa bu dosyada tanımlaması yapılan içerikler için alarm üretilir. "**drop**" yazılırsa ids modu için yine alarm üretilir fakat ips modu için engelleme yapılır. "**suricata_keyword_src**" kısmına alarm üretilcek/engellenecek trafiğinin kaynak adresi yazılır. Bu adres IP veya ağ veya bunların bir listesi olabilir. "**any**" yazılarak bütün kaynak adresler için bu kural tetiklenir. "**suricata_keyword_src_port**" kısmına alarm üretilcek/engellenecek trafiğinin kaynak portu yazılır. "**any**" yazılarak bütün kaynak portlar için bu kural tetiklenir. "**suricata_keyword_dst**" kısmına alarm üretilcek/engellenecek trafiğinin hedef adresi yazılır. Bu adres IP veya ağ veya bunların bir listesi olabilir. "**any**" yazılarak bütün hedef adresler için bu kural tetiklenir. "**suricata_keyword_dst_port**" kısmına alarm üretilcek/engellenecek trafiğinin hedef portu yazılır. "**any**" yazılarak bütün hedef portlar için bu kural tetiklenir.  "**suricata_keyword_msg**" kısmına bu kural tarafından üretilen alarmlarda geçecek mesaj tanımlanır.  "**suricata_keyword_proto**" kısmına bu kuralın çalışacağı protokoller liste olarak tanımlanır. TCP, UDP veya her ikisi birlikte yazılabilir. "**suricata_keywords**" kısmına her satıra bir içerik eklenerek engellenecek/alarm üretilecek içerikler belirtilir.
```
suricata_keyword_action: alert
suricata_keyword_src: any
suricata_keyword_src_port: any
suricata_keyword_dst: any
suricata_keyword_dst_port: any
suricata_keyword_msg: "Content detection: "
suricata_keyword_proto: ['tcp','udp']
suricata_keywords:
  - test zararli deneme

```

-   “**fileblacklist.md5.yml**” dosyasına engellenmesi veya alarm oluşturulması istenen hashler girilir. Burada "**suricata_blacklistmd5_action**" alert veya drop olabilir. "**alert**" yazılırsa bu dosyada tanımlaması yapılan hashler için alarm üretilir. "**drop**" yazılırsa ids modu için yine alarm üretilir fakat ips modu için engelleme yapılır. "**suricata_blacklistmd5_src**" kısmına alarm üretilcek/engellenecek trafiğinin kaynak adresi yazılır. Bu adres IP veya ağ veya bunların bir listesi olabilir. "**any**" yazılarak bütün kaynak adresler için bu kural tetiklenir. "**suricata_blacklistmd5_src_port**" kısmına alarm üretilcek/engellenecek trafiğinin kaynak portu yazılır. "**any**" yazılarak bütün kaynak portlar için bu kural tetiklenir. "**suricata_blacklistmd5_dst**" kısmına alarm üretilcek/engellenecek trafiğinin hedef adresi yazılır. Bu adres IP veya ağ veya bunların bir listesi olabilir. "**any**" yazılarak bütün hedef adresler için bu kural tetiklenir. "**suricata_blacklistmd5_dst_port**" kısmına alarm üretilcek/engellenecek trafiğinin hedef portu yazılır. "**any**" yazılarak bütün hedef portlar için bu kural tetiklenir.  "**suricata_blacklistmd5_msg**" kısmına bu kural tarafından üretilen alarmlarda geçecek mesaj tanımlanır.  "**suricata_blacklistmd5_sid**" kısmına bu kuralın sid'i yazılır. "**suricata_blacklistmd5_revision**" kısmına bu kuralın revision'u yazılır.  "**suricata_blacklistmd5**" kısmına her satıra bir md5 ve opsiyonal olarak dosya adı eklenerek engellenecek/alarm üretilecek dosya hashleri belirtilir.
```
suricata_blacklistmd5_action: alert
suricata_blacklistmd5_src: any
suricata_blacklistmd5_src_port: any
suricata_blacklistmd5_dst: any
suricata_blacklistmd5_dst_port: any
suricata_blacklistmd5_msg: "Black list checksum match MD5"
suricata_blacklistmd5_sid: 1089811401
suricata_blacklistmd5_rev: 1

suricata_blacklistmd5:
  - 2f8d0355f0032c3e6311c6408d7c2dc2  util-path.c
  - b9cf5cf347a70e02fde975fc4e117760
  - 02aaa6c3f4dbae65f5889eeb8f2bbb8d  util-pool.c
  - dd5fc1ee7f2f96b5f12d1a854007a818

```
-   “**fileblacklist.sha1.yml**” dosyasına engellenmesi veya alarm oluşturulması istenen hashler girilir. Burada "**suricata_blacklistsha1_action**" alert veya drop olabilir. "**alert**" yazılırsa bu dosyada tanımlaması yapılan hashler için alarm üretilir. "**drop**" yazılırsa ids modu için yine alarm üretilir fakat ips modu için engelleme yapılır. "**suricata_blacklistsha1_src**" kısmına alarm üretilcek/engellenecek trafiğinin kaynak adresi yazılır. Bu adres IP veya ağ veya bunların bir listesi olabilir. "**any**" yazılarak bütün kaynak adresler için bu kural tetiklenir. "**suricata_blacklistsha1_src_port**" kısmına alarm üretilcek/engellenecek trafiğinin kaynak portu yazılır. "**any**" yazılarak bütün kaynak portlar için bu kural tetiklenir. "**suricata_blacklistsha1_dst**" kısmına alarm üretilcek/engellenecek trafiğinin hedef adresi yazılır. Bu adres IP veya ağ veya bunların bir listesi olabilir. "**any**" yazılarak bütün hedef adresler için bu kural tetiklenir. "**suricata_blacklistsha1_dst_port**" kısmına alarm üretilcek/engellenecek trafiğinin hedef portu yazılır. "**any**" yazılarak bütün hedef portlar için bu kural tetiklenir.  "**suricata_blacklistsha1_msg**" kısmına bu kural tarafından üretilen alarmlarda geçecek mesaj tanımlanır.  "**suricata_blacklistsha1_sid**" kısmına bu kuralın sid'i yazılır. "**suricata_blacklistsha1_revision**" kısmına bu kuralın revision'u yazılır.  "**suricata_blacklistsha1**" kısmına her satıra bir sha1 ve opsiyonal olarak dosya adı eklenerek engellenecek/alarm üretilecek dosya hashleri belirtilir.
```
suricata_blacklistsha1_action: alert
suricata_blacklistsha1_src: any
suricata_blacklistsha1_src_port: any
suricata_blacklistsha1_dst: any
suricata_blacklistsha1_dst_port: any
suricata_blacklistsha1_msg: "Black list checksum match SHA1"
suricata_blacklistsha1_sid: 1089811402
suricata_blacklistsha1_rev: 1
suricata_blacklistsha1:

```
-   “**fileblacklist.sha256.yml**” dosyasına engellenmesi veya alarm oluşturulması istenen hashler girilir. Burada "**suricata_blacklistsha256_action**" alert veya drop olabilir. "**alert**" yazılırsa bu dosyada tanımlaması yapılan hashler için alarm üretilir. "**drop**" yazılırsa ids modu için yine alarm üretilir fakat ips modu için engelleme yapılır. "**suricata_blacklistsha256_src**" kısmına alarm üretilcek/engellenecek trafiğinin kaynak adresi yazılır. Bu adres IP veya ağ veya bunların bir listesi olabilir. "**any**" yazılarak bütün kaynak adresler için bu kural tetiklenir. "**suricata_blacklistsha256_src_port**" kısmına alarm üretilcek/engellenecek trafiğinin kaynak portu yazılır. "**any**" yazılarak bütün kaynak portlar için bu kural tetiklenir. "**suricata_blacklistsha256_dst**" kısmına alarm üretilcek/engellenecek trafiğinin hedef adresi yazılır. Bu adres IP veya ağ veya bunların bir listesi olabilir. "**any**" yazılarak bütün hedef adresler için bu kural tetiklenir. "**suricata_blacklistsha256_dst_port**" kısmına alarm üretilcek/engellenecek trafiğinin hedef portu yazılır. "**any**" yazılarak bütün hedef portlar için bu kural tetiklenir.  "**suricata_blacklistsha256_msg**" kısmına bu kural tarafından üretilen alarmlarda geçecek mesaj tanımlanır.  "**suricata_blacklistsha256_sid**" kısmına bu kuralın sid'i yazılır. "**suricata_blacklistsha256_revision**" kısmına bu kuralın revision'u yazılır.  "**suricata_blacklistsha256**" kısmına her satıra bir sha256 ve opsiyonal olarak dosya adı eklenerek engellenecek/alarm üretilecek dosya hashleri belirtilir.
```
suricata_blacklistsha256_action: alert
suricata_blacklistsha256_src: any
suricata_blacklistsha256_src_port: any
suricata_blacklistsha256_dst: any
suricata_blacklistsha256_dst_port: any
suricata_blacklistsha256_msg: "Black list checksum match SHA256"
suricata_blacklistsha256_sid: 1089811403
suricata_blacklistsha256_rev: 1

suricata_blacklistsha256:

```
-   “**local.rules.yml**” dosyasına doğrudan suricata imzaları her satırda bir tane olacak şekilde tanımlanır.
```
---
suricata_local_rules:

```
-   “**suricata_protocol_anomaly_rules.yml**” dosyasında protokol anormalliklerini tespit edecek bazı ön tanımlı imzalar girilmiştir. İstenirse her satırda bir tane olacak şekilde ek imzalar tanımlanabilir.
```
---
suricata_protocol_anomaly_rules:
  - alert tcp any any -> any ![80,8080] (msg:"SURICATA HTTP but not tcp port 80, 8080"; flow:to_server; app-layer-protocol:http; sid:2271001; rev:1;)
  - alert tcp any any -> any 80 (msg:"SURICATA Port 80 but not HTTP"; flow:to_server; app-layer-protocol:!http; sid:2271002; rev:1;)
  - alert http any any -> any 443 (msg:"SURICATA HTTP clear text on port 443"; flow:to_server; app-layer-protocol:http; sid:2271019; rev:1;)
  - alert tcp any any -> any 443 (msg:"SURICATA Port 443 but not TLS"; flow:to_server; app-layer-protocol:!tls; sid:2271003; rev:1;)
  - alert tcp any any -> any ![20,21] (msg:"SURICATA FTP but not tcp port 20 or 21"; flow:to_server; app-layer-protocol:ftp; sid:2271004; rev:1;)
  - alert tcp any any -> any [20,21] (msg:"SURICATA TCP port 21 but not FTP"; flow:to_server; app-layer-protocol:!ftp; sid:2271005; rev:1;)
  - alert tcp any any -> any ![25,587,465] (msg:"SURICATA SMTP but not tcp port 25,587,465"; flow:to_server; app-layer-protocol:smtp; sid:2271006; rev:1;)
  - alert tcp any any -> any [25,587,465] (msg:"SURICATA TCP port 25,587,465 but not SMTP"; flow:to_server; app-layer-protocol:!smtp; sid:2271007; rev:1;)
  - alert tcp any any -> any !22 (msg:"SURICATA SSH but not tcp port 22"; flow:to_server; app-layer-protocol:ssh; sid:2271008; rev:1;)
  - alert tcp any any -> any 22 (msg:"SURICATA TCP port 22 but not SSH"; flow:to_server; app-layer-protocol:!ssh; sid:2271009; rev:1;)
  - alert tcp any any -> any !143 (msg:"SURICATA IMAP but not tcp port 143"; flow:to_server; app-layer-protocol:imap; sid:2271010; rev:1;)
  - alert tcp any any -> any 143 (msg:"SURICATA TCP port 143 but not IMAP"; flow:to_server; app-layer-protocol:!imap; sid:2271011; rev:1;)
  - alert tcp any any -> any 139 (msg:"SURICATA TCP port 139 but not SMB"; flow:to_server; app-layer-protocol:!smb; sid:2271012; rev:1;)
  - alert tcp any any -> any [80,8080] (msg:"SURICATA DCERPC detected over port tcp 80,8080"; flow:to_server; app-layer-protocol:dcerpc; sid:2271013; rev:1;)
  - alert tcp any any -> any 53 (msg:"SURICATA TCP port 53 but not DNS"; flow:to_server; app-layer-protocol:!dns; sid:2271014; rev:1;)
  - alert udp any any -> any 53 (msg:"SURICATA UDP port 53 but not DNS"; flow:to_server; app-layer-protocol:!dns; sid:2271015; rev:1;)
  - alert tcp any any -> any 502 (msg:"SURICATA TCP port 502 but not MODBUS"; flow:to_server; app-layer-protocol:!modbus; sid:2271018; rev:1;)
```
-   “**main.yml**” dosyasında ids ayarlarının yapılması için gerekli ayar parametreleri bulunmaktadır. Burda ids yapılandırması için gerekli olan parametreler açıklanacaktır. "**suricata_mode**" ids için buraya ids yazılır. "**suricata_home_net:**" iç ağ tanımlarının yapıldığı değişkendir. "**suricata_external_net**" dış ağ tanımlarının yapıldığı parametredir. "**suricata_pcap_interfaces**" IDS'in paketleri dinleyeceği arabirim tanımlarının yapıldığı yerdir. "**-int: arabirim_adi**" şeklinde her satıra bir arabirim yazılır. "**suricata_rules**" aktif edilecek imza gruplarının tanımlandığı yerdir. Aktif edilmesi istenmeyen parametreler başına "**#**" konularak yorum satırına alınabilir.
```
---
# defaults file for ansible-suricata
suricata_mode: "ids"#ids|ips
fwbuilder_exists: "false"
suricata_ips_mode: "bridge" #nat|bridge
ips_int_iface: enp1s3
ips_ext_iface: enp0s3
config_suricata: true  #defines if suricata should be configured
scripts_dir: /opt/scripts
suricata_home_net: "[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"
suricata_external_net: "!$HOME_NET"
suricata_http_servers: "$HOME_NET"
suricata_smtp_servers: "$HOME_NET"
suricata_sql_servers: "$HOME_NET"
suricata_dns_servers: "$HOME_NET"
suricata_telnet_servers: "$HOME_NET"
suricata_aim_servers: "$HOME_NET"
suricata_dnp3_server: "$HOME_NET"
suricata_dnp3_client: "$HOME_NET"
suricata_modbus_client: "$HOME_NET"
suricata_modbus_server: "$HOME_NET"
suricata_enip_client: "$HOME_NET"
suricata_enip_server: "$HOME_NET"
suricata_action_order: "$HOME_NET"
suricata_action_order:
  - pass
  - drop
  - reject
  - alert
suricata_af_packet_interfaces:
  - int: eth0
    threads: 1
    defrag: "yes"
    cluster_type: cluster_flow  #cluster_round_robin, cluster_flow or cluster_cpu
    cluster_id: 99
    copy_mode: ips
    copy_iface: eth1
    buffer_size: 64535
    disable_promisc: "no"  # Set to yes to disable promiscuous mode
    use_nmap: "yes"
  - int: eth1
    threads: 1
    defrag: "yes"
    cluster_type: cluster_flow  #cluster_round_robin, cluster_flow or cluster_cpu
    cluster_id: 98
    copy_mode: ips
    copy_iface: eth0
    buffer_size: 64535
    disable_promisc: "no"  # Set to yes to disable promiscuous mode
    use_nmap: "yes"
suricata_pcap_interfaces:
  - int: enp0s3
    # On Linux, pcap will try to use mmaped capture and will use buffer-size
    # as total of memory used by the ring. So set this to something bigger
    # than 1% of your bandwidth.
    buffer_size: 16777216
    bpf_filter: "tcp and port 25"
    # Choose checksum verification mode for the interface. At the moment
    # of the capture, some packets may be with an invalid checksum due to
    # offloading to the network card of the checksum computation.
    # Possible values are:
    #  - yes: checksum validation is forced
    #  - no: checksum validation is disabled
    #  - auto: suricata uses a statistical approach to detect when
    #  checksum off-loading is used. (default)
    # Warning: 'checksum-validation' must be set to yes to have any validation
    checksum_checks: auto
    # With some accelerator cards using a modified libpcap (like myricom), you
    # may want to have the same number of capture threads as the number of capture
    # rings. In this case, set up the threads variable to N to start N threads
    # listening on the same interface.
    threads: 16
    # set to no to disable promiscuous mode:
    promisc: no
    # set snaplen, if not set it defaults to MTU if MTU can be known
    # via ioctl call and to full capture if not.
    snaplen: 1518
# - int: INT1

suricata_classification_file: /etc/suricata/classification.config
suricata_config_file: /etc/suricata/suricata.yaml
suricata_config_outputs: true
suricata_default_rule_path: /etc/suricata/rules
suricata_flow_timeouts:
  - name: default
    new: 30
    established: 300
    closed: 0
    emergency_new: 10
    emergency_established: 100
    emergency_closed: 0
  - name: tcp
    new: 60
    established: 3600
    closed: 120
    emergency_new: 10
    emergency_established: 100
    emergency_closed: 20
  - name: udp
    new: 30
    established: 300
    emergency_new: 10
    emergency_established: 100
  - name: icmp
    new: 30
    established: 300
    emergency_new: 10
    emergency_established: 100
suricata_host_mode: auto  #defines surica operating mode...Options are auto, router (IPS-Mode) or sniffer-only (IDS-Mode)
#    suricata_include_files:  #Files included here will be handled as if they were inlined in the configuration file.
#        - include1.yaml
#        - include2.yaml
suricata_iface: "{{ ansible_default_ipv4.interface }}"  #Interface to listen on (for pcap mode)
suricata_interfaces:  #define the interfaces on your suricata host and define if offloading should be disabled.
  - int: eth0
    disable_offloading: false
    disable_features:
      - gro
      - gso
      - lro
      - rx
      - rxhash
      - rxvlan
      - sg
      - tso
      - tx
      - txvlan
      - ufo
  - int: eth1
    disable_offloading: false
    disable_features:
      - gro
      - gso
      - lro
      - rx
      - rxhash
      - rxvlan
      - sg
      - tso
      - tx
      - txvlan
      - ufo
suricata_listen_mode: pcap  #pcap, nfqueue or af-packet
suricata_log_dir: /var/log/suricata/
suricata_nfqueue: 0  #Queue number to listen on (for nfqueue mode)
suricata_oinkmaster_rules_url: http://rules.emergingthreats.net/open/suricata/emerging.rules.tar.gz
suricata_outputs:
  - name: fast
    enabled: "yes"
    filename: fast.log
    append: "yes"
  - name: eve-log
    enabled: "yes"
    type: file  #file|syslog|unix_dgram|unix_stream
    filename: eve.json
    types:
      - name: alert
      - name: http
        config_addl: true  #defines if additional parameters are to be defined....required for template check
        extended: "yes"  # enable this for extended logging information
      - name: dns
      - name: tls
        config_addl: true  #defines if additional parameters are to be defined....required for template check
        extended: "yes"  # enable this for extended logging information
      - name: files
        config_addl: true  #defines if additional parameters are to be defined....required for template check
        force_magic: "yes"  # force logging magic on all logged files
        force_md5: "yes"  # force logging of md5 checksums
#      - name: "drop"
      - name: ssh
      - name: smtp
      - name: flow
  - name: unified2-alert
    enabled: "yes"
    filename: unified2.alert
    limit: 32mb  # File size limit.  Can be specified in kb, mb, gb.
    xff:
      - var: enabled
        val: "no"
      - var: mode
        val: extra-data
      - var: header
        val: X-Forwarded-For
  - name: http-log
    enabled: "yes"
    filename: http.log
    append: "yes"
  - name: tls-log
    enabled: "no"
    filename: tls.log
    append: "yes"
    certs_log_dir: certs
  - name: dns-log
    enabled: "no"
    filename: dns.log
    append: "yes"
  - name: pcap-info
    enabled: "no"
  - name: pcap-log
    enabled: "no"
    filename: log.pcap
    limit: 1000mb
    max_files: 2000
    mode: normal  # normal or sguil
    use_stream_depth: "no"  #If set to "yes" packets seen after reaching stream inspection depth are ignored. "no" logs all packets
  - name: alert-debug
    enabled: "no"
    filename: alert-debug.log
    append: "yes"
  - name: alert-prelude
    enabled: "no"
    profile: suricata
    log_packet_content: "no"
    log_packet_header: "yes"
  - name: stats
    enabled: "yes"
    filename: stats.log
    interval: 8
  - name: syslog
    enabled: "no"
    facility: local5
    level: Info  # possible levels: Emergency, Alert, Critical, Error, Warning, Notice, Info, Debug
  - name: drop
    enabled: "no"
    filename: drop.log
    append: "yes"
  - name: file-store
    enabled: "no"
    log_dir: files
    force_magic: "no"
    force_md5: "no"
  - name: file-log
    enabled: "no"
    filename: files-json.log
    append: "yes"
    force_magic: "no"
    force_md5: "no"
suricata_pfring_interfaces:
  - int: eth0
    threads: 1
    cluster_id: 99
    cluster_type: cluster_flow
  - int: eth1
    threads: 1
    cluster_id: 93
    cluster_type: cluster_flow
suricata_reference_config_file: /etc/suricata/reference.config
suricata_rules:
  - botcc.rules
  - ciarmy.rules
  - compromised.rules
  - drop.rules
  - dshield.rules
  - emerging-activex.rules
  - emerging-attack_response.rules
  - emerging-chat.rules
  - emerging-current_events.rules
  - emerging-dns.rules
  - emerging-dos.rules
  - emerging-exploit.rules
  - emerging-ftp.rules
  - emerging-games.rules
  - emerging-icmp_info.rules
# - emerging-icmp.rules
  - emerging-imap.rules
  - emerging-inappropriate.rules
  - emerging-malware.rules
  - emerging-misc.rules
  - emerging-mobile_malware.rules
  - emerging-netbios.rules
  - emerging-p2p.rules
  - emerging-policy.rules
  - emerging-pop3.rules
  - emerging-rpc.rules
  - emerging-scada.rules
  - emerging-scan.rules
  - emerging-shellcode.rules
  - emerging-smtp.rules
  - emerging-snmp.rules
  - emerging-sql.rules
  - emerging-telnet.rules
  - emerging-tftp.rules
  - emerging-trojan.rules
  - emerging-user_agents.rules
  - emerging-voip.rules
  - emerging-web_client.rules
  - emerging-web_server.rules
  - emerging-web_specific_apps.rules
  - emerging-worm.rules
  - tor.rules
  - dns_query.rules
  - protocol-anomaly.rules
  - blacklist.rules
  - local.rules
  - content.rules
  - decoder-events.rules # available in suricata sources under rules dir
  - stream-events.rules  # available in suricata sources under rules dir
  - http-events.rules    # available in suricata sources under rules dir
  - smtp-events.rules    # available in suricata sources under rules dir
  - dns-events.rules     # available in suricata sources under rules dir
  - tls-events.rules     # available in suricata sources under rules dir
suricata_run_initd: 'yes'  #set to yes to start the server in the init.d script
suricata_suppress_list:  #Defines a list of alerts to suppress
  - gen_id: 1
    sig_id: 2210020
#    track: by_src  #options are: by_src|by_dst
#    ip_addresses:  #define IP addressORsubnet if setting up track by
#      - 172.16.0.0/16
#      - 192.168.1.0/24
  - gen_id: 1
    sig_id: 2210021
  - gen_id: 1
    sig_id: 2210029
suricata_ubuntu_ppa: ppa:oisf/suricata-stable  #Options are ppa:oisf/suricata-stable, ppa:oisf/suricata-beta or ppa:oisf/suricata-daily
suricata_unix_command:
  enabled: "no"
#        filename: custom.socket

```
# IPS

Ahtapot projesi kapsamında IPS işlevinin kurulumunu ve yönetimini sağlayan playbook’dur. “**/etc/ansible/playbooks/**” dizini altında bulunan “**ips.yml**” dosyasına bakıldığında, “**hosts**” satırında Ansible’a ait “**/etc/ansible/**” altında bulunan “**hosts**” dosyasında “**[surcata_ips]**” satırı altına yazılmış tüm sunucularda bu playbookun oynatılacağı belirtilir. “**sudo**” satırı ile çalışacak komutların sudo yetkisi ile çalışması belirlenir. “**vars_files**” satırı ips playbookunun değişken dosyalarını belirtmektedir. “**roles**” satırı altında bulunan satırlarda ise bu playbook çalıştığında “**base**”, “**ips**”, “**barnyard2**” ve “**pulledpork**”rollerinin çalışacağı belirtilmektedir.


```
- hosts: suricata_ids
  sudo: yes
  vars_files:
  - /etc/ansible/roles/base/vars/group.yml
  - /etc/ansible/roles/base/vars/user.yml
  - /etc/ansible/roles/base/vars/repo.yml
  - /etc/ansible/roles/base/vars/rsyslog.yml
  - /etc/ansible/roles/base/vars/ntp.yml
  - /etc/ansible/roles/base/vars/package.yml
  - /etc/ansible/roles/base/vars/kernelmodules_remove.yml
  - /etc/ansible/roles/base/vars/kernelmodules_blacklist.yml
  - /etc/ansible/roles/base/vars/host.yml
  - /etc/ansible/roles/base/vars/audit.yml
  - /etc/ansible/roles/base/vars/sudo.yml
  - /etc/ansible/roles/base/vars/ssh.yml
  - /etc/ansible/roles/base/vars/grub.yml
  - /etc/ansible/roles/base/vars/logger.yml
  - /etc/ansible/roles/base/vars/logrotate.yml
  - /etc/ansible/roles/base/vars/directory.yml
  - /etc/ansible/roles/base/vars/profile.yml
  - /etc/ansible/roles/base/vars/fusioninventory.yml
  - /etc/ansible/roles/ips/vars/main.yml
  - /etc/ansible/roles/pulledpork/vars/main.yml
  - /etc/ansible/roles/barnyard2/vars/main.yml
  - /etc/ansible/roles/snorby/vars/main.yml
  - /etc/ansible/roles/mysql/vars/main.yml
  - /etc/ansible/roles/ips/vars/blocked-domains.yml
  - /etc/ansible/roles/ips/vars/protocol-anomaly.rules.yml
  - /etc/ansible/roles/ips/vars/fileblacklist.sha256.yml
  - /etc/ansible/roles/ips/vars/fileblacklist.sha1.yml
  - /etc/ansible/roles/ips/vars/fileblacklist.md5.yml
  - /etc/ansible/roles/ips/vars/local.rules.yml
  - /etc/ansible/roles/ips/vars/content.yml
  roles:
    - role: base
    - role: ips
    - role: barnyard2
    - role: pulledpork

```

#### IPS Rolü Değişkenleri
Bu roldeki değişkenler “**/etc/ansible/roles/ips/vars/**” dizini altında bulunan yml dosyalarında belirtilmiştir. yml dosyalarının içerikleri ve değişken bilgileri aşağıdaki gibidir;

-   “**blocked-domains.yml**” dosyasına engellenmesi istenen alan adları girilir. Her satırda bir alan adı olacak şekilde ekleme yapılır.
```
---
suricata_blocked_domains:
  - testsite123.com
  - badsitetesting.com

```

-   “**content.yml**” dosyasına engellenmesi veya alarm oluşturulması istenen içerikler girilir. Burada "**suricata_keyword_action**" alert veya drop olabilir. "**alert**" yazılırsa bu dosyada tanımlaması yapılan içerikler için alarm üretilir. "**drop**" yazılırsa ids modu için yine alarm üretilir fakat ips modu için engelleme yapılır. "**suricata_keyword_src**" kısmına alarm üretilcek/engellenecek trafiğinin kaynak adresi yazılır. Bu adres IP veya ağ veya bunların bir listesi olabilir. "**any**" yazılarak bütün kaynak adresler için bu kural tetiklenir. "**suricata_keyword_src_port**" kısmına alarm üretilcek/engellenecek trafiğinin kaynak portu yazılır. "**any**" yazılarak bütün kaynak portlar için bu kural tetiklenir. "**suricata_keyword_dst**" kısmına alarm üretilcek/engellenecek trafiğinin hedef adresi yazılır. Bu adres IP veya ağ veya bunların bir listesi olabilir. "**any**" yazılarak bütün hedef adresler için bu kural tetiklenir. "**suricata_keyword_dst_port**" kısmına alarm üretilcek/engellenecek trafiğinin hedef portu yazılır. "**any**" yazılarak bütün hedef portlar için bu kural tetiklenir.  "**suricata_keyword_msg**" kısmına bu kural tarafından üretilen alarmlarda geçecek mesaj tanımlanır.  "**suricata_keyword_proto**" kısmına bu kuralın çalışacağı protokoller liste olarak tanımlanır. TCP, UDP veya her ikisi birlikte yazılabilir. "**suricata_keywords**" kısmına her satıra bir içerik eklenerek engellenecek/alarm üretilecek içerikler belirtilir.
```
suricata_keyword_action: alert
suricata_keyword_src: any
suricata_keyword_src_port: any
suricata_keyword_dst: any
suricata_keyword_dst_port: any
suricata_keyword_msg: "Content detection: "
suricata_keyword_proto: ['tcp','udp']
suricata_keywords:
  - test zararli deneme

```

-   “**fileblacklist.md5.yml**” dosyasına engellenmesi veya alarm oluşturulması istenen hashler girilir. Burada "**suricata_blacklistmd5_action**" alert veya drop olabilir. "**alert**" yazılırsa bu dosyada tanımlaması yapılan hashler için alarm üretilir. "**drop**" yazılırsa ids modu için yine alarm üretilir fakat ips modu için engelleme yapılır. "**suricata_blacklistmd5_src**" kısmına alarm üretilcek/engellenecek trafiğinin kaynak adresi yazılır. Bu adres IP veya ağ veya bunların bir listesi olabilir. "**any**" yazılarak bütün kaynak adresler için bu kural tetiklenir. "**suricata_blacklistmd5_src_port**" kısmına alarm üretilcek/engellenecek trafiğinin kaynak portu yazılır. "**any**" yazılarak bütün kaynak portlar için bu kural tetiklenir. "**suricata_blacklistmd5_dst**" kısmına alarm üretilcek/engellenecek trafiğinin hedef adresi yazılır. Bu adres IP veya ağ veya bunların bir listesi olabilir. "**any**" yazılarak bütün hedef adresler için bu kural tetiklenir. "**suricata_blacklistmd5_dst_port**" kısmına alarm üretilcek/engellenecek trafiğinin hedef portu yazılır. "**any**" yazılarak bütün hedef portlar için bu kural tetiklenir.  "**suricata_blacklistmd5_msg**" kısmına bu kural tarafından üretilen alarmlarda geçecek mesaj tanımlanır.  "**suricata_blacklistmd5_sid**" kısmına bu kuralın sid'i yazılır. "**suricata_blacklistmd5_revision**" kısmına bu kuralın revision'u yazılır.  "**suricata_blacklistmd5**" kısmına her satıra bir md5 ve opsiyonal olarak dosya adı eklenerek engellenecek/alarm üretilecek dosya hashleri belirtilir.
```
suricata_blacklistmd5_action: alert
suricata_blacklistmd5_src: any
suricata_blacklistmd5_src_port: any
suricata_blacklistmd5_dst: any
suricata_blacklistmd5_dst_port: any
suricata_blacklistmd5_msg: "Black list checksum match MD5"
suricata_blacklistmd5_sid: 1089811401
suricata_blacklistmd5_rev: 1

suricata_blacklistmd5:
  - 2f8d0355f0032c3e6311c6408d7c2dc2  util-path.c
  - b9cf5cf347a70e02fde975fc4e117760
  - 02aaa6c3f4dbae65f5889eeb8f2bbb8d  util-pool.c
  - dd5fc1ee7f2f96b5f12d1a854007a818

```
-   “**fileblacklist.sha1.yml**” dosyasına engellenmesi veya alarm oluşturulması istenen hashler girilir. Burada "**suricata_blacklistsha1_action**" alert veya drop olabilir. "**alert**" yazılırsa bu dosyada tanımlaması yapılan hashler için alarm üretilir. "**drop**" yazılırsa ids modu için yine alarm üretilir fakat ips modu için engelleme yapılır. "**suricata_blacklistsha1_src**" kısmına alarm üretilcek/engellenecek trafiğinin kaynak adresi yazılır. Bu adres IP veya ağ veya bunların bir listesi olabilir. "**any**" yazılarak bütün kaynak adresler için bu kural tetiklenir. "**suricata_blacklistsha1_src_port**" kısmına alarm üretilcek/engellenecek trafiğinin kaynak portu yazılır. "**any**" yazılarak bütün kaynak portlar için bu kural tetiklenir. "**suricata_blacklistsha1_dst**" kısmına alarm üretilcek/engellenecek trafiğinin hedef adresi yazılır. Bu adres IP veya ağ veya bunların bir listesi olabilir. "**any**" yazılarak bütün hedef adresler için bu kural tetiklenir. "**suricata_blacklistsha1_dst_port**" kısmına alarm üretilcek/engellenecek trafiğinin hedef portu yazılır. "**any**" yazılarak bütün hedef portlar için bu kural tetiklenir.  "**suricata_blacklistsha1_msg**" kısmına bu kural tarafından üretilen alarmlarda geçecek mesaj tanımlanır.  "**suricata_blacklistsha1_sid**" kısmına bu kuralın sid'i yazılır. "**suricata_blacklistsha1_revision**" kısmına bu kuralın revision'u yazılır.  "**suricata_blacklistsha1**" kısmına her satıra bir sha1 ve opsiyonal olarak dosya adı eklenerek engellenecek/alarm üretilecek dosya hashleri belirtilir.
```
suricata_blacklistsha1_action: alert
suricata_blacklistsha1_src: any
suricata_blacklistsha1_src_port: any
suricata_blacklistsha1_dst: any
suricata_blacklistsha1_dst_port: any
suricata_blacklistsha1_msg: "Black list checksum match SHA1"
suricata_blacklistsha1_sid: 1089811402
suricata_blacklistsha1_rev: 1
suricata_blacklistsha1:

```
-   “**fileblacklist.sha256.yml**” dosyasına engellenmesi veya alarm oluşturulması istenen hashler girilir. Burada "**suricata_blacklistsha256_action**" alert veya drop olabilir. "**alert**" yazılırsa bu dosyada tanımlaması yapılan hashler için alarm üretilir. "**drop**" yazılırsa ids modu için yine alarm üretilir fakat ips modu için engelleme yapılır. "**suricata_blacklistsha256_src**" kısmına alarm üretilcek/engellenecek trafiğinin kaynak adresi yazılır. Bu adres IP veya ağ veya bunların bir listesi olabilir. "**any**" yazılarak bütün kaynak adresler için bu kural tetiklenir. "**suricata_blacklistsha256_src_port**" kısmına alarm üretilcek/engellenecek trafiğinin kaynak portu yazılır. "**any**" yazılarak bütün kaynak portlar için bu kural tetiklenir. "**suricata_blacklistsha256_dst**" kısmına alarm üretilcek/engellenecek trafiğinin hedef adresi yazılır. Bu adres IP veya ağ veya bunların bir listesi olabilir. "**any**" yazılarak bütün hedef adresler için bu kural tetiklenir. "**suricata_blacklistsha256_dst_port**" kısmına alarm üretilcek/engellenecek trafiğinin hedef portu yazılır. "**any**" yazılarak bütün hedef portlar için bu kural tetiklenir.  "**suricata_blacklistsha256_msg**" kısmına bu kural tarafından üretilen alarmlarda geçecek mesaj tanımlanır.  "**suricata_blacklistsha256_sid**" kısmına bu kuralın sid'i yazılır. "**suricata_blacklistsha256_revision**" kısmına bu kuralın revision'u yazılır.  "**suricata_blacklistsha256**" kısmına her satıra bir sha256 ve opsiyonal olarak dosya adı eklenerek engellenecek/alarm üretilecek dosya hashleri belirtilir.
```
suricata_blacklistsha256_action: alert
suricata_blacklistsha256_src: any
suricata_blacklistsha256_src_port: any
suricata_blacklistsha256_dst: any
suricata_blacklistsha256_dst_port: any
suricata_blacklistsha256_msg: "Black list checksum match SHA256"
suricata_blacklistsha256_sid: 1089811403
suricata_blacklistsha256_rev: 1

suricata_blacklistsha256:

```
-   “**local.rules.yml**” dosyasına doğrudan suricata imzaları her satırda bir tane olacak şekilde tanımlanır.
```
---
suricata_local_rules:

```
-   “**suricata_protocol_anomaly_rules.yml**” dosyasında protokol anormalliklerini tespit edecek bazı ön tanımlı imzalar girilmiştir. İstenirse her satırda bir tane olacak şekilde ek imzalar tanımlanabilir.
```
---
suricata_protocol_anomaly_rules:
  - alert tcp any any -> any ![80,8080] (msg:"SURICATA HTTP but not tcp port 80, 8080"; flow:to_server; app-layer-protocol:http; sid:2271001; rev:1;)
  - alert tcp any any -> any 80 (msg:"SURICATA Port 80 but not HTTP"; flow:to_server; app-layer-protocol:!http; sid:2271002; rev:1;)
  - alert http any any -> any 443 (msg:"SURICATA HTTP clear text on port 443"; flow:to_server; app-layer-protocol:http; sid:2271019; rev:1;)
  - alert tcp any any -> any 443 (msg:"SURICATA Port 443 but not TLS"; flow:to_server; app-layer-protocol:!tls; sid:2271003; rev:1;)
  - alert tcp any any -> any ![20,21] (msg:"SURICATA FTP but not tcp port 20 or 21"; flow:to_server; app-layer-protocol:ftp; sid:2271004; rev:1;)
  - alert tcp any any -> any [20,21] (msg:"SURICATA TCP port 21 but not FTP"; flow:to_server; app-layer-protocol:!ftp; sid:2271005; rev:1;)
  - alert tcp any any -> any ![25,587,465] (msg:"SURICATA SMTP but not tcp port 25,587,465"; flow:to_server; app-layer-protocol:smtp; sid:2271006; rev:1;)
  - alert tcp any any -> any [25,587,465] (msg:"SURICATA TCP port 25,587,465 but not SMTP"; flow:to_server; app-layer-protocol:!smtp; sid:2271007; rev:1;)
  - alert tcp any any -> any !22 (msg:"SURICATA SSH but not tcp port 22"; flow:to_server; app-layer-protocol:ssh; sid:2271008; rev:1;)
  - alert tcp any any -> any 22 (msg:"SURICATA TCP port 22 but not SSH"; flow:to_server; app-layer-protocol:!ssh; sid:2271009; rev:1;)
  - alert tcp any any -> any !143 (msg:"SURICATA IMAP but not tcp port 143"; flow:to_server; app-layer-protocol:imap; sid:2271010; rev:1;)
  - alert tcp any any -> any 143 (msg:"SURICATA TCP port 143 but not IMAP"; flow:to_server; app-layer-protocol:!imap; sid:2271011; rev:1;)
  - alert tcp any any -> any 139 (msg:"SURICATA TCP port 139 but not SMB"; flow:to_server; app-layer-protocol:!smb; sid:2271012; rev:1;)
  - alert tcp any any -> any [80,8080] (msg:"SURICATA DCERPC detected over port tcp 80,8080"; flow:to_server; app-layer-protocol:dcerpc; sid:2271013; rev:1;)
  - alert tcp any any -> any 53 (msg:"SURICATA TCP port 53 but not DNS"; flow:to_server; app-layer-protocol:!dns; sid:2271014; rev:1;)
  - alert udp any any -> any 53 (msg:"SURICATA UDP port 53 but not DNS"; flow:to_server; app-layer-protocol:!dns; sid:2271015; rev:1;)
  - alert tcp any any -> any 502 (msg:"SURICATA TCP port 502 but not MODBUS"; flow:to_server; app-layer-protocol:!modbus; sid:2271018; rev:1;)
```
-   “**main.yml**” dosyasında ips ayarlarının yapılması için gerekli ayar parametreleri bulunmaktadır. Burda ips yapılandırması için gerekli olan parametreler açıklanacaktır. "**suricata_mode**" ips için buraya ips yazılır. Eğer ips kurulacak makinede firewall kuralları fwbuilder tarafından yönetiliyorsa "**fwbuilder_exists**" paarametresi "**true**" yapılır yoksa "**false**" yapılır. "**suricata_ips_mode**" parametresi ips'in çalışma şeklini belirtmektedir. Router modu için "**nat**", bridge modu için "**bridge**" yazılır. Eğer ips bridge modunda çalışacaksa iç ağ trafiğinin geçeceği arabirim "**ips_int_iface**" dış ağ trafiğinin geçeceği arabirim "**ips_ext_iface**" parametrseinde ayarlanır. "**suricata_home_net:**" iç ağ tanımlarının yapıldığı değişkendir. "**suricata_external_net**" dış ağ tanımlarının yapıldığı parametredir. "**suricata_rules**" aktif edilecek imza gruplarının tanımlandığı yerdir. Aktif edilmesi istenmeyen parametreler başına "**#**" konularak yorum satırına alınabilir.
```
---
# defaults file for ansible-suricata
suricata_mode: "ids"#ids|ips
fwbuilder_exists: "false"
suricata_ips_mode: "bridge" #nat|bridge
ips_int_iface: enp1s3
ips_ext_iface: enp0s3
config_suricata: true  #defines if suricata should be configured
scripts_dir: /opt/scripts
suricata_home_net: "[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"
suricata_external_net: "!$HOME_NET"
suricata_http_servers: "$HOME_NET"
suricata_smtp_servers: "$HOME_NET"
suricata_sql_servers: "$HOME_NET"
suricata_dns_servers: "$HOME_NET"
suricata_telnet_servers: "$HOME_NET"
suricata_aim_servers: "$HOME_NET"
suricata_dnp3_server: "$HOME_NET"
suricata_dnp3_client: "$HOME_NET"
suricata_modbus_client: "$HOME_NET"
suricata_modbus_server: "$HOME_NET"
suricata_enip_client: "$HOME_NET"
suricata_enip_server: "$HOME_NET"
suricata_action_order: "$HOME_NET"
suricata_action_order:
  - pass
  - drop
  - reject
  - alert
suricata_af_packet_interfaces:
  - int: eth0
    threads: 1
    defrag: "yes"
    cluster_type: cluster_flow  #cluster_round_robin, cluster_flow or cluster_cpu
    cluster_id: 99
    copy_mode: ips
    copy_iface: eth1
    buffer_size: 64535
    disable_promisc: "no"  # Set to yes to disable promiscuous mode
    use_nmap: "yes"
  - int: eth1
    threads: 1
    defrag: "yes"
    cluster_type: cluster_flow  #cluster_round_robin, cluster_flow or cluster_cpu
    cluster_id: 98
    copy_mode: ips
    copy_iface: eth0
    buffer_size: 64535
    disable_promisc: "no"  # Set to yes to disable promiscuous mode
    use_nmap: "yes"
suricata_pcap_interfaces:
  - int: enp0s3
    # On Linux, pcap will try to use mmaped capture and will use buffer-size
    # as total of memory used by the ring. So set this to something bigger
    # than 1% of your bandwidth.
    buffer_size: 16777216
    bpf_filter: "tcp and port 25"
    # Choose checksum verification mode for the interface. At the moment
    # of the capture, some packets may be with an invalid checksum due to
    # offloading to the network card of the checksum computation.
    # Possible values are:
    #  - yes: checksum validation is forced
    #  - no: checksum validation is disabled
    #  - auto: suricata uses a statistical approach to detect when
    #  checksum off-loading is used. (default)
    # Warning: 'checksum-validation' must be set to yes to have any validation
    checksum_checks: auto
    # With some accelerator cards using a modified libpcap (like myricom), you
    # may want to have the same number of capture threads as the number of capture
    # rings. In this case, set up the threads variable to N to start N threads
    # listening on the same interface.
    threads: 16
    # set to no to disable promiscuous mode:
    promisc: no
    # set snaplen, if not set it defaults to MTU if MTU can be known
    # via ioctl call and to full capture if not.
    snaplen: 1518
# - int: INT1

suricata_classification_file: /etc/suricata/classification.config
suricata_config_file: /etc/suricata/suricata.yaml
suricata_config_outputs: true
suricata_default_rule_path: /etc/suricata/rules
suricata_flow_timeouts:
  - name: default
    new: 30
    established: 300
    closed: 0
    emergency_new: 10
    emergency_established: 100
    emergency_closed: 0
  - name: tcp
    new: 60
    established: 3600
    closed: 120
    emergency_new: 10
    emergency_established: 100
    emergency_closed: 20
  - name: udp
    new: 30
    established: 300
    emergency_new: 10
    emergency_established: 100
  - name: icmp
    new: 30
    established: 300
    emergency_new: 10
    emergency_established: 100
suricata_host_mode: auto  #defines surica operating mode...Options are auto, router (IPS-Mode) or sniffer-only (IDS-Mode)
#    suricata_include_files:  #Files included here will be handled as if they were inlined in the configuration file.
#        - include1.yaml
#        - include2.yaml
suricata_iface: "{{ ansible_default_ipv4.interface }}"  #Interface to listen on (for pcap mode)
suricata_interfaces:  #define the interfaces on your suricata host and define if offloading should be disabled.
  - int: eth0
    disable_offloading: false
    disable_features:
      - gro
      - gso
      - lro
      - rx
      - rxhash
      - rxvlan
      - sg
      - tso
      - tx
      - txvlan
      - ufo
  - int: eth1
    disable_offloading: false
    disable_features:
      - gro
      - gso
      - lro
      - rx
      - rxhash
      - rxvlan
      - sg
      - tso
      - tx
      - txvlan
      - ufo
suricata_listen_mode: pcap  #pcap, nfqueue or af-packet
suricata_log_dir: /var/log/suricata/
suricata_nfqueue: 0  #Queue number to listen on (for nfqueue mode)
suricata_oinkmaster_rules_url: http://rules.emergingthreats.net/open/suricata/emerging.rules.tar.gz
suricata_outputs:
  - name: fast
    enabled: "yes"
    filename: fast.log
    append: "yes"
  - name: eve-log
    enabled: "yes"
    type: file  #file|syslog|unix_dgram|unix_stream
    filename: eve.json
    types:
      - name: alert
      - name: http
        config_addl: true  #defines if additional parameters are to be defined....required for template check
        extended: "yes"  # enable this for extended logging information
      - name: dns
      - name: tls
        config_addl: true  #defines if additional parameters are to be defined....required for template check
        extended: "yes"  # enable this for extended logging information
      - name: files
        config_addl: true  #defines if additional parameters are to be defined....required for template check
        force_magic: "yes"  # force logging magic on all logged files
        force_md5: "yes"  # force logging of md5 checksums
#      - name: "drop"
      - name: ssh
      - name: smtp
      - name: flow
  - name: unified2-alert
    enabled: "yes"
    filename: unified2.alert
    limit: 32mb  # File size limit.  Can be specified in kb, mb, gb.
    xff:
      - var: enabled
        val: "no"
      - var: mode
        val: extra-data
      - var: header
        val: X-Forwarded-For
  - name: http-log
    enabled: "yes"
    filename: http.log
    append: "yes"
  - name: tls-log
    enabled: "no"
    filename: tls.log
    append: "yes"
    certs_log_dir: certs
  - name: dns-log
    enabled: "no"
    filename: dns.log
    append: "yes"
  - name: pcap-info
    enabled: "no"
  - name: pcap-log
    enabled: "no"
    filename: log.pcap
    limit: 1000mb
    max_files: 2000
    mode: normal  # normal or sguil
    use_stream_depth: "no"  #If set to "yes" packets seen after reaching stream inspection depth are ignored. "no" logs all packets
  - name: alert-debug
    enabled: "no"
    filename: alert-debug.log
    append: "yes"
  - name: alert-prelude
    enabled: "no"
    profile: suricata
    log_packet_content: "no"
    log_packet_header: "yes"
  - name: stats
    enabled: "yes"
    filename: stats.log
    interval: 8
  - name: syslog
    enabled: "no"
    facility: local5
    level: Info  # possible levels: Emergency, Alert, Critical, Error, Warning, Notice, Info, Debug
  - name: drop
    enabled: "no"
    filename: drop.log
    append: "yes"
  - name: file-store
    enabled: "no"
    log_dir: files
    force_magic: "no"
    force_md5: "no"
  - name: file-log
    enabled: "no"
    filename: files-json.log
    append: "yes"
    force_magic: "no"
    force_md5: "no"
suricata_pfring_interfaces:
  - int: eth0
    threads: 1
    cluster_id: 99
    cluster_type: cluster_flow
  - int: eth1
    threads: 1
    cluster_id: 93
    cluster_type: cluster_flow
suricata_reference_config_file: /etc/suricata/reference.config
suricata_rules:
  - botcc.rules
  - ciarmy.rules
  - compromised.rules
  - drop.rules
  - dshield.rules
  - emerging-activex.rules
  - emerging-attack_response.rules
  - emerging-chat.rules
  - emerging-current_events.rules
  - emerging-dns.rules
  - emerging-dos.rules
  - emerging-exploit.rules
  - emerging-ftp.rules
  - emerging-games.rules
  - emerging-icmp_info.rules
# - emerging-icmp.rules
  - emerging-imap.rules
  - emerging-inappropriate.rules
  - emerging-malware.rules
  - emerging-misc.rules
  - emerging-mobile_malware.rules
  - emerging-netbios.rules
  - emerging-p2p.rules
  - emerging-policy.rules
  - emerging-pop3.rules
  - emerging-rpc.rules
  - emerging-scada.rules
  - emerging-scan.rules
  - emerging-shellcode.rules
  - emerging-smtp.rules
  - emerging-snmp.rules
  - emerging-sql.rules
  - emerging-telnet.rules
  - emerging-tftp.rules
  - emerging-trojan.rules
  - emerging-user_agents.rules
  - emerging-voip.rules
  - emerging-web_client.rules
  - emerging-web_server.rules
  - emerging-web_specific_apps.rules
  - emerging-worm.rules
  - tor.rules
  - dns_query.rules
  - protocol-anomaly.rules
  - blacklist.rules
  - local.rules
  - content.rules
  - decoder-events.rules # available in suricata sources under rules dir
  - stream-events.rules  # available in suricata sources under rules dir
  - http-events.rules    # available in suricata sources under rules dir
  - smtp-events.rules    # available in suricata sources under rules dir
  - dns-events.rules     # available in suricata sources under rules dir
  - tls-events.rules     # available in suricata sources under rules dir
suricata_run_initd: 'yes'  #set to yes to start the server in the init.d script
suricata_suppress_list:  #Defines a list of alerts to suppress
  - gen_id: 1
    sig_id: 2210020
#    track: by_src  #options are: by_src|by_dst
#    ip_addresses:  #define IP addressORsubnet if setting up track by
#      - 172.16.0.0/16
#      - 192.168.1.0/24
  - gen_id: 1
    sig_id: 2210021
  - gen_id: 1
    sig_id: 2210029
suricata_ubuntu_ppa: ppa:oisf/suricata-stable  #Options are ppa:oisf/suricata-stable, ppa:oisf/suricata-beta or ppa:oisf/suricata-daily
suricata_unix_command:
  enabled: "no"
#        filename: custom.socket

```

# Pulledpork

Pulledpork rolü "**ids**" ve "**ips**" tarafından kullanılmaktadır.


#### Pulledpork Rolü Değişkenleri
Bu roldeki değişkenler “**/etc/ansible/roles/pulledpork/vars/**” dizini altında bulunan yml dosyalarında belirtilmiştir. yml dosyalarının içerikleri ve değişken bilgileri aşağıdaki gibidir;

-   “**main.yml**” dosyasındaki parametreler şu şekildedir: "**pulledpork_etpro_key**" Emerging Threats Pro lisansı için kullanılan anahtardır. "**pulledpork_rule_url**" Pulledpork tarafından suricata imzalarının indirileceği URL'dir. "**pulledpork_rule_file**" Pulledpork tarafından indirilecek imza dosyasının adıdır. "**pulledpork_update_frequency**" Pulledpork güncelleme sıklığının belirlendiği parametredir.
```
pulledpork_etpro_key: open
pulledpork_rule_url: https://rules.emergingthreats.net/
pulledpork_rule_file: emerging.rules.tar.gz
pulledpork_exclude_rules:
#  - pass
pulledpork_update_frequency: daily

```

# Barnyard2

Barnyard2 rolü "**ids**" ve "**ips**" tarafından kullanılmaktadır.


#### Barnyard2 Rolü Değişkenleri
Bu roldeki değişkenler “**/etc/ansible/roles/barnyard2/vars/**” dizini altında bulunan yml dosyalarında belirtilmiştir. yml dosyalarının içerikleri ve değişken bilgileri aşağıdaki gibidir;

-   “**main.yml**” dosyasındaki parametreler şu şekildedir: "**barnyard2_interface**" Aslında görsel amaçlı kullanılmaktadır. Alarmların ids/ips'in hangi arabirimden geldiğini belirlemek için kullanılır. "**barnyard2_mysql_user**" Barnyard'ın alarmları göndereceği mysql sunucusuna bağlanırken kullanacağı kullanıcı adıdır. "**barnyard2_mysql_password**" Barnyard'ın alarmları göndereceği mysql sunucusuna bağlanırken kullanacağı şifredir. "**barnyard2_mysql_host**" Barnyard'ın alarmları göndereceği mysql sunucusunun adresidir. "**barnyard2_sensor_name**" Görsellik amaçlı alarmların geldiği sensörün adıdır.
```
---
barnyard2_interface: enp0s3
barnyard2_mysql_user: root
barnyard2_mysql_password: root
barnyard2_host: 127.0.0.1
barnyard2_sensor_name: ids_1

```


# Snorby
Ahtapot projesi kapsamında Snorby işlevinin kurulumunu ve yönetimini sağlayan playbook’dur. “**/etc/ansible/playbooks/**” dizini altında bulunan “**snorby.yml**” dosyasına bakıldığında, “**hosts**” satırında Ansible’a ait “**/etc/ansible/**” altında bulunan “**hosts**” dosyasında “**[snorby]**” satırı altına yazılmış tüm sunucularda bu playbookun oynatılacağı belirtilir. “**sudo**” satırı ile çalışacak komutların sudo yetkisi ile çalışması belirlenir. “**vars_files**” satırı ids playbookunun değişken dosyalarını belirtmektedir. “**roles**” satırı altında bulunan satırlarda ise bu playbook çalıştığında “**base**”, “ ve “**snorby**”rollerinin çalışacağı belirtilmektedir.
```
- hosts: snorby
  sudo: yes
  vars_files:
  - /etc/ansible/roles/base/vars/group.yml
  - /etc/ansible/roles/base/vars/user.yml
  - /etc/ansible/roles/base/vars/repo.yml
  - /etc/ansible/roles/base/vars/rsyslog.yml
  - /etc/ansible/roles/base/vars/ntp.yml
  - /etc/ansible/roles/base/vars/package.yml
  - /etc/ansible/roles/base/vars/kernelmodules_remove.yml
  - /etc/ansible/roles/base/vars/kernelmodules_blacklist.yml
  - /etc/ansible/roles/base/vars/host.yml
  - /etc/ansible/roles/base/vars/audit.yml
  - /etc/ansible/roles/base/vars/sudo.yml
  - /etc/ansible/roles/base/vars/ssh.yml
  - /etc/ansible/roles/base/vars/grub.yml
  - /etc/ansible/roles/base/vars/logger.yml
  - /etc/ansible/roles/base/vars/logrotate.yml
  - /etc/ansible/roles/base/vars/directory.yml
  - /etc/ansible/roles/base/vars/profile.yml
  - /etc/ansible/roles/base/vars/fusioninventory.yml
  - /etc/ansible/roles/snorby/vars/main.yml

  roles:
    - role: base
    - role: snorby

```

#### Snorby Rolü Değişkenleri
Bu roldeki değişkenler “**/etc/ansible/roles/snorby/vars/**” dizini altında bulunan yml dosyalarında belirtilmiştir. yml dosyalarının içerikleri ve değişken bilgileri aşağıdaki gibidir;

-   “**main.yml**” dosyasındaki parametreler şu şekildedir: "**snorby_company_name**" snorby arayüzünde görüntülenecek kurum ismidir. "**snorby_domain**" parametresi snorby'nin çalıştığı alan adıdır. "**snorby_email**" snorby arabirimine giriş için kullanılacak ve e-postaların göderileceği e-posta adresidir. "**snorby_password**" snorby girişinde kullanılacak şifredir. "**snorby_mysql_user**" snorby'nin mysql sunucusuna bağlanırken kullandığı kullanıcı adıdır. "**snorby_mysql_password**" snorby'nin mysql' bağlanırken kullanacağı şifredir. "**snorby_mysql_host**" snorby'nin kullandığı mysql sunucusunun çalıştığı adrestir.
```
---
snorby_company_name: Ahtapot
snorby_domain: pardus
snorby_email: snorby@pardus
snorby_password: snorby
snorby_mysql_user: snorby
snorby_mysql_password: snorby
snorby_mysql_host: localhost
```

