
# Antispam
Ahtapot projesi kapsamında Antispam işlevinin kurulumunu ve yönetimini sağlayan playbook’dur. “**/etc/ansible/playbooks/**” dizini altında bulunan “**antispam.yml**” dosyasına bakıldığında, “**hosts**” satırında Ansible’a ait “**/etc/ansible/**” altında bulunan “**hosts**” dosyasında “**[antispam]**” satırı altına yazılmış tüm sunucularda bu playbookun oynatılacağı belirtilir. “**sudo**” satırı ile çalışacak komutların sudo yetkisi ile çalışması belirlenir. “**vars_files**” satırı antispam playbookunun değişken dosyalarını belirtmektedir. “**roles**” satırı altında bulunan satırlarda ise bu playbook çalıştığında “**base**” ve “**spamassassin**”rollerinin çalışacağı belirtilmektedir.


```
- hosts: antispam
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
  - /etc/ansible/roles/spamassassin/vars/main.yml
  - /etc/ansible/roles/spamassassin/vars/clamd.conf.yml
  - /etc/ansible/roles/spamassassin/vars/freshclam.conf.yml
  - /etc/ansible/roles/spamassassin/vars/local.cf.yml
  - /etc/ansible/roles/spamassassin/vars/main.cf.yml
  - /etc/ansible/roles/spamassassin/vars/master.cf.yml

  roles:
    - role: base
    - role: spamassassin
```

#### Spamassassin Rolü Değişkenleri
Bu roldeki değişkenler “**/etc/ansible/roles/spamassassin/vars/**” dizini altında bulunan yml dosyalarında belirtilmiştir. yml dosyalarının içerikleri ve değişken bilgileri aşağıdaki gibidir;


-   “**main.yml**” dosyasında bulunan değişkenlerin görevi şu şekildedir. "**antispam_smtpd_tls_cert_file**" değişkeni, antispam sisteminde oluşturulan cert dosyasının bulunduğu dosya yolunu belirtmektedir. Varsayılan olarak bu konumda oluşturulmaktadır. "**antispam_smtpd_tls_key_file**" değişkeni, antispam sisteminde oluşturulan key dosyasının bulunduğu dosya yolunu belirtmektedir. Varsayılan olarak bu konumda oluşturulmaktadır.. "**antispam_smtpd_tls_CAfile**" değişkeni, antispam sisteminde oluşturulan ca dosyasının bulunduğu dosya yolunu belirtmektedir. Varsayılan olarak bu konumda oluşturulmaktadır. "**antispam_mail_hostname**" değişkeni antispam sisteminin temiz e-postaları aktaracağı e-posta sunucusunun alan adıdır. "**antispam_domain**" değişkeni antispam sisteminin bulunduğu alanın adının belirtildiği değişkendir.  "**antispam_inet_protocols**" değişkeni antispam sisteminin çalışacağı IP protokolünün belirtildiği değişkendir. ipv4, ipv6 veya all yazılabilir. "**antispam_nameserver**" değişkeni antispam sistemi tarafından kullanılacak DNS sunucusunun belirtildiği değişkendir. "**antispam_block_encrypted_archive**" şifreli arşiv dosyalarının engellenip engellenmeyeceğinin belirtildiği değişkendir. "**antispam_create_ssl**", ssl sertifikasının yaratilip yaratilmayacaginin belirlendigi değişkendir.  "**antispam_ssl_**" ile başlayan değişkenler, antispam sistemi üzerinde oluşturulacak ssl anahtarı ile ilgili bilgilerin ayarlandığı değişkenlerdir. "**antispam_default_relay_server**" varsayılan relay sunucunun IP adresinin belirtildiği değişkendir. "**antispam_allowed_senders**" bizim antispam sunucumuza mail relay edebilecek guvenilir smtp adreslerinin tanımlandığı değişkendir.  "**antispam_spam_subject_tag**", spam olarak işaretlenen e-postaların başlığına yazılacak etiketin isminin belirtildiği değişkendir. "**antispam_spam_modifies_subj**" spam olarak belirlenen e-postalarının başlığının değiştirilip değiştirilmeyeceğinin belirlendiği değişkendir. 1 ise başlık değiştirilir, 0 ise değiştirilmez. "**antispam_tag_level_deflt**" spam olması muhtemel e-postalar için minimum skorun belirtildiği değişkendir. "**antispam_tag2_level_deflt**" spam olması muhtemel e-postalar için maksimum skorun belirtildiği değişkendir. "**antispam_kill_level_deflt**" kesin spam olduğuna karar verilmesi için gereken minimum skorun belirtildiği değişkendir. "**antispam_smtpd_recipient_limit**" bir e-postanın gönderilebileceği maksimum alıcı sayısının belirtildiği değişkendir. "**antispam_smtp_tls_ciphers**" oportünistik TLS şifreleme sırasında asgari olarak kullanılacak TLS şifreleme seviyesinin belirtildiği değişkendir. "**antispam_parent_domain_matches_subdomains**" "example.com" paterninin example.com alan adının alt alan adlarına da açıkca ".example.com" yazmadan eşleştirileceği özellik listesinin belirlendiği parametredir. "**antispam_smtp_tls_security_level**"SMTP TLS güvenlik seviyesinin belirtildiği değişkendir. "**antispam_smtpd_use_tls**" oportünistik TLS kullanımının belirtildiği değişkendir. "**antispam_smtp_tls_note_starttls_offer**" uzak bir SMTP sunucusunun, o sunucu için TLS aktif edilmemişken, STARTTLS önerdiği durumda kayıt altına alınıp alınmayacağının belirtildiği parametredir. "**antispam_smtpd_tls_session_cache_timeout**" Postfix SMTP sunucusunun TLS oturum önbellek bilgisinin sonlanma süresinin belirtildiği değişkendir. "**antispam_message_size_limit**" Bir mesajın, zarf bilgileri de dahil olabileceği maksimum boyutun byte cinsinden belirtildiği değişkendir.  "**antispam_smtpd_tls_received_header**" Postfix SMTP sunucusunun, kullanılan protokol, şifreleme, uzak sunucu CommonName ve istemci sertifika sağlayıcısının CommonName bilgilerini içeren Recieved: mesaj başlığı oluşturmasının açılıp kapatıldığı değişkendir. "**antispam_MaxScanSize**" her bir dosyanın maksimum ne kadarlık kısmının taratılacağının belirtildiği değişkendir. "**antispam_MaxFileSize**" antivirüs taramasından geçirilecek maksimum dosya boyutunun belirtildiği değişkendir. "**antispam_MaxDirectoryRecursion**" Antivirüs taramasında bakılacak maksimum dizin derinliğinin belirtildiği değişkendir.  "**antispam_MaxRecursion**" Antivirüs taramasında bakılacak maksimum arşiv derinliğinin belirtildiği değişkendir.   "**antispam_OLE2BlockMacros**" VBA makrolarına sahip OLE2 dosyalarının engellenip engellenmeyeceğinin belirtildiği değişkendir. "**antispam_MaxFiles**" bir arşiv, döküman veya herhangi bir başka konteyner içinde taranacak maksimum dosya sayısının belirtildiği değişkendir. "**antispam_StreamMaxLength**" antivirüs uygulaması tarafından kabul edilecek maksimum dosya boyutudur. "**antispam_spoof_sender**" ile tanımlanmış göndericiden ve "**antispam_spoof_recipient**" ile tanımlanmış alıcıya giden e-postaların aldatmaca olarak tanımlanıp engellenmesi sağlanmaktadır. "**antispam_relay_domains**" antispam tarafından e-postaların hangi sunuculara relay edileceğinin belirtildiği değişkendir.  "**antispam_transport_domains**" bu anahtar-değer biçimindeki değişken ile anahtar kısmına yazılmış sunucundan, değer kısmına yazılmış sunucuya e-postalar iletilmektedir. "**clamav_check_freq**" clamav veritabanı güncelliğinin bir gün içinde kaç kez kontrol edileceğinin belirtildiği değişkendir. "**use_quarantine**" ile sistemde karantina sunucusunun kullanılıp kullanılmayacağı belirtilmektedir. "**quarantine_db_host**" karantina sunucusunun veritabanının IP adresinin belirtildiği değişkendir.  "**quarantine_db_user**" karantina sunucusunun veritabanının kullanıcı adının belirtildiği değişkendir.  "**quarantine_db_pass**" karantina sunucusunun veritabanının şifresinin belirtildiği değişkendir. "**antispam_smtpd_banner**" bu anahtar-değer biçimindeki değişkende anahtar tarafına yazılan sunucu adına sahip sunucu için (ansible host dosyasındaki isimle aynı olmalı), dış dünyaya, sunucu adı olarak değer tarafına yazılan girdi gösterilmektedir. Bunun amaci sunucu isminin dış dünyaya afişe edilmemesinin sağlanmasıdır. Ornegin asagidaki yapilandirma dosyasinda gerçek alan adi ANSIBLE_FQDN olan sunucu için dış dünyaya sunucu adı MAIL_HOSTNAME_TO_BE_SHOWED olarak gösterilecektir.  "**clamav_mirrors**" clamav'ın hangi sunuculardan güncelleme alacağının belirtildiği değişkendir. "**spam_regexes**" altına tek tek spam olarak algılanması istenen düzenli ifadeler eklenmelidir. Burada "**name**" kullanıcı tarafından belirlenen ayırt edici bir isimdir. "**where**" ise bu düzenli ifadenin mailin hangi kesiminde aratılacağının belirtildiği parametredir. "**regex**" istenen düzenli ifadenin yazıldığı parametredir. "**score**" parametresi spamassasin tarafından bu düzenli ifadeye uyan bir e-postaya kaç skor verileceğinin belirlendiği parametredir. "**describe**" parametresi ise bu düzenli ifade kuralının açıklamasının yazıldığı parametredir. "**antispam_block_filetypes**" değişkeninde her satırda engellenmesi istenen dosya tipleri belirtilir.  "**antispam_block_mimetypes**" değişkeninde her satırda engellenmesi istenen mime tipleri belirtilir. "**antispam_block_fileextensions**" değişkeninde her satırda engellenmesi istenen dosya uzantıları belirtilir.  "**antispam_whitelist_address_domain**" değişkeninde her satırda engellenmesi istenmeyen alan adları belirtilir.  "**antispam_blacklist_address_domain**" değişkeninde her satırda engellenmesi istenen alan adları belirtilir. "**antispam_whitelist_receiver_ip**" değişkeninde her satırda engellenmesi istenmeyen alıcı IP adresleri belirtilir. "**antispam_whitelist_sender_ip**" değişkeninde her satırda engellenmesi istenmeyen gönderici IP adresleri belirtilir. "**antispam_blacklist_receiver_ip**" değişkeninde her satırda engellenmesi istenen alıcı IP adresleri belirtilir. "**antispam_blacklist_sender_ip**" değişkeninde her satırda engellenmesi istenen gönderici IP adresleri belirtilir. 


```
---
antispam_smtpd_tls_cert_file: /etc/postfix/ssl/smtpd.crt
antispam_smtpd_tls_key_file: /etc/postfix/ssl/smtpd.key
antispam_smtpd_tls_CAfile: /etc/postfix/ssl/cacert.pem
antispam_mail_hostname: mail
antispam_domain: ahtapot
antispam_inet_protocols: ipv4 #ipv4, ipv6, all
antispam_nameserver: 8.8.8.8
antispam_create_ssl: False
antispam_ssl_country: "TR"
antispam_ssl_state: "Ankara"
antispam_ssl_locality: "Ankara"
antispam_ssl_organization: "organizasyon_adi"
antispam_ssl_organizationalunit: "organizasyon_birimi"
antispam_ssl_commonname: "alan_adi"
antispam_default_relay_server: "IP"
antispam_allowed_senders: "IP"
antispam_spam_subject_tag: "***SPAM***"
antispam_spam_modifies_subj: 1
antispam_tag_level_deflt: 2.0
antispam_tag2_level_deflt: 6.31
antispam_kill_level_deflt: 6.31
antispam_smtpd_recipient_limit: 1000
antispam_smtp_tls_ciphers: "medium"
antispam_parent_domain_matches_subdomains: "debug_peer_list,fast_flush_domains,mynetworks,permit_mx_backup_networks,qmqpd_authorized_clients,relay_domains,smtpd_access_maps"
antispam_smtp_tls_security_level: "may"
antispam_smtpd_use_tls: "yes"
antispam_smtp_tls_note_starttls_offer: "yes"
antispam_smtpd_tls_received_header: "yes"
antispam_smtpd_tls_session_cache_timeout: "3600s"
antispam_message_size_limit: "26214400" # bytes
antispam_block_encrypted_archive: "true"
antispam_MaxDirectoryRecursion: "15"
antispam_OLE2BlockMacros: "true"
antispam_MaxScanSize: "100M"
antispam_MaxFileSize: "25M"
antispam_MaxRecursion: "16"
antispam_MaxFiles: "10000"
antispam_StreamMaxLength: "25M"
antispam_spoof_sender: "example.net"
antispam_spoof_recipient: "example.net"
antispam_relay_domains: "{{antispam_domain}},example.org"
antispam_transport_domains: { transport.example.org: 10.10.10.10 } 
use_quarantine: "True"
quarantine_db_host: "10.10.10.10"
quarantine_db_user: "ahtapot"
quarantine_db_pass: "ahtapot"
antispam_smtpd_banner: { ANSIBLE_FQDN: MAIL_HOSTNAME_TO_BE_SHOWED  }
clamav_check_freq: 24
clamav_mirrors:
  - db.local.clamav.net
  - database.clamav.net
spam_regexes:
  - name: PORN
    where: full
    regex: /porn/i
    score: 20
    describe: Spam Warning
antispam_block_filetypes:
  - exe-ms
antispam_block_mimetypes:
  - application/x-msdownload
  - application/x-msdos-program
  - application/hta
antispam_block_fileextensions:
  - exe
  - vbs
  - pif
  - scr
  - bat
  - cmd
  - com
  - cpl
antispam_whitelist_address_domain:
  - example.com
antispam_blacklist_address_domain:
  #-
antispam_whitelist_receiver_ip:
  - 192.0.2.254
antispam_whitelist_sender_ip:
  #-
antispam_blacklist_receiver_ip:
  #-
antispam_blacklist_sender_ip:
  #-
```


-   “**clamd.conf.yml**” dosyasında bulunan "**clamd_conf**" değişkeni, clamd.conf dosyasının işlenmemiş halini içermektedir. Eğer ana ayar dosyamız olan "**main.yml**" dosyasında bulunan değişkenler ile, karşılanamayan bir isteriniz mevcut ise bu değişkenin içerisinden direk hedef sistemde çalışacak olan "**clamd.conf**" dosyasını düzenleyebilirsiniz.
```
---
clamd_conf: |
  LocalSocket /var/run/clamav/clamd.ctl
  FixStaleSocket true
  LocalSocketGroup clamav
  LocalSocketMode 666
  # TemporaryDirectory is not set to its default /tmp here to make overriding
  # the default with environment variables TMPDIR/TMP/TEMP possible
  User clamav
  ScanMail true
  ScanArchive true
  ArchiveBlockEncrypted {{antispam_block_encrypted_archive}}
  MaxDirectoryRecursion {{antispam_MaxDirectoryRecursion}}
  FollowDirectorySymlinks false
  FollowFileSymlinks false
  ReadTimeout 180
  MaxThreads 12
  MaxConnectionQueueLength 15
  LogSyslog false
  LogRotate true
  LogFacility LOG_LOCAL6
  LogClean false
  LogVerbose false
  DatabaseDirectory /var/lib/clamav
  OfficialDatabaseOnly false
  SelfCheck 3600
  Foreground false
  Debug false
  ScanPE true
  MaxEmbeddedPE 10M
  ScanOLE2 true
  ScanPDF true
  ScanHTML true
  MaxHTMLNormalize 10M
  MaxHTMLNoTags 2M
  MaxScriptNormalize 5M
  MaxZipTypeRcg 1M
  ScanSWF true
  DetectBrokenExecutables false
  ExitOnOOM false
  LeaveTemporaryFiles false
  AlgorithmicDetection true
  ScanELF true
  IdleTimeout 30
  CrossFilesystems true
  PhishingSignatures true
  PhishingScanURLs true
  PhishingAlwaysBlockSSLMismatch false
  PhishingAlwaysBlockCloak false
  PartitionIntersection false
  DetectPUA false
  ScanPartialMessages false
  HeuristicScanPrecedence false
  StructuredDataDetection false
  CommandReadTimeout 5
  SendBufTimeout 200
  MaxQueue 100
  ExtendedDetectionInfo true
  OLE2BlockMacros {{antispam_OLE2BlockMacros}}
  ScanOnAccess false
  AllowAllMatchScan true
  ForceToDisk false
  DisableCertCheck false
  DisableCache false
  MaxScanSize {{antispam_MaxScanSize}}
  MaxFileSize {{antispam_MaxFileSize}}
  MaxRecursion {{antispam_MaxRecursion}}
  MaxFiles {{antispam_MaxFiles}}
  MaxPartitions 50
  MaxIconsPE 100
  PCREMatchLimit 10000
  PCRERecMatchLimit 5000
  PCREMaxFileSize 25M
  ScanXMLDOCS true
  ScanHWP3 true
  MaxRecHWP3 16
  StatsEnabled false
  StatsPEDisabled true
  StatsHostID auto
  StatsTimeout 10
  StreamMaxLength {{antispam_StreamMaxLength}}
  LogFile /var/log/clamav/clamav.log
  LogTime true
  LogFileUnlock false
  LogFileMaxSize 0
  Bytecode true
  BytecodeSecurity TrustSigned
  BytecodeTimeout 60000

```
-   “**freshclam.conf.yml**” dosyasında bulunan "**freshclam_conf**" değişkeni, clamd.conf dosyasının işlenmemiş halini içermektedir. Eğer ana ayar dosyamız olan "**main.yml**" dosyasında bulunan değişkenler ile, karşılanamayan bir isteriniz mevcut ise bu değişkenin içerisinden direk hedef sistemde çalışacak olan "**freshclam.conf**" dosyasını düzenleyebilirsiniz.
```
---
freshclam_conf: |
  DatabaseOwner clamav
  UpdateLogFile /var/log/clamav/freshclam.log
  LogVerbose false
  LogSyslog false
  LogFacility LOG_LOCAL6
  LogFileMaxSize 0
  LogRotate true
  LogTime true
  Foreground false
  Debug false
  MaxAttempts 5
  DatabaseDirectory /var/lib/clamav
  DNSDatabaseInfo current.cvd.clamav.net
  ConnectTimeout 30
  ReceiveTimeout 30
  TestDatabases yes
  ScriptedUpdates yes
  CompressLocalDatabase no
  SafeBrowsing false
  Bytecode true
  NotifyClamd /etc/clamav/clamd.conf
  # Check for new database 24 times a day
  Checks {{clamav_check_freq}}
```
-   “**local.cf.yml**” dosyasında bulunan "**local_cf**" değişkeni, clamd.conf dosyasının işlenmemiş halini içermektedir. Eğer ana ayar dosyamız olan "**main.yml**" dosyasında bulunan değişkenler ile, karşılanamayan bir isteriniz mevcut ise bu değişkenin içerisinden direk hedef sistemde çalışacak olan "**local.cf**" dosyasını düzenleyebilirsiniz.
```
---
local_cf: |
  # This is the right place to customize your installation of SpamAssassin.
  #
  # See perldoc Mail::SpamAssassin::Conf for details of what can be
  # tweaked.
  #
  # Only a small subset of options are listed below
  #
  ###########################################################################
  
  #   Add *****SPAM***** to the Subject header of spam e-mails
  #
  # rewrite_header Subject *****SPAM*****
  
  
  #   Save spam messages as a message/rfc822 MIME attachment instead of
  #   modifying the original message (0: off, 2: use text/plain instead)
  #
  # report_safe 1
  
  
  #   Set which networks or hosts are considered trusted by your mail
  #   server (i.e. not spammers)
  #
  # trusted_networks 212.17.35.
  
  
  #   Set file-locking method (flock is not safe over NFS, but is faster)
  #
  # lock_method flock
  
  
  #   Set the threshold at which a message is considered spam (default: 5.0)
  #
  # required_score 5.0
  
  
  #   Use Bayesian classifier (default: 1)
  #
  # use_bayes 1
  
  
  #   Bayesian classifier auto-learning (default: 1)
  #
  # bayes_auto_learn 1
  
  
  #   Set headers which may provide inappropriate cues to the Bayesian
  #   classifier
  #
  # bayes_ignore_header X-Bogosity
  # bayes_ignore_header X-Spam-Flag
  # bayes_ignore_header X-Spam-Status
  
  
  #   Whether to decode non- UTF-8 and non-ASCII textual parts and recode
  #   them to UTF-8 before the text is given over to rules processing.
  #
  # normalize_charset 1
  
  #   Some shortcircuiting, if the plugin is enabled
  # 
  ifplugin Mail::SpamAssassin::Plugin::Shortcircuit
  #
  #   default: strongly-whitelisted mails are *really* whitelisted now, if the
  #   shortcircuiting plugin is active, causing early exit to save CPU load.
  #   Uncomment to turn this on
  #
  # shortcircuit USER_IN_WHITELIST       on
  # shortcircuit USER_IN_DEF_WHITELIST   on
  # shortcircuit USER_IN_ALL_SPAM_TO     on
  # shortcircuit SUBJECT_IN_WHITELIST    on
  
  #   the opposite; blacklisted mails can also save CPU
  #
  # shortcircuit USER_IN_BLACKLIST       on
  # shortcircuit USER_IN_BLACKLIST_TO    on
  # shortcircuit SUBJECT_IN_BLACKLIST    on
  
  #   if you have taken the time to correctly specify your trusted_networks,
  #   this is another good way to save CPU
  #
  # shortcircuit ALL_TRUSTED             on
  
  #   and a well-trained bayes DB can save running rules, too
  #
  # shortcircuit BAYES_99                spam
  # shortcircuit BAYES_00                ham
  
  endif # Mail::SpamAssassin::Plugin::Shortcircuit
  
  score SPF_FAIL 4.0
  score SPF_HELO_FAIL 4.0
  score SPF_HELO_SOFTFAIL 3.0
  score SPF_SOFTFAIL 3.0
```

-   “**main.cf.yml**” dosyasında bulunan "**main_cf**" değişkeni, clamd.conf dosyasının işlenmemiş halini içermektedir. Eğer ana ayar dosyamız olan "**main.yml**" dosyasında bulunan değişkenler ile, karşılanamayan bir isteriniz mevcut ise bu değişkenin içerisinden direk hedef sistemde çalışacak olan "**main.cf**" dosyasını düzenleyebilirsiniz.
```
---
main_cf: |
  # See /usr/share/postfix/main.cf.dist for a commented, more complete version
  
  
  # Debian specific:  Specifying a file name will cause the first
  # line of that file to be used as the name.  The Debian default
  # is /etc/mailname.
  #myorigin = /etc/mailname
  
  smtpd_banner = {{antispam_smtpd_banner[ansible_hostname]}}
  biff = no
  
  # appending .domain is the MUAs job.
  append_dot_mydomain = no
  
  # Uncomment the next line to generate delayed mail warnings
  #delay_warning_time = 4h
  
  readme_directory = no
  
  # See http://www.postfix.org/COMPATIBILITY_README.html -- default to 2 on
  # fresh installs.
  compatibility_level = 2
  
  # TLS parameters
  smtpd_tls_cert_file={{antispam_smtpd_tls_cert_file}}
  smtpd_tls_key_file={{antispam_smtpd_tls_key_file}}
  smtpd_use_tls=yes
  smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
  smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache
  
  # See /usr/share/doc/postfix/TLS_README.gz in the postfix-doc package for
  # information on enabling SSL in the smtp client.
  
  smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination
  myhostname = {{ansible_hostname}}.{{antispam_domain}}
  #alias_maps = hash:/etc/aliases
  #alias_database = hash:/etc/aliases
  myorigin = $myhostname
  mydestination = $myhostname, localhost.localdomain, localhost, localhost.localdomain, localhost
  relayhost = 
  mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 {{antispam_allowed_senders}}
  mailbox_size_limit = 0
  recipient_delimiter = +
  inet_interfaces = all
  inet_protocols = {{antispam_inet_protocols}}
  
  smtpd_tls_CAfile = {{antispam_smtpd_tls_CAfile}}
  mydomain = {{antispam_domain}}
  home_mailbox = Maildir/
  mailbox_command =
  local_recipient_maps =
  smtpd_helo_required = yes
  disable_vrfy_command = yes
  header_checks = regexp:/etc/postfix/header_checks
  mime_header_checks = regexp:/etc/postfix/header_checks
  smtpd_sender_restrictions = check_client_access hash:/etc/postfix/senderaccess, check_recipient_access hash:/etc/postfix/receiveraccess
  smtpd_recipient_restrictions = reject_invalid_hostname,reject_non_fqdn_hostname,reject_non_fqdn_sender,reject_non_fqdn_recipient,reject_unknown_sender_domain,reject_unauth_pipelining,permit_mynetworks,reject_unauth_destination, check_policy_service unix:private/spfcheck, check_policy_service inet:127.0.0.1:5525, check_policy_service inet:127.0.0.1:10040, check_policy_service inet:127.0.0.1:5525
  smtpd_end_of_data_restrictions = check_policy_service inet:127.0.0.1:10040
  spfcheck_time_limit = 3600
  content_filter = smtp-amavis:[127.0.0.1]:10024
  relay_domains = {{antispam_relay_domains}} 
  transport_maps =  hash:/etc/postfix/transport
  smtpd_recipient_limit = {{antispam_smtpd_recipient_limit}}
  smtp_tls_ciphers = {{antispam_smtp_tls_ciphers}}
  parent_domain_matches_subdomains = {{antispam_parent_domain_matches_subdomains}}
  smtp_tls_security_level = {{antispam_smtp_tls_security_level}}
  smtpd_use_tls = {{antispam_smtpd_use_tls}}
  smtp_tls_note_starttls_offer = {{antispam_smtp_tls_note_starttls_offer}}
  smtpd_tls_received_header = {{antispam_smtpd_tls_received_header}}
  smtpd_tls_session_cache_timeout = {{antispam_smtpd_tls_session_cache_timeout}}
  message_size_limit = {{antispam_message_size_limit}}  
```
-   “**master.cf.yml**” dosyasında bulunan "**master_cf**" değişkeni, clamd.conf dosyasının işlenmemiş halini içermektedir. Eğer ana ayar dosyamız olan "**main.yml**" dosyasında bulunan değişkenler ile, karşılanamayan bir isteriniz mevcut ise bu değişkenin içerisinden direk hedef sistemde çalışacak olan "**master.cf**" dosyasını düzenleyebilirsiniz.
```
master_cf: |
  #
  # Postfix master process configuration file.  For details on the format
  # of the file, see the master(5) manual page (command: "man 5 master" or
  # on-line: http://www.postfix.org/master.5.html).
  #
  # Do not forget to execute "postfix reload" after editing this file.
  #
  # ==========================================================================
  # service type  private unpriv  chroot  wakeup  maxproc command + args
  #               (yes)   (yes)   (no)    (never) (100)
  # ==========================================================================
  smtp      inet  n       -       y       -       -       smtpd
  #smtp      inet  n       -       y       -       1       postscreen
  #smtpd     pass  -       -       y       -       -       smtpd
  #dnsblog   unix  -       -       y       -       0       dnsblog
  #tlsproxy  unix  -       -       y       -       0       tlsproxy
  #submission inet n       -       y       -       -       smtpd
  #  -o syslog_name=postfix/submission
  #  -o smtpd_tls_security_level=encrypt
  #  -o smtpd_sasl_auth_enable=yes
  #  -o smtpd_reject_unlisted_recipient=no
  #  -o smtpd_client_restrictions=$mua_client_restrictions
  #  -o smtpd_helo_restrictions=$mua_helo_restrictions
  #  -o smtpd_sender_restrictions=$mua_sender_restrictions
  #  -o smtpd_recipient_restrictions=
  #  -o smtpd_relay_restrictions=permit_sasl_authenticated,reject
  #  -o milter_macro_daemon_name=ORIGINATING
  #smtps     inet  n       -       y       -       -       smtpd
  #  -o syslog_name=postfix/smtps
  #  -o smtpd_tls_wrappermode=yes
  #  -o smtpd_sasl_auth_enable=yes
  #  -o smtpd_reject_unlisted_recipient=no
  #  -o smtpd_client_restrictions=$mua_client_restrictions
  #  -o smtpd_helo_restrictions=$mua_helo_restrictions
  #  -o smtpd_sender_restrictions=$mua_sender_restrictions
  #  -o smtpd_recipient_restrictions=
  #  -o smtpd_relay_restrictions=permit_sasl_authenticated,reject
  #  -o milter_macro_daemon_name=ORIGINATING
  #628       inet  n       -       y       -       -       qmqpd
  pickup    unix  n       -       y       60      1       pickup
  cleanup   unix  n       -       y       -       0       cleanup
  qmgr      unix  n       -       n       300     1       qmgr
  #qmgr     unix  n       -       n       300     1       oqmgr
  tlsmgr    unix  -       -       y       1000?   1       tlsmgr
  rewrite   unix  -       -       y       -       -       trivial-rewrite
  bounce    unix  -       -       y       -       0       bounce
  defer     unix  -       -       y       -       0       bounce
  trace     unix  -       -       y       -       0       bounce
  verify    unix  -       -       y       -       1       verify
  flush     unix  n       -       y       1000?   0       flush
  proxymap  unix  -       -       n       -       -       proxymap
  proxywrite unix -       -       n       -       1       proxymap
  smtp      unix  -       -       y       -       -       smtp
  relay     unix  -       -       y       -       -       smtp
  #       -o smtp_helo_timeout=5 -o smtp_connect_timeout=5
  showq     unix  n       -       y       -       -       showq
  error     unix  -       -       y       -       -       error
  retry     unix  -       -       y       -       -       error
  discard   unix  -       -       y       -       -       discard
  local     unix  -       n       n       -       -       local
  virtual   unix  -       n       n       -       -       virtual
  lmtp      unix  -       -       y       -       -       lmtp
  anvil     unix  -       -       y       -       1       anvil
  scache    unix  -       -       y       -       1       scache
  #
  # ====================================================================
  # Interfaces to non-Postfix software. Be sure to examine the manual
  # pages of the non-Postfix software to find out what options it wants.
  #
  # Many of the following services use the Postfix pipe(8) delivery
  # agent.  See the pipe(8) man page for information about ${recipient}
  # and other message envelope options.
  # ====================================================================
  #
  # maildrop. See the Postfix MAILDROP_README file for details.
  # Also specify in main.cf: maildrop_destination_recipient_limit=1
  #
  maildrop  unix  -       n       n       -       -       pipe
    flags=DRhu user=vmail argv=/usr/bin/maildrop -d ${recipient}
  #
  # ====================================================================
  #
  # Recent Cyrus versions can use the existing "lmtp" master.cf entry.
  #
  # Specify in cyrus.conf:
  #   lmtp    cmd="lmtpd -a" listen="localhost:lmtp" proto=tcp4
  #
  # Specify in main.cf one or more of the following:
  #  mailbox_transport = lmtp:inet:localhost
  #  virtual_transport = lmtp:inet:localhost
  #
  # ====================================================================
  #
  # Cyrus 2.1.5 (Amos Gouaux)
  # Also specify in main.cf: cyrus_destination_recipient_limit=1
  #
  #cyrus     unix  -       n       n       -       -       pipe
  #  user=cyrus argv=/cyrus/bin/deliver -e -r ${sender} -m ${extension} ${user}
  #
  # ====================================================================
  # Old example of delivery via Cyrus.
  #
  #old-cyrus unix  -       n       n       -       -       pipe
  #  flags=R user=cyrus argv=/cyrus/bin/deliver -e -m ${extension} ${user}
  #
  # ====================================================================
  #
  # See the Postfix UUCP_README file for configuration details.
  #
  uucp      unix  -       n       n       -       -       pipe
    flags=Fqhu user=uucp argv=uux -r -n -z -a$sender - $nexthop!rmail ($recipient)
  #
  # Other external delivery methods.
  #
  ifmail    unix  -       n       n       -       -       pipe
    flags=F user=ftn argv=/usr/lib/ifmail/ifmail -r $nexthop ($recipient)
  bsmtp     unix  -       n       n       -       -       pipe
    flags=Fq. user=bsmtp argv=/usr/lib/bsmtp/bsmtp -t$nexthop -f$sender $recipient
  scalemail-backend unix  -       n       n       -       2       pipe
    flags=R user=scalemail argv=/usr/lib/scalemail/bin/scalemail-store ${nexthop} ${user} ${extension}
  mailman   unix  -       n       n       -       -       pipe
    flags=FR user=list argv=/usr/lib/mailman/bin/postfix-to-mailman.py
    ${nexthop} ${user}
  
  smtp-amavis     unix    -       -       -       -       2       smtp
   -o smtp_data_done_timeout=1200
   -o smtp_send_xforward_command=yes
   -o disable_dns_lookups=yes
   -o max_use=20
   
  127.0.0.1:10025 inet    n       -       -       -       -       smtpd
   -o content_filter=
   -o local_recipient_maps=
   -o relay_recipient_maps=
   -o smtpd_restriction_classes=
   -o smtpd_delay_reject=no
   -o smtpd_client_restrictions=permit_mynetworks,reject
   -o smtpd_helo_restrictions=
   -o smtpd_sender_restrictions=
   -o smtpd_recipient_restrictions=permit_mynetworks,reject
   -o smtpd_data_restrictions=reject_unauth_pipelining
   -o smtpd_end_of_data_restrictions=
   -o mynetworks=127.0.0.0/8
   -o smtpd_error_sleep_time=0
   -o smtpd_soft_error_limit=1001
   -o smtpd_hard_error_limit=1000
   -o smtpd_client_connection_count_limit=0
   -o smtpd_client_connection_rate_limit=0
   -o receive_override_options=no_header_body_checks,no_unknown_recipient_checks
  
  spfcheck  unix  -       n       n       -       -       spawn        user=policyd-spf argv=/usr/bin/policyd-spf
 
```
