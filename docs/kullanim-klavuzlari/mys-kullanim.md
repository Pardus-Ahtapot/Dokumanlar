![ULAKBIM](../img/ulakbim.jpg)
#Ansible Playbook Kullanımı
------

Bu dokümanda, AHTAPOT projesi kapsamında, merkezi yönetim uygulaması olarak kullanılan Ansible üzerinde geliştirilen playbooklar’ın temel rolleri ve detayları dokümante edilmektedir.


[TOC]

Farklı görev üstlenen sunucular için farklı roller tanımlanmış olup her bir rolün yapısı aşağıda belirtilen şablon kullanılarak hazırlanmıştır.

Şablonun temel yapısında “**roles/**” klasörü altında bulunan alt klasörler gösterilmektedir. 

```
-tasks/
	-main.yml
	-task1.yml
	-task2.yml
-defaults/
-vars/
	-main.yml
-templates/
	-template1.j2
	-template2.j2
-meta/
-README.md
```

Yukarıdaki klasör şablonuna göre her bir klasörün altında bulunan main.yml dosyası ana dosya olarak barınmakta ve içerisine belirtilen .yml dosyalarını playbook’a dahil etmektedir. Örnek vermek gerekirse, “**tasks**” dizini altındaki “**main.yml**” dosyası, “**task1.yml**” ve “**task2.yml**” dosyalarını playbook’a dahil etmektedir.

```
<main.yml>
	---
	- include: task1.yml
	- include: task2.yml
```

Bu konsept dahilinde, her bir dizin o ansible rolüne ait farklı işlevliklere sahiptir. Bu işlevlerin ayrıntıları aşağıda belirtilmiştir.

* **Tasks:** Herhangi bir görev, bu dizin altında belirtilir. (Örneğin: paket kurulumu, konfigurasyonu vb.)
* **Vars:** Ansible rollerine ait her bir değişken bu dizin altında belirtilir. (Örneğin: kullanıcı id, kullanıcı adı, program hafıza boyutu vb.)
* **Defaults:** Tek defaya mahsus kullanılmak üzere ya da “**vars**” dizininde belirtilmemiş değişkenler burada yer alır. Mevcut tasarımda bu klasör hiç bir rolde **kullanılmamaktadır**.
* **Templates:** Playbook çalıştığında sunucuda yapılması gereken, yapılandırma ayarları için oluşturulan temel dosyalardır. Bu şablonlar playbook’un çalıştırılacağı sunucu üzerindeki konfigurasyon dosyaları yerlerine konularak konfigurasyon işlemi tamamlanacaktır.
* **Handlers:** Task’lerin “**notify**” kısımlarında belirtilen komutların dizin klasörüdür. Bu task’lerde meydana gelecek bir değişiklikte notify kısmında belirtilen handlers’lar çağırılacaktır. Örneğin bir servisin konfigurasyonu değişmesi durumunda servisi yeniden başlatılma işlemini bu handlers’lar üstlenmektedir.
* **Meta:** Rollerin metadatalarını içerir. Bu metadatalarda ise paket bilgileri, bağımlılıklar gibi alanlar bulunmaktadır.

#### Ansible

Ahtapot projesi kapsamında merkezde bulunacak ve gitlab deposunu kullanarak sistem durumunu kararlı olarak ayakta tutacak merkezdeki komuta kontrol sunucusu üzerinde çalıştırılması gereken playbook’dur. “**/etc/ansible/playbooks/**” dizini altında bulunan “**ansible.yml**” dosyasına bakıldığında, “**hosts**” satırında Ansible’a ait “**/etc/ansible/**” altında bulunan “**hosts**” dosyasında “**[ansible]**” satırı altına yazılmış tüm sunucularda bu playbookun oynatılacağı belirtilir. “**remote_user**” satırında, sistemler oynatılacak playbookun hangi kullanıcı ile oynatılacağı belirlenir. “**sudo**” satırı ile çalışacak komutların sudo yetkisi ile çalışması belirlenir. “**roles**” satırı altında bulunan satırlarda ise bu playbook çalıştığında “**base**” ve “**ansible**” rollerinin çalışacağı belirtilmektedir.  

```

$ more /etc/ansible/playbooks/ansible.yml
# Calistirildiginda Ansible Kurulumu Yapilir
- hosts: ansible 
  remote_user: ahtapotops
  sudo: yes
  roles:
  - { role: base }
  - { role: ansible }
```

#### Base Rolü Değişkenleri

Bu rol Ahtapot projesi kapsamındaki tüm sunucularda çalışan temel ayarlamaların yapıldığı roldür.  Bu rolün görevleri:

    * Tüm sistemlerde olması gereken paketlerin kurulum ve denetimleri: 
	auditd,sysstat,ntp,bash,rsyslog,sudo

    * Tüm sistemlerde bulunması gereken servislerin yapılandırılması:
	ntp, auditd, ssh

    * Tüm sistemlerde yapılması gereken genel işlemler:
	   * Sudo yapılandırma
	   * Sysctl yapılandırma
	   * /etc/hosts yapılandırma
	   * Grub yapılandırma
	   * Rsyslog yapılandırma
	   * USB kullanım kapatma / açma

Bu roldeki değişkenler “**/etc/ansible/roles/base/vars/**” dizini içeirisnde ayrı yml dosyaları halinde belirtilmiştir. yml dosylarının içerikleri aşağıdaki gibidir.

* “**group.yml**” dosyası sistemler üzerinde kullanılan kullanıcının ait olduğu grup değişkenlerini içeren dosyadır. Sistemde var olması gereken grup ismi "**name**" satırına yazılır ve "**state**" satırına "**present**" bilgisi girilir. İlgili sistemde bulunmaması durumda yeniden oluşturur. Sistemden grubun silinmesi isteniyorsa "**state**" satırına "**absent**" bilgisi girilmelidir. 
```
# Grup degiskenlerini iceren dosyadir.
# Yorum satiri ile gosterilen sablon doldurularak istenilen kadar grup eklenebilir.
base_user_groups:
    group1:
        name: ahtapotops
        state: present
#    groupX:
#        name:  
#        state:
```


* “**user.yml**” dosyası sistemler üzerinde kullanılan kullanıcı değişkenlerini içeren dosyadır. "**name**" satırına yazılan kullanıcının  sistemde var olması isteniyorsa "**state**" satırına "**present**" bilgisi girilmelidir. İlgili sistemde bulunmaması durumda yeniden oluşturur. Sistemden kullanıcının silinmesini isteniyorsa "**state**" satırına "**absent**" bilgisi girilmelidir.

```
# Kullanici degiskenlerini iceren dosyadir.
# Yorum satiri ile gosterilen sablon doldurularak istenilen kadar kullanici eklenebilir.
base_users:
    user1:
        name: ahtapotops
        group: ahtapotops
        shell: /bin/bash
        state: present
#    userX:
#        name:
#        group:
#        shell:
#        state:

```

* “**package.yml**” dosyasına sistemler üzerine kurulacak paket değişkenlerini içeren dosyadır. "**name**" satırına paket adı ve versiyon bilgisi yazılır. “**state**” satırı ile paketlerin durumu ile ilgili bilgi verilir. Üç farklı değişken kullanılabilir; “**present**” paket yüklü ise herhangi değişiklik yapmaz. “**absent**” değişkeni ile paketin yüklü olması durumunda sistemden silinmesi sağlanır. “**latest**” değişkeni ile paket reposunda ilgili paketin güncel versiyonu var ise otomatik güncellenmesi sağlanır.

```
# Paket degiskenlerini iceren dosyadir.
# Yorum satiri ile gosterilen sablon doldurularak istenilen kadar paket eklenebilir.
base_packages:
    package01:
        name: "auditd=1:2.4-1+b1"
        state: "present"
    package02:
        name: "sysstat=11.0.1-1"
        state: "present"
    package03:
        name: "ntp=1:4.2.6.p5+dfsg-7+deb8u1"
        state: "present"
    package04:
        name: "bash=4.3-11+b1"
        state: "present"
    package05:
        name: "rsyslog=8.4.2-1+deb8u2"
        state: "present"
    package06:
        name: "sudo=1.8.10p3-1+deb8u3"
        state: "present"
    package07:
        name: "logrotate=3.8.7-1+b1"
        state: "present"
    package08:
        name: "apt-transport-https=1.0.9.8.3"
        state: "present"
#    packageXX:
#        name:
#        state:
```

* “**repo.yml**” dosyası sistemlere eklenecek depo bilgilerini içeren dosyadır. “**url**” satırında eklenecek deponun adresi belirtilmektedir. “**updatecache**” seçeneği ile “**apt-get update**” komutu çalıştırılarak deponun güncel hali çekilir. “**state**” satırı ile ilgili reponun sisteme ekleneceği ya da kaldırılacağı belirlenir. "**present**" seçeneği ile reponun sisteme eklenmesi, "**absent**" seçeneği ile sistemden kaldırılması sağlanır.

```
# Depo degiskenlerini iceren dosyadir.
# Yorum satiri ile gosterilen sablon doldurularak istenilen kadar repo eklenebilir.
base_repositories:
    repo1:
        url: 'deb http://depo.pardus.org.tr/ahtapot yenikusak main'
        updatecache: yes
        state: present
    repo2:
        url: 'deb http://193.140.98.199/pardus-yenikusak yenikusak main non-free contrib'
        updatecache: yes
        state: present
#    repoX:
#        url:
#        updatecache:
#        state:

```

* “**sudo.yml**” dosyası sudo yapılandırmasının belirtildiği dosyadır. "**sudo:**" fonksiyonu altındaki "**conf:**" bölümünde "**source**" satırında belirtilen ve “**/etc/ansible/roles/base/templates**” altında bulunan “**sudoers.j2**” dosyasında bulunan ayarları sunucular üzerinde gerçekleştirir. “**destination**” satırında ayarların yapılacağı sudoers dosyası belirlenir. “**owner**”, “**group**” ve “**mode**” ile bu dosyanın sahibi olan kullanıcı, grup ve hakları belirlenir. “**iologdir**” satırı ile sudo loglarının hangi dizine yazılacağı belirtilir. "**sudo_privileges**" altında bulunan "**hostgroups**"  ile hangi görevi üstelenen sunucularda, “**user**” ile hangi user için bu ayarların yapılacağı belirtilir. **commands**” satırı ile ilgili gruba hangi komutlar için yetki verileceği belirtilmektedir.
```
# Sudo degiskenlerini iceren dosyadir.
sudo:
    conf:
        source: "sudoers.j2"
        destination: "/etc/sudoers"
        owner: "root"
        group: "root"
        mode: "0440"
        validate: "/usr/sbin/visudo -cf %s"
    directory:
        path: "/var/log/sudo-io"
        state: "directory"
        owner: "root"
        group: "root"
        mode: "0700"
    iologdir: "/var/log/sudo-io/%{hostname}/%{user}"


sudo_privileges:
    privilege01:
        hostgroups: "all"
        user: "ahtapotops"
        commands: "ALL"
    privilege02:
        hostgroups: "testfirewall"
        user: "kontrol"
        commands: "ALL"
    privilege03:
        hostgroups: "firewall"
        user: "lkk"
        commands: "/usr/bin/tail * /var/log/*, /usr/sbin/iptraf, /bin/zcat -f /var/log/ahtapot/fw/*, /bin/cat /var/log/ahtapot/fw/*, /usr/sbin/arp -an, /usr/sbin/iptstate *, /usr/bin/bmon"
	privilege04:
        hostgroups: "gitlab"
        user: "git"
        commands: "/bin/rm -f /var/opt/gitlab/backups/*.tar, /usr/bin/ssh, /usr/bin/scp"
```

* "**blacklist.yml**" dosyası karaliste çekirdek modüllerini içeren dosyadır. "**name**" satırı “**usb-storage**” olan **module01**'de sistemlerdeki usb kapılarının açılıp/kapanması sağlanır. “**/etc/ansible/roles/base/templates**” dizini altında bulunan “**blacklist.conf.j2**” dosyasındaki izin verilmeyecek durumları modprobe’a yazar.

```
# Karaliste cekirdek modullerini iceren dosyadir.
# Yorum satiri ile gosterilen sablon doldurularak karalisteye istenilen kadar cekirdek modulu eklenebilir.
# Usb belleklerin calismasi icin gerekli olan modul bu sekilde karalisteye eklenmektedir

blacklists:
    conf:
        source: "blacklist.conf.j2"
        destination: "/etc/modprobe.d/blacklist.conf"
        owner: "root"
        group: "root"
        mode: "0644"


base_blacklist_modules:
    module01:
        name: "usb_storage"
        state: "absent"
#    moduleXX:
#        name:
#        state:
```

* “**logger.yml**” dosyası ile sistemlerin ayakta ve log gönderebilir olduğunun kontrolünün yapılacağı script “**/etc/ansible/roles/base/templates**” dizini altında bulunan “**logger.sh.j2**” dosyasından kopyalanarak cron’a eklenmektedir. 

```
# Heartbeat yapilandirmasini belirtmektedir.
logger:
    cron:
        source: "logger.sh.j2"
        destination: "/etc/cron.d/logger.sh"
        owner: "root"
        group: "root"
        mode: "0755"
    min: "00"
    hour: "*"
    facility: "local5"
    severity: "info"
    tag: "heartbeat"
    message: "Heartbeat from $(hostname) at $(date) !"
```

* “**ssh.yml**” dosyası ile sistemlerde ssh tanım, yapılandırma ve sıkılaştırma işlemleri yapılır. “**conf**” alt fonksiyonu ile “**/etc/ssh/sshd_config**” dosyasının hakları ve erişim yetkileri belirlenir. “**service**” alt fonksiyonunda ssh servisinin değişikliklerden sonra yeniden başlatılması sağlanır. “**TrustedUserCAKeys**” alt fonksiyonu ile sisteme eklenen CA imzalı açık anahtar bilgisi, bu anahtarın hakları ve erişim yetkileri belirlenir. Anahtarın değiştirildiği durumlarda, sistemlere ait imzalanmış public anahtar "**/etc/ansible/roles/base/templates**" dizini altında bulunan "**ahtapot_ca.pub.j2**" dosyasında düzenlenmelidir. "**RevokedKeys**" alt fonksiyonunda  "**/etc/ansible/roles/base/templates**" dizini altında bulunan "**revoked_keys.j2" dosyasına sisteme mevcutta erişimi bulunan fakat gerekli sebepler dolayısı ile erişim yetkisi kaldırılmak istenen kullanıcıların anahtar bilgileri eklenmelidir. “**LocalBanner**” ve “**RemoteBanner**” alt fonksiyonları ile sunuculara  bağlantı kurulduğunda ekrana gelecek uyarı belirtilir. Bu satırlardan sonra gelen satırlarda, ssh yapılandırmasına ait bilgiler bulunup, değişiklik yapıldığı takdirde “**/etc/ssh/sshd_config**” dosyasına bu değişiklikler yansıtılacaktır. Sistemlerde kullanılacak ssh portunu varsayılan “**22**” değeri dışında başka bir değere atanmak istenir ise, “**Port**” satırındaki 22 değeri olması istenen değer ile değiştirilmelidir.

```
# Ssh degiskenlerini iceren dosyadir.
ssh:
    conf:
        source: "sshd_config.j2"
        destination: "/etc/ssh/sshd_config"
        owner: "root"
        group: "root"
        mode: "0644"
    service:
        name: "ssh"
        state: "started"
        enabled: "yes"
    TrustedUserCAKeys:
        source: "ahtapot_ca.pub.j2"
        destination: "/etc/ssh/ahtapot_ca.pub"
        owner: "root"
        group: "root"
        mode: "0644"
    RevokedKeys:
        source: "revoked_keys.j2"
        destination: "/etc/ssh/revoked_keys"
        owner: "root"
        group: "root"
        mode: "0644"
    LocalBanner:
        source: "issue.j2"
        destination: "/etc/issue"
        owner: "root"
        group: "root"
        mode: "0644"
    RemoteBanner:
        source: "issue.net.j2"
        destination: "/etc/issue.net"
        owner: "root"
        group: "root"
        mode: "0644"
    Port: "22" 
    Protocol: "2"
    ListenAddressv4: "0.0.0.0"
    ListenAddressv6: "::"
    UsePrivilegeSeparation: "yes"
    KeyRegenerationInterval: "3600"
    ServerKeyBits: "1024"
    SyslogFacility: "AUTH"
    LogLevel: "DEBUG"
    LoginGraceTime: "90"
    PermitRootLogin: "no"
    StrictModes: "yes"
    RSAAuthentication: "yes"
    PubkeyAuthentication: "yes"
    IgnoreRhosts: "yes"
    RhostsRSAAuthentication: "no"
    HostbasedAuthentication: "no"
    IgnoreUserKnownHosts: "yes"
    PermitEmptyPasswords: "no"
    ChallengeResponseAuthentication: "no"
    PasswordAuthentication: "no"
    KerberosAuthentication: "no"
    KerberosOrLocalPasswd: "yes"
    KerberosTicketCleanup: "yes"
    GSSAPIAuthentication: "no"
    GSSAPICleanupCredentials: "yes"
    X11Forwarding: "no"
    X11DisplayOffset: "10"
    PrintMotd: "yes"
    PrintLastLog: "yes"
    TCPKeepAlive: "yes"
    UsePAM: "no"
    UseLogin: "no"
```

* “**ntp.yml**” dosyası sistemlerdeki ntp yapılandırmasının belirtildiği dosyadır. “**conf**” alt fonksiyonu ile “**/etc/ntp.conf**” dosyasının hakları ve erişim yetkileri belirlenir. “**service**” alt fonksiyonunda ntp servisinin değişikliklerden sonra yeniden başlatılması sağlanır. "**base_ntp_servers**" altında bulunan "**server**" satırları arttırılarak istenildiği kadar ntp sunucusu tanımlanabilir. 

```
# Zaman sunucusu ayarlarini iceren dosyadir.
# Yorum satiri ile gosterilen sablon doldurularak istenilen kadar zaman sunucusu eklenebilir.
ntp:
    conf:
        source: "ntp.conf.j2"
        destination: "/etc/ntp.conf"
        owner: "root"
        group: "root"
        mode: "0644"
    service:
        name: "ntp"
        state: "started"
        enabled: "yes"
base_ntp_servers:
    server1:
        fqdn: "0.tr.pool.ntp.org"
    server2:
        fqdn: "1.tr.pool.ntp.org"
#    serverX:
#        fqdn: ""
```

* “**grub.yml**” dosyası ile sunucularda grub parolası belirlenir.“**confile**” ile dosya dizini belirtilir. “**grubuser**” ile kullanıcı bilgisi, “**grubpass**” ile parola bilgisi girilir. “**grub_configurations**” fonksiyonunun altındaki  alt fonksiyonlarının girdileri ve  bu dosyanın hakları ve erişim yetkileri belirlenir.

```
# Grub yapilandirmasini belirtmektedir.
grub:
    confile: "/boot/grub/grub.cfg"
    grubuser: ahtagrub
    grubpass: grub.pbkdf2.sha512.10000.2A82B914C527C90A5018614B88F1604955C46131AEF358D1CB81E604793F5DD973DC3B796A2AF691AECC835928F76774835920D11B7FBEB07F050FAAF231B754.9433A4A373F5FB7D5FC05E25E14CAC0FEAD7FDE2019BE0E5E5D3B7D98A06FA3DB018D3EC7A0557B1D7BCDB3AD091B8C44E121B057931E72A0A1592A7392214DF


grub_configurations:
    conf01:
        source: "grub_01_users.j2"
        destination: "/etc/grub.d/01_users"
        owner: "root"
        group: "root"
        mode: "0755"
    conf02:
        source: "grub_10_linux.j2"
        destination: "/etc/grub.d/10_linux"
        owner: "root"
        group: "root"
        mode: "0755"
#    confXX:
#        source: ""
#        destination: ""
#        owner: ""
#        group: ""
#        mode: ""

```

* “**audit.yml**” dosyasında sunucularda audit yapılandırmasının yapılaması sağlanır. “**conf**” alt fonksiyonu ile “**/etc/audit/auditd.conf**” dosyasının hakları ve erişim yetkileri belirlenir. “**service**” alt fonksiyonunda audit servisinin değişikliklerden sonra yeniden başlatılması sağlanır. “**rules**” alt fonksiyonunda “**/etc/audit/audit.rules**” dosyasının hakları ve erişim yetkileri belirlenir.  Bu satırlardan sonra gelen satırlarda, audit yapılandırmasına ait bilgiler bulunup, değişiklik yapıldığı takdirde “**/etc/audit/auditd.conf**” dosyasına bu değişiklikler yansıtılacaktır.

```
# Auditd degiskenlerini iceren dosyadir.
audit:
    conf:
        source: "auditd.conf.j2"
        destination: "/etc/audit/auditd.conf"
        owner: "root"
        group: "root"
        mode: "0644"
    service:
        name: "auditd"
        state: "started"
        enabled: "yes"
    rules:
        source: "audit.rules.j2"
        destination: "/etc/audit/audit.rules"
        owner: "root"
        group: "root"
        mode: "0644"
    name: "ahtapotops"
    name_format: "user"
    log_file: "/var/log/audit/audit.log"
    log_format: "RAW"
    log_group: "root"
    max_log_file: "10"
    max_log_file_action: "ROTATE"
    num_logs: "5"
    priority_boost: "4"
    flush: "INCREMENTAL"
    freq: "20"
    disp_qos: "lossy"
    dispatcher: "/sbin/audispd"
    space_left: "2000"
    space_left_action: "SYSLOG"
    action_mail_acct: "root"
    admin_space_left: "1000"
    admin_space_left_action: "SUSPEND"
    disk_full_action: "SUSPEND"
    disk_error_action: "SUSPEND"
    tcp_listen_queue: "5"
    tcp_max_per_addr: "1"
    tcp_client_ports: "1024-65535"
    tcp_client_max_idle: "0"
    enable_krb5: "no"
    krb5_principal: "auditd"
    krb5_key_file: "/etc/audit/audit.key"
```
* “**rsyslog.yml**” dosyası ile sunucularda rsyslog yapılandırmasının yapılaması sağlanmaktadır. “**conf**” alt fonksiyonu ile “**/etc/rsyslog.conf**” dosyasına “**/etc/ansible/roles/base/templates/**” altında bulunan “**rsyslog.conf.j2**” dosyası kopyalanır ve hakları, erişim yetkileri belirlenir.  “**service**” alt fonksiyonunda rsyslog servisinin değişikliklerden sonra yeniden başlatılması sağlanır. Bu satırlardan sonra gelen satırlarda, rsyslog yapılandırmasına ait bilgiler bulunup, değişiklik yapıldığı takdirde “**/etc/rsyslog.conf**” dosyasına bu değişiklikler yansıtılacaktır. "**base_rsyslog_servers**" satırı altında rsyslog sunucuların adı veya ip adresi yazılmalıdır. İstenildiği kadar rsyslog sunucusu tanımlanabilir.

```
# Log sunucu ayarlarini iceren dosyadir.
# Yorum satiri ile gosterilen sablon doldurularak istenilen kadar log sunucusu eklenebilir.
rsyslog:
    conf:
        source: "rsyslog.conf.j2" 
        destination: "/etc/rsyslog.conf" 
        owner: "root" 
        group: "root" 
        mode: "0644" 
    service:
        name: "rsyslog" 
        state: "started" 
        enabled: "yes"
    ActionQueueMaxDiskSpace: "2g"
    ActionQueueSaveOnShutdown: "on" 
    ActionQueueType: "LinkedList" 
    ActionResumeRetryCount: "-1" 
    WorkDirectory: "/var/spool/rsyslog" 
    IncludeConfig: "/etc/rsyslog.d/*" 

base_rsyslog_servers:
    server1:
        fqdn: "rsyslog01.gdys.local" 
        port: "514" 
        connectiontype: "udp"
        severity: "local5" 
        facility: "*"
    server2:
        fqdn: "rsyslog02.gdys.local" 
        port: "514" 
        connectiontype: "tcp" 
        severity: "*" 
        facility: "info"
#    serverX:
#        fqdn: "" 
#        port: "" 
#        connectiontype: "" 
#        severity: "" 
#        facility: ""
```

* "**logrotate.yml**" dosyası logrotate değişkenlerini içeren dosyadır. "**logrotate_scripts**" fonksiyonu altında logrotate script'lerinin konulacağı yer belirlenir. "**/etc/logrotate.d/ahtapot**" dosyasına "**/etc/ansible/roles/base/templates**" altında bulunan "**ahtapot_logrotate.j2**" dosyası kopyalanır.
İstanildiği kadar logrotate scripti eklenebilir.
```
# Logrotate degiskenlerini iceren dosyadir
logrotate_scripts:
    script01:
        source: "ahtapot_logrotate.j2"
        destination: "/etc/logrotate.d/ahtapot"
        owner: "root"
        group: "root"
        mode: "0644"
#    scriptXX:
#        source: ""
#        destination: ""
#        owner: ""
#        group: ""
#        mode: ""
```

* "**directory.yml**" dosyası base rolünde olması gereken dizinleri içeren dosyadır."**base_ahtapot_directories**" fonksiyonu altına olması gereken dizinler yazılır.  “**owner**”, “**group**” ve “**mode**” ile bu dizinin sahibi olan kullanıcı, grup ve hakları belirlenir. İstenildiği kadar dizin eklenebilir.
```
# Base rolunde olmasi gereken dizinleri iceren dosyadir.
base_ahtapot_directories:
    directory01:
        path: "/var/log/ahtapot/"
        owner: "ahtapotops"
        group: "ahtapotops"
        mode: "755"
        state: "directory"
#    directoryXX:
#        path: ""
#        owner: ""
#        group: ""
#        mode: ""
#        state: ""
```
####Ansible Rolü Değişkenleri

Bu rol Ahtapot projesi kapsamındaki Ansible görevini üstlenecek sunucularda çalıştırılan Ansible ayarlamaların yapıldığı roldür.  Bu rolün görevleri:

    * Ansible sunucusu üzerinde bulunması gereken paketlerin kurulum ve denetimleri: 
	git,ansible, python-requests, ahtapot-gkts, rsync

    * Ansible sunucusu yapılması gereken genel işlemler:
	   * Ansible’da çalışalıcak dizin ve alt dizinlerin oluşturulması
	   * Merkezi Sürüm Takip Sistemi’nde bulunan mys deposunun yerele indirilmesi
	   * Güvenlik Duvarı Yönetim Sistemi’nde bulunan gdys deposunun yerele indirilmesi

Bu roldeki değişkenler “**/etc/ansible/roles/ansible/vars/**” dizini altında bulunan yml dosyaları içerisinde  belirtilmiştir. Bu yml dosyalarının içerikleri ve değişken bilgileri aşağıdaki gibidir;

* “**package.yml**” dosyasına sistemler üzerine kurulacak paket değişkenlerini içeren dosyadır. "**name**" satırına paket adı ve versiyon bilgisi yazılır. “**state**” satırı ile paketlerin durumu ile ilgili bilgi verilir. Üç farklı değişken kullanılabilir; “**present**” paket yüklü ise herhangi değişiklik yapmaz. “**absent**” değişkeni ile paketin yüklü olması durumunda sistemden silinmesi sağlanır. “**latest**” değişkeni ile paket reposunda ilgili paketin güncel versiyonu var ise otomatik güncellenmesi sağlanır.
```
# Paket degiskenlerini iceren dosyadir.
# Yorum satiri ile gosterilen sablon doldurularak istenilen kadar paket eklenebilir.
ansible_packages:
    package01:
        name: "ansible=1.7.2+dfsg-2"
        state: "present"
    package02:
        name: "git=1:2.1.4-2.1+deb8u2"
        state: "present"
    package03:
        name: "python-requests=2.4.3-6"
        state: "present"
    package04:
        name: "rsync=3.1.1-3"
        state: "present"
#    packageXX:
#        name:
#        state:
#    packageXX:
#        name:
#        state:
```

* “**git.yml**” dosyasında Ansible sunucusunda bulunacak git depolarının bilgileri girilmektedir. "**gitrepos**" fonksiyonu altında Ansible sunucusunun erişmesi gereken “**gdys**” ve “**mys**” git depolarının bilgileri bulunmaktadır. Her iki repo alt fonksiyonun da çalışma prensibi aynıdır. “**repo**” satırına MYS kapsamında kurulmuş Yerel GitLab sunucusunda bulunan ilgili depo adresi girilir. “**accept_hostkey**” satırında bağlantı sırasında sunucu anahtarını kabul edilip edilmeyeceğine dair soru geldiğinde kabul etmesine zorlamaktadır. “**destination**” alt fonksiyonu ile GitLab deposunun kopyalanacağı dizin ve bu dizinin hakları, erişim yetkileri belirtilmektedir.  “**key_file**” satırı ile GitLab’a erişecek kullanıcının anahtar bilgisi girilmektedir.

```
# Gitin degiskenlerini iceren dosyadir
gitrepos:
    repo01:
        repo: "ssh://git@gitlab01.gdys.local:4444/ahtapotops/gdys.git"
        accept_hostkey: "yes"
        destination: "/etc/fw/gdys"
        key_file: "/home/ahtapotops/.ssh/id_rsa"
    repo02:
        repo: "ssh://git@gitlab01.gdys.local:4444/ahtapotops/mys.git"
        accept_hostkey: "yes"
        destination: "/etc/ansible/"
        key_file: "/home/ahtapotops/.ssh/id_rsa"
#    repoXX:
#        repo: ""
#        accept_hostkey: ""
#        destination: ""
#        key_file: ""
```

* “**ansible.yml**” fonksiyonu ile “**/etc/ansible/roles/ansible/templates**” dizini altında bulunan “**mys.sh.j2**”, “**gdys.sh.j2**” ve "**gkts.sh.j2**"  scriptleri ile Ansible makinesi üzerinde bulunan GDYS, MYS ve GKTS repolarının GitLab’dan güncel hallerinin çekilmesi sağlanır.

```
# Playbooklari oynatacak scriptlerin dosyalaridir.
# Yorum satiri ile gosterilen sablon doldurularak istenilen kadar script eklenebilir.
scripts:
    script01:
        source: "mys.sh.j2"
        destination: "/usr/bin/mys.sh"
        owner: "root"
        group: "root"
        mode: "0755"
    script02:
        source: "gdys.sh.j2"
        destination: "/usr/bin/gdys.sh"
        owner: "root"
        group: "root"
        mode: "0755"
    script03:
        source: "gkts.sh.j2"
        destination: "/usr/bin/gkts.sh"
        owner: "root"
        group: "root"
        mode: "0755"
#    scriptXX:
#        source:
#        destination:
#        owner:
#        group:
#        mode:
```

* "**directory.yml**" dosyası Ansible suncusunda bulunacak dizinlerin belirlendiği dosyadır.  "**owner**", "**group**" ve "**mode**" ile bu dizinin sahibi olan kullanıcı, grup ve hakları belirlenir. İstenildiği kadar dizin eklenebilir.

```
# Dizinleri iceren dosyadir.
directories:
    directory01:
        path: "/etc/fw/"
        group: "ahtapotops"
        owner: "ahtapotops"
        mode: "750"
        state: "directory"
#    directoryXX:
#        path: ""
#        group: ""
#        owner: ""
#        mode: ""
#        state: ""
```

* "**gkts.yml**" dosyası ansible sunucusunun gkts sunucusuna erişmesi için gerekli değişkenlerin bulunduğu dosyadır. Ansible sunucusu bu bilgiler ile gkts sunucusuna bağlanır ve Geçici Kural Tanımlama Sisteminde tanımlanmış olan kurallara erişir. "**server**" satırına GKTS sunucusu ile kullanılacak sunucunun **FQDN** bilgisi, "**port**" satırına ise SSH bağlantısı için kullanılacak port bilgisi girilmelidir.

```
# Gkts'nin degiskenlerini iceren dosyadir
gkts:
    server: "gkts01.gdys.local"
    port: "22"
    logseverity: "local5.notice"
```

####Gitlab

Ahtapot projesi kapsamında merkezde bulunacak ve sistemlerin ihtiyaç duyduğu dosyaları depolarından bulunduran GitLab sunucusunu kuracak playbook’dur. “**/etc/ansible/playbooks/**” dizini altında bulunan “**gitlab.yml**” dosyasına bakıldığında, “**hosts**” satırında Ansible’ a ait “**/etc/ansible/**” altında bulunan “**hosts**” dosyasında “**[gitlab]**” satırı altına yazılmış tüm sunucularda bu playbookun oynatılacağı belirtilir. “**remote_user**” satırında, sistemler oynatılacak playbookun hangi kullanıcı ile oynatılacağı belirlenir. “**sudo**” satırı ile çalışacak komutların sudo yetkisi ile çalışması belirlenir. “**roles**” satırı altında bulunan satırlarda ise bu playbook çalıştığında “**base**” ve “**gitlab**” rollerinin çalışacağı belirtilmektedir. "**vars_files**" satırı altında gitlab playbookunun değişken dosyalarının bilgisi bulunmaktadır.

```
$ more /etc/ansible/playbooks/gitlab.yml
# Calistirildiginda Gitlab Kurulumu Yapilir
- hosts: gitlab
  remote_user: ahtapotops
  sudo: yes
  vars_files:
  - /etc/ansible/roles/base/vars/group.yml
  - /etc/ansible/roles/base/vars/user.yml
  - /etc/ansible/roles/base/vars/repo.yml
  - /etc/ansible/roles/base/vars/rsyslog.yml
  - /etc/ansible/roles/base/vars/ntp.yml
  - /etc/ansible/roles/base/vars/package.yml
  - /etc/ansible/roles/base/vars/blacklist.yml
  - /etc/ansible/roles/base/vars/host.yml
  - /etc/ansible/roles/base/vars/audit.yml
  - /etc/ansible/roles/base/vars/sudo.yml
  - /etc/ansible/roles/base/vars/ssh.yml
  - /etc/ansible/roles/base/vars/grub.yml
  - /etc/ansible/roles/base/vars/logger.yml
  - /etc/ansible/roles/base/vars/logrotate.yml
  - /etc/ansible/roles/base/vars/directory.yml
  - /etc/ansible/roles/base/vars/profile.yml
  - /etc/ansible/roles/gitlab/vars/package.yml
  - /etc/ansible/roles/gitlab/vars/hook.yml
  roles:
  - { role: base }
  - { role: gitlab }
```

####Gitlab Rolü Değişkenleri

Bu rol Ahtapot projesi kapsamındaki GitLab rolünü üstlenecek sunucularda ayarlamaların yapıldığı roldür.  Bu rolün görevleri:

    * GitLab sunucusu üzerinde bulunması gereken paketlerin kurulum ve denetimleri: 
	git,gitlab-ce
    * GitLab sunucusu yapılması gereken genel işlemler:
	   * git kullanıcısının yapılandırılması
	   * GitLab SSL yapılandırması
	   * GitLab SMTP yapılandırması
	   * GitLab yedeklilik yapılandırması


Bu roldeki değişkenler “**/etc/ansible/roles/gitlab/vars/**” dizini altındaki yml dosyalarında belirtilmiştir. Bu yml dosyalarının içerikleri ve değişken bilgileri aşağıdaki gibidir.

* “**main.yml**” dosyasının içeriği ve değişken bilgileri aşağıdaki gibidir;
* “**gitlab**” fonksiyonunda sunucu üzerindeki git kullanıcısına parola atanmaktadır. Her ne kadar SSH ile parolasız bağlantı sağlansa da, git kullanıcısının parolası olması gerekmektedir.

```
# GitLab'in degiskenlerinin tutuldugu dosyadir.
gitlab:
# git kullanicisini yapilandirmasi belirtilmektedir.
    user:
        name: git
        password: "jQCGY1Gp$rVz8u3qRyH3UCB.6MSnWToQv1qQYjYeatbBEA0pA4aqnjoTchjPDsm9CAeuk1xVKoV3MqM1C/UJZ6Fgap9XmB0"
```

* “**conf**” fonksiyonu ile “**/etc/gitlab/gitlab.rb**” dosyasına “**/etc/ansible/roles/gitlab/templates/**” altında bulunan “**gitlab.rb.j2**” dosyası kopyalanır ve hakları, erişim yetkileri belirlenir. 

```
   conf:
        source: gitlab.rb.j2
        destination: /etc/gitlab/gitlab.rb
        owner: root
        group: root
        mode: 0640
```

* “**ssl**” fonksiyonu ile “**/etc/gitlab/ssl**” dosyasının hakları, erişim yetkileri belirlenir. 

```

  ssl:
        directory:
            path: /etc/gitlab/ssl
            owner: root 
            group: root 
            mode: 700
            state: directory 
            recurse: yes 
```

* “**ssl-crt**” fonksiyonu ile “**/etc/gitlab/ssl/gitlab_makine_ismi.crt**” dosyasına “**/etc/ansible/roles/gitlab/templates/**” altında bulunan “**ssl-crt.j2**” dosyası kopyalanır ve hakları, erişim yetkileri belirlenir. 

```
ssl-crt:
        source: ssl-crt.j2
        destination: /etc/gitlab/ssl/gitlab.gdys.local.crt
        owner: root
        group: root
        mode: 600
```

* “**ssl-key**” fonksiyonu ile “**/etc/gitlab/ssl/gitlab_makine_ismi.key**” dosyasına “**/etc/ansible/roles/gitlab/templates/**” altında bulunan “**ssl-key.j2**” dosyası kopyalanır ve hakları, erişim yetkileri belirlenir. 

```
     ssl-key:
        source: ssl-key.j2
        destination: /etc/gitlab/gitlab_makine_ismi.key
        owner: root
        group: root
        mode: 600
```

* “**external_url**” fonksiyonu ile GitLab arayüzüne ulaşması istenilen URL adresi yazılır. “**firstrunpath**” de belirtilen, GitLab’ ın ilk yapılandırmasında adres bilgileri  bu dosyaya yazılır.

```
    external_url: https://URL_Adresi
    firstrunpath: /var/opt/gitlab/bootstrapped
```

*  “**gitlab_rails**” fonksiyonu ile GitLab sunucusunun bilgilendirme ayarları yapılmaktadır.  “**gitlab_email_from:**” satırına GitLab tarafından atılacak bilgilendirme postalarının hangi adres tarafından atılacağı belirtilmelidir. “**gitlab_email_display_name:**” satırında gönderilen postalarda görünmesi istenilen isim belirlenir. “**gitlab_email_reply_to:**” satırında GitLab tarafından gönderilen postalara cevap verilmesi durumunda cevabın hangi adrese yönlendirilmesi istendiği belirtilir. “**smtp_address:**” satırında smtp sunucusunun FQDN veya IP adres bilgileri girilir. “**smtp_port:**” satırında smtp sunucusunun kullandığı port yazılır. “**smtp_domain:**” satırında ise stmp alan adı bilgisi girilir.

```
   gitlab_rails:
        gitlab_email_enabled: "true"
        gitlab_email_from: gitlab@domain_adres 
        gitlab_email_display_name: Gitlab 
        gitlab_email_reply_to: no-reply@domain_adres
        gitlab_default_theme: 2
        gitlab_shell_ssh_port: SSH_port
        smtp_enable: "true" 
        smtp_address: smtp_adres
        smtp_port: 25 
        smtp_domain: domain_adres
        smtp_tls: "false"
```

* “**nginx**” fonksiyonu ile GitLab arayüzüne erişim adres çubuğunda “**http**” ile istek yapıldığında bağlantıyı otomatize bir şekilde “**https**” bağlantısına çevirmesi sağlanır.

```
    nginx:
        enable: "true"
        redirect_http_to_https: "true"
```
* "**backup**" fonkiyonu ile gitlab sunucusunun yedeğinin hangi sunucu üzerine alınacağı belirlenir. "**Server**" satırına yedek alınacak makinenin fqdn bilgisi girilir. "**Port**" satırına ise yedek alınacak sunucusun ssh portu yazılmalıdır.

```
backup:
        Server: gitlab02.gdys.local
        Port: 22
```

* "**ansible**" fonksiyonu altına ise ansible makinesinin fqdn ve ssh port bilgisi yazılmalıdır.

```
ansible:
        Server: ansible01.gdys.local
        Port: 22
```

* “**hook.yml**” dosyası ile GitLab sunucusu üzerinde bulunan her bir deponun yedeğini alarak, yedek GitLab sunucusuna dönülmesini sağlamaktadır. Bu işlem GitLab’ ın sağladığı “**custom hook**” yapısı ile sağlanmaktadır. "**hook_directories:**" fonksiyonu altında mys ve gdys custom_hook'larının dizinleri, hakları ve erişim bilgileri bulunmaktadır. "**hook_scripts**" fonksiyonu altında ise “**source**” satırında belirtilen “**/etc/ansible/roles/gitlab/templates**” altında bulunan “**post-receive.sh.j2**” dosyasının içeriğini “**destination**” satırlarında belirtilen tüm dizinlere kopyalanır ve hakları, erişim yetkileri belirlenir.

```
# Hook scriptlerini iceren dosyadir.
# Yorum satiri ile gosterilen sablon doldurularak istenilen kadar dosya ve klasor eklenebilir.

hook_directories:
    directory01:
        path: "/var/opt/gitlab/git-data/repositories/ahtapotops/mys.git/custom_hooks/" 
        owner: "git" 
        group: "git" 
        state: "directory" 
        mode: "755" 
    directory02:
        path: "/var/opt/gitlab/git-data/repositories/ahtapotops/gdys.git/custom_hooks/" 
        owner: "git" 
        group: "git" 
        state: "directory" 
        mode: "755" 
#    directoryXX:
#        path: 
#        owner: 
#        group: 
#        state:  
#        mode: 

hook_scripts:
    script01:
        source: "post-receive-mys.sh.j2" 
        destination: "/var/opt/gitlab/git-data/repositories/ahtapotops/mys.git/custom_hooks/post-receive" 
        owner: "git" 
        group: "git" 
        mode: "0770" 
    script02:
        source: "post-receive-gdys.sh.j2" 
        destination: "/var/opt/gitlab/git-data/repositories/ahtapotops/gdys.git/custom_hooks/post-receive" 
        owner: "git" 
        group: "git" 
        mode: "0770" 
#    scriptXX:
#        source: 
#        destination: 
#        owner: 
#        group: 
#        mode:
```
* “**package.yml**” dosyasına sistemler üzerine kurulacak paket değişkenlerini içeren dosyadır. "**name**" satırına paket adı ve versiyon bilgisi yazılır. “**state**” satırı ile paketlerin durumu ile ilgili bilgi verilir. Üç farklı değişken kullanılabilir; “**present**” paket yüklü ise herhangi değişiklik yapmaz. “**absent**” değişkeni ile paketin yüklü olması durumunda sistemden silinmesi sağlanır. “**latest**” değişkeni ile paket reposunda ilgili paketin güncel versiyonu var ise otomatik güncellenmesi sağlanır. 

```
# Paket degiskenlerini iceren dosyadir.
# Yorum satiri ile gosterilen sablon doldurularak istenilen kadar paket eklenebilir.
gitlab_packages:
    package01:
        name: "git=1:2.1.4-2.1+deb8u2"
        state: "present"
    package02:
        name: "gitlab-ce=8.4.4-ce.0"
        state: "present"
#    packageXX:
#        name:
#        state:
#    packageXX:
#        name:
#        state:
```

####FirewallBuilder

Ahtapot projesi kapsamında merkezde bulunacak ve güvenlik duvarlarının yönetilmesini sağlayacak playbook’dur. “**/etc/ansible/playbooks/**” dizini altında bulunan “**firewallbuilder.yml**” dosyasına bakıldığında, “**hosts**” satırında Ansible’a ait “**/etc/ansible/**” altında bulunan “**hosts**” dosyasında “**[firewallbuilder]**” satırı altına yazılmış tüm sunucularda bu playbookun oynatılacağı belirtilir. “**remote_user**” satırında, sistemler oynatılacak playbookun hangi kullanıcı ile oynatılacağı belirlenir. “**sudo**” satırı ile çalışacak komutların sudo yetkisi ile çalışması belirlenir. “**roles**” satırı altında bulunan satırlarda ise bu playbook çalıştığında “**base**” ve “**firewallbuilder**” rollerinin çalışacağı belirtilmektedir. "**vars_files**" satırı altında firewallbuilder playbookunun değişken dosyaları belirtilmiştir.

```
$ more /etc/ansible/playbooks/firewallbuilder.yml
# Calistirildiginda FirewallBuilder Kurulumu Yapilir
- hosts: firewallbuilder
  remote_user: ahtapotops
  sudo: yes
  vars_files:
  - /etc/ansible/roles/base/vars/group.yml
  - /etc/ansible/roles/base/vars/user.yml
  - /etc/ansible/roles/base/vars/repo.yml
  - /etc/ansible/roles/base/vars/rsyslog.yml
  - /etc/ansible/roles/base/vars/ntp.yml
  - /etc/ansible/roles/base/vars/package.yml
  - /etc/ansible/roles/base/vars/blacklist.yml
  - /etc/ansible/roles/base/vars/host.yml
  - /etc/ansible/roles/base/vars/audit.yml
  - /etc/ansible/roles/base/vars/sudo.yml
  - /etc/ansible/roles/base/vars/ssh.yml
  - /etc/ansible/roles/base/vars/grub.yml
  - /etc/ansible/roles/base/vars/logger.yml
  - /etc/ansible/roles/base/vars/logrotate.yml
  - /etc/ansible/roles/base/vars/directory.yml
  - /etc/ansible/roles/base/vars/profile.yml
  - /etc/ansible/roles/firewallbuilder/vars/package.yml
  - /etc/ansible/roles/firewallbuilder/vars/fwbuilder.yml
  - /etc/ansible/roles/firewallbuilder/vars/directory.yml
  - /etc/ansible/roles/firewallbuilder/vars/git.yml
  roles:
  - { role: base }
  - { role: firewallbuilder }
```


####FirewallBuilder Rolü Değişkenleri

Bu rol Ahtapot projesi kapsamındaki FirewallBuilder rolünü üstlenecek sunucularda ayarlamaların yapıldığı roldür.  Bu rolün görevleri:

    * FirewallBuilder sunucusu üzerinde bulunması gereken paketlerin kurulum ve denetimleri: 
	fwbuilder, git, python-qt4, python-requests, python-pexpect, xauth, ahtapot-gdys-gui

    * FirewallBuilder sunucusu yapılması gereken genel işlemler:
	   * Onay mekanizmasını barındıran gdys-gui uygulamasının konumlandırılması ve yapılandırılması
	   * Onay deposunun bulunduğu GitLab GDYS deposunun konumlandırılması ve yapılandırılması


Bu roldeki değişkenler “**/etc/ansible/roles/firewallbuilder/vars/**” dizini altındaki yml dosyaları içerisinde belirtilmiştir. yml dosyalarının içerikleri ve değişken bilgileri aşağıdaki gibidir;

* “**package.yml**” dosyasına sistemler üzerine kurulacak paket değişkenlerini içeren dosyadır. "**name**" satırına paket adı ve versiyon bilgisi yazılır. “**state**” satırı ile paketlerin durumu ile ilgili bilgi verilir. Üç farklı değişken kullanılabilir; “**present**” paket yüklü ise herhangi değişiklik yapmaz. “**absent**” değişkeni ile paketin yüklü olması durumunda sistemden silinmesi sağlanır. “**latest**” değişkeni ile paket reposunda ilgili paketin güncel versiyonu var ise otomatik güncellenmesi sağlanır.
```
# Paket degiskenlerini iceren dosyadir.
# Yorum satiri ile gosterilen sablon doldurularak istenilen kadar paket eklenebilir.
firewallbuilder_packages:
    package01:
        name: "fwbuilder=5.1.0-4"
        state: "present"
    package02:
        name: "git=1:2.1.4-2.1+deb8u2"
        state: "present"
    package03:
        name: "python-qt4=4.11.2+dfsg-1"
        state: "present"
    package04:
        name: "python-requests=2.4.3-6"
        state: "present"
    package05:
        name: "python-pexpect=3.2-1"
        state: "present"
    package06:
        name: "xauth=1:1.0.9-1"
        state: "present"
    package07:
        name: "ahtapot-gdys-gui=1.0.10"
        state: "present"
#    packageXX:
#        name:
#        state:
#    packageXX:
#        name:
#        state:
```

* "**fwbuilder.yml**" dosyası içerisindeki “**fix**” fonksiyonu, FirewallBuilder tarafında  oluşan xlock problemini çözmek üzere oluşturulmuş fonksiyondur. "**bash**" fonksiyonu ise "**/etc/ansible/roles/firewallbuilder/templates**" dizini altında bulunan "**fwbuilder-ahtapot.sh.j2**" scripti "**/etc/profile.d/**" dizini altına yerleştirir ve  “**owner**”, “**group**” ve “**mode**” ile bu dosyanın sahibi olan kullanıcı, grup ve hakları belirlenir.

```
# Guvenlik Duvari Kurucusunun degiskenlerini iceren dosyadir.
firewallbuilder:
    fix:
        source: "reset_iptables"
        destination: "/usr/share/fwbuilder-5.1.0.3599/configlets/linux24/reset_iptables"
        group: "root"
        owner: "root"
        mode: "0644"
        force: "yes"
    bash:
        conf:
            source: "fwbuilder-ahtapot.sh.j2"
            destination: "/etc/profile.d/fwbuilder-ahtapot.sh"
            owner: "root"
            group: "root"
            mode: "0755"
```

* “**directory.yml**” dosyası içerisinde FirewallBuilder sunucusu üzerinde oluşturulacak dizinler ve bu dizinlerin hakları ve erişim yetkileri belirtilmektedir. "**directory02**" onay mekanizmasina gitmeden test scriptlerinin konumlandırıldığı dizini belirtmektedir.
```
# Dizinleri iceren dosyadir.
directories:
    directory01:
        path: "/etc/fw/"
        group: "ahtapotops"
        owner: "ahtapotops"
        mode: "750"
        state: "directory"
    directory02:
        path: "/home/ahtapotops/testfw/"
        group: "ahtapotops"
        owner: "ahtapotops"
        mode: "750"
        state: "directory"
#    directoryXX:
#        path: ""
#        group: ""
#        owner: ""
#        mode: ""
#        state: ""
```

* “**git.yml**”  dosyası içerisinde FirewallBuilder sunucusunda bulunacak git depolarının bilgileri girilmektedir. “**repo01**” satırına MYS kapsamında kurulmuş Yerel GitLab sunucusunda bulunan ilgili depo adresi girilir. "**accepthostkey**” satırında bağlantı sırasında sunucu anahtarını kabul edilip edilmeyeceğine dair soru geldiğinde kabul etmesine zorlamaktadır. “**destination**” alt fonksiyonu ile GitLab deposunun kopyalanacağı dizin ve bu dizinin hakları, erişim yetkileri belirtilmektedir.  “**keyfile**” satırı ile GitLab’a erişecek kullanıcının anahtar bilgisi girilmektedir.

```
# Git repolarini iceren dosyadir.
gitrepos:
    repo01:
        repo: "ssh://git@gitlab01.gdys.local:4444/ahtapotops/gdys.git"
        accept_hostkey: "yes"
        destination: "/etc/fw/gdys"
        key_file: "/home/ahtapotops/.ssh/id_rsa"
#    repoXX:
#        repo: ""
#        accept_hostkey: ""
#        destination: ""
#        key_file: ""
```

####Rsyslog

Ahtapot projesi kapsamında merkezde bulunacak ve logların gönderilerek tutulacağı sunucuları oluşturacak playbook’dur. “**/etc/ansible/playbooks/**” dizini altında bulunan “**rsyslog.yml**” dosyasına bakıldığında, “**hosts**” satırında Ansible’a ait “**/etc/ansible/**” altında bulunan “**hosts**” dosyasında “**[rsyslog]**” satırı altına yazılmış tüm sunucularda bu playbookun oynatılacağı belirtilir. “**remote_user**” satırında, sistemler oynatılacak playbookun hangi kullanıcı ile oynatılacağı belirlenir. “**sudo**” satırı ile çalışacak komutların sudo yetkisi ile çalışması belirlenir. "**vars_files**" satırı rsyslog playbookunun değişken dosyalarını belirtmektedir. “**roles**” satırı altında bulunan satırlarda ise bu playbook çalıştığında “**base**” ve “**rsyslog**” rollerinin çalışacağı belirtilmektedir. 

```
$ more /etc/ansible/playbooks/rsyslog.yml
# Calistirildiginda Rsyslog Sunucu Kurulumu Yapilir
- hosts: rsyslog
  remote_user: ahtapotops
  sudo: yes
  vars_files:
  - /etc/ansible/roles/base/vars/group.yml
  - /etc/ansible/roles/base/vars/user.yml
  - /etc/ansible/roles/base/vars/repo.yml
  - /etc/ansible/roles/base/vars/rsyslog.yml
  - /etc/ansible/roles/base/vars/ntp.yml
  - /etc/ansible/roles/base/vars/package.yml
  - /etc/ansible/roles/base/vars/blacklist.yml
  - /etc/ansible/roles/base/vars/host.yml
  - /etc/ansible/roles/base/vars/audit.yml
  - /etc/ansible/roles/base/vars/sudo.yml
  - /etc/ansible/roles/base/vars/ssh.yml
  - /etc/ansible/roles/base/vars/grub.yml
  - /etc/ansible/roles/base/vars/logger.yml
  - /etc/ansible/roles/base/vars/logrotate.yml
  - /etc/ansible/roles/base/vars/directory.yml
  - /etc/ansible/roles/base/vars/profile.yml
  - /etc/ansible/roles/rsyslog/vars/package.yml
  - /etc/ansible/roles/rsyslog/vars/logrotate.yml
  - /etc/ansible/roles/rsyslog/vars/signer.yml
  - /etc/ansible/roles/rsyslog/vars/rsyslog.yml
  roles:
  - { role: base }
  - { role: rsyslog }
```


####Rsyslog Rolü Değişkenleri

Bu rol Ahtapot projesi kapsamındaki Rsyslog rolünü üstlenecek sunucularda ayarlamaların yapıldığı roldür.  Bu rolün görevleri:

    * Rsyslog sunucusu üzerinde bulunması gereken paketlerin kurulum ve denetimleri: 
	rsyslog,logrotate 
    * Rsyslog sunucusu yapılması gereken genel işlemler:
	   * Rsyslog yapılandırılması
	   * Logrotate yapılandırılması

Bu roldeki değişkenler “**/etc/ansible/roles/rsyslog/vars/**” dizini altında bulunan yml dosyalarında belirtilmiştir. yml dosyalarının içerikleri ve değişken bilgileri aşağıdaki gibidir;

* “**package.yml**” dosyasına sistemler üzerine kurulacak paket değişkenlerini içeren dosyadır. "**name**" satırına paket adı ve versiyon bilgisi yazılır. “**state**” satırı ile paketlerin durumu ile ilgili bilgi verilir. Üç farklı değişken kullanılabilir; “**present**” paket yüklü ise herhangi değişiklik yapmaz. “**absent**” değişkeni ile paketin yüklü olması durumunda sistemden silinmesi sağlanır. “**latest**” değişkeni ile paket reposunda ilgili paketin güncel versiyonu var ise otomatik güncellenmesi sağlanır.
```
# Paket degiskenlerini iceren dosyadir.
# Yorum satiri ile gosterilen sablon doldurularak istenilen kadar paket eklenebilir.
rsyslog_packages:
    package01:
        name: "rsyslog=8.4.2-1+deb8u2"
        state: "present"
    package02:
        name: "logrotate=3.8.7-1+b1"
        state: "present"
    package03:
        name: "rsync=3.1.1-3"
        state: "present"
    package04:
        name: "openjdk-7-jre=7u101-2.6.6-2~deb8u1"
        state: "present"
    package05:
        name: "zamaneconsole=1.0.1"
        state: "present"
#    packageXX:
#        name:
#        state:
#    packageXX:
#        name:
#        state:
```

* “**rsyslog.yml**” dosyası içerisinde bu rolü üstelencek sunucu üzerindeki gerekli yapılandırma yapılmaktadır. “**conf**” alt fonksiyonu ile “**/etc/rsyslog.conf**” dosyasına “**/etc/ansible/roles/rsyslog/templates/**” altında bulunan “**rsyslog.conf.j2**” dosyası kopyalanır ve hakları, erişim yetkileri belirlenir. “**service**” alt fonksiyonu ile rsyslog servisi yeniden başlatılır. “**WorkDirectory**” satırı ile uygulamanın çalışacağı dizin belirtilir. “**IncludeConfig**” satırında uygulamaya ait yapılandırma dosyaları belirtilir. “**RemoteLogDirectory**” satırı ile diğer sunuculardan gelen logların konumlandırılacağı dizin belirtilir.

```
# Rsyslog'un degiskenlerini iceren dosyadir
rsyslog:
    conf:
        source: "rsyslog.conf.j2"
        destination: "/etc/rsyslog.conf"
        owner: "root"
        group: "root"
        mode: "0644"
    service:
        name: "rsyslog"
        state: "started"
        enabled: "yes"
    WorkDirectory: "/var/spool/rsyslog"
    IncludeConfig: "/etc/rsyslog.d/*"
    RemoteLogDirectory: "/data/log/%HOSTNAME%/%fromhost-ip%.log"
```

* “**logrotate.yml**” dosyası içerisinde bu rolü üstelencek sunucu üzerindeki gerekli yapılandırma yapılmaktadır. “**conf**” alt fonksiyonu ile “**/etc/logrotate.d/rsyslog**” dosyasına “**/etc/ansible/roles/rsyslog/templates/**” altında bulunan “**rsyslog.j2**” dosyası kopyalanır ve hakları, erişim yetkileri belirlenir. “**Directory**” satırı ile logların konumlandırılacağı dizin belirtilir. 

```
    logrotate:
# Rsyslog yapilandirmasini belirtmektedir.
        conf:
            source: rsyslog.j2
            destination: /etc/logrotate.d/rsyslog
            owner: root
            group: root
            mode: 644 
        Directory: "/data/log"
```

* “**signer.yml**” fonksiyonunda 5651 log imzalama için gerekli script ve bilgiler bulunmaktadır. KamuSM Zamane ile imzalanacak durumlarda “**username**” ve “**password**” bölümlerine ilgili  kullanıcı adı ve parola bilgileri girilmelidir.

```
# Signer yapilandirmasini belirtmektedir.
signer:
    conf:
        source: "signer.bash.j2"
        destination: "/opt/signer.bash"
        owner: "root"
        group: "root"
        mode: "0750"
    directory:
        path: "/data/log/5651"
        owner: "root"
        group: "root"
        mode: "750"
        state: "directory"
    username: "tubitak"
    password: "'tubitak'"
    signingdirectory: "/data/log/5651/tmp"
    signedlogs: "/data/log/5651/signedlogs"
    invalidlogs: "/data/log/5651/invaledlogs"
    serverfiles: "squid0*"
    command: "/opt/ZamaneConsole-2.0.5/ZamaneConsole-2.0.5.jar"
    logs: "/data/log"
```

####TestFirewall

Ahtapot projesi kapsamında merkezde bulunan güvenlik duvarı yönetim sistemine dahil olan ve girilen kuralların güvenlik duvarlarında oynatılmadan önce imla açısından kontrol edilemsini sağlayacak sunucuyu oluşturan playbook’dur. “**/etc/ansible/playbooks/**” dizini altında bulunan “**testfirewall.yml**” dosyasına bakıldığında, “**hosts**” satırında Ansible’a ait “**/etc/ansible/**” altında bulunan “**hosts**” dosyasında “**[testfirewall]**” satırı altına yazılmış tüm sunucularda bu playbookun oynatılacağı belirtilir. “**remote_user**” satırında, sistemler oynatılacak playbookun hangi kullanıcı ile oynatılacağı belirlenir. “**sudo**” satırı ile çalışacak komutların sudo yetkisi ile çalışması belirlenir. "**vars_files**" satırı altında testfirewall playbookunun değişken dosyaları belirtilmektedir. “**roles**” satırı altında bulunan satırlarda ise bu playbook çalıştığında “**base**” ve “**firewall**” rollerinin çalışacağı belirtilmektedir.

```
$ more /etc/ansible/playbooks/testbuilder.yml
# Calistirildiginda Test Guvenlik Duvari Kurulumu Yapilir
- hosts: testfirewall
  remote_user: ahtapotops
  sudo: yes
  vars_files:
  - /etc/ansible/roles/base/vars/group.yml
  - /etc/ansible/roles/base/vars/user.yml
  - /etc/ansible/roles/base/vars/repo.yml
  - /etc/ansible/roles/base/vars/rsyslog.yml
  - /etc/ansible/roles/base/vars/ntp.yml
  - /etc/ansible/roles/base/vars/package.yml
  - /etc/ansible/roles/base/vars/blacklist.yml
  - /etc/ansible/roles/base/vars/host.yml
  - /etc/ansible/roles/base/vars/audit.yml
  - /etc/ansible/roles/base/vars/sudo.yml
  - /etc/ansible/roles/base/vars/ssh.yml
  - /etc/ansible/roles/base/vars/grub.yml
  - /etc/ansible/roles/base/vars/logger.yml
  - /etc/ansible/roles/base/vars/logrotate.yml
  - /etc/ansible/roles/base/vars/directory.yml
  - /etc/ansible/roles/base/vars/profile.yml
  - /etc/ansible/roles/testfirewall/vars/group.yml
  - /etc/ansible/roles/testfirewall/vars/user.yml
  - /etc/ansible/roles/testfirewall/vars/package.yml
  - /etc/ansible/roles/testfirewall/vars/module.yml
  - /etc/ansible/roles/testfirewall/vars/sysctl.yml
  - /etc/ansible/roles/testfirewall/vars/directory.yml
  roles:
  - { role: base }
  - { role: testfirewall }
```

####TestFirewall Rolü Değişkenleri

* "**group.yml**" dosyası içerisinde "**name**" satırında belirtildiği gibi kontrol isminde ve "**gid**" bilgisine sahip için group oluşturulmaktadır.

```
# Grup degiskenlerini iceren dosyadir.
# Yorum satiri ile gosterilen sablon doldurularak istenilen kadar grup eklenebilir.
testfirewall_groups:
    group1:
        name: "kontrol"
        gid: "1020"
        state: "present"
#    groupX:
#        name:
#        gid:
#        state:
```

* "**user.yml**" içerisinde "**uid**" takil kimlik bilgisine sahip kullanıcı TestFirewall sunucusunda oluşturulur.

```
# Kullanici degiskenlerini iceren dosyadir.
# Yorum satiri ile gosterilen sablon doldurularak istenilen kadar kullanici eklenebilir.
testfirewall_users:
    user1:
        name: "kontrol"
        uid: "1020"
        group: "kontrol"
        shell: "/bin/bash"
        state: "present"
        password: "$6$Q6I6.lT/$iGAJmNHkxMQy2qZAfJ9clPVFFbotTL8LUdkoQHenFqhZPNglPD.Ezr1AsuSGIUV48FeTIUe1VJj8dF7.vkmwv1"
#    userX:
#        name:
#        group:
#        shell:
#        state:
#        password:
```

* “**package.yml**” dosyasına sistemler üzerine kurulacak paket değişkenlerini içeren dosyadır. "**name**" satırına paket adı ve versiyon bilgisi yazılır. “**state**” satırı ile paketlerin durumu ile ilgili bilgi verilir. Üç farklı değişken kullanılabilir; “**present**” paket yüklü ise herhangi değişiklik yapmaz. “**absent**” değişkeni ile paketin yüklü olması durumunda sistemden silinmesi sağlanır. “**latest**” değişkeni ile paket reposunda ilgili paketin güncel versiyonu var ise otomatik güncellenmesi sağlanır.

```
# Paket degiskenlerini iceren dosyadir.
# Yorum satiri ile gosterilen sablon doldurularak istenilen kadar paket eklenebilir.
testfirewall_packages:
    package01:
        name: "iptables=1.4.21-2+b1"
        state: "present"
    package02:
        name: "iptables-persistent=1.0.3+deb8u1"
        state: "present"
    package03:
        name: "rsync=3.1.1-3"
        state: "present"
    package04:
        name: "keepalived=1:1.2.13-1"
        state: "present"
    package05:
        name: "iptraf=3.0.0-8.1"
        state: "present"
    package06:
        name: "ifenslave=2.6"
        state: "present"
#    packageXX:
#        name:
#        state:
#    packageXX:
#        name:
#        state:
```

* “**module.yml**” dosyası “**source**” satırında belirtilen ve “**/etc/ansible/roles/firewall/templates**” altında bulunan “**modules.j2**” dosyanında yer alan bilgiler çalıştığı tüm makinelerde “**/etc/modules.conf**” dizini altına atmaktadır. Akabinde bu dosyanın hakları ve erişim yetkileri belirlenir. "**testfirewall_modules**" altında bulunan modüller TestFirewall sunucusunda oluşturulur.

```
# Module degiskenlerini iceren dosyadir.
# Yorum satiri ile gosterilen sablon doldurularak istenilen kadar modul eklenebilir.
modprobe:
    conf:
        source: "modules.j2" 
        destination: "/etc/modules.conf" 
        owner: "root" 
        group: "root" 
        mode: "0644" 

testfirewall_modules:
    module01:
        name: "nf_conntrack_broadcast" 
        state: "present" 
    module02:
        name: "nf_conntrack_ftp" 
        state: "present" 
    module03:
        name: "nf_conntrack_h323" 
        state: "present" 
    module04:
        name: "nf_conntrack_irc" 
        state: "present" 
    module05:
        name: "nf_conntrack" 
        state: "present" 
    module06:
        name: "nf_conntrack_netlink" 
        state: "present" 
    module07:
        name: "nf_conntrack_netbios_ns" 
        state: "present" 
    module08:
        name: "nf_conntrack_proto_dccp" 
        state: "present" 
    module09:
        name: "nf_conntrack_pptp" 
        state: "present" 
    module10:
        name: "nf_conntrack_proto_gre" 
        state: "present" 
    module11:
        name: "nf_conntrack_proto_udplite" 
        state: "present" 
    module12:
        name: "nf_conntrack_proto_sctp" 
        state: "present" 
    module13:
        name: "xt_conntrack" 
        state: "present" 
#    moduleXX:
#        name: 
#        state:  
#    moduleXX:
#        name: 
#        state:
```

* “**sysctl.yml**” dosyası “**source**” satırında belirtilen ve “**/etc/ansible/roles/testfirewall/templates**” altında bulunan “**sysctl.conf.j2**” dosyanında yer alan bilgiler çalıştığı tüm makinelerde “**/etc/sysctl.conf**” dizini altına atmaktadır. Akabinde bu dosyanın hakları ve erişim yetkileri belirlenir. Diğer satırlarda ise, güvenlik duvarları için sıkılaştırma işlemleri yapılmaktadır.

```
# Guvenlik duvari isletim sistemi bazinda hardening parametreleri belirtilmektedir.
sysctl:
    conf:
        source: "sysctl.conf.j2"
        destination: "/etc/sysctl.conf"
        owner: "root"
        group: "root"
        mode: "0644"  
    ip_conntrack_max: "65536"    
    nf_conntrack_max: "65536"
    nf_conntrack_tcp_timeout_established: "600"
    ip_conntrack_tcp_timeout_established: "600"
    nf_conntrack_tcp_timeout_time_wait: "90"
    ip_conntrack_tcp_timeout_time_wait: "90"
    ip_local_port_range_start: "24576"
    ip_local_port_range_end: "65534"
    icmp_ignore_bougs_error_responses: "1"
    icmp_echo_ignore_broadcasts: "1"
    log_martians: "1"
    tcp_ecn: "1"
    tcp_syncookies: "1"
    tcp_abort_on_overflow: "1"
    tcp_tw_recycle: "0"
    tcp_tw_reuse: "1"
    tcp_window_scaling: "1"
    tcp_timestamps: "0"
    tcp_sack: "1"
    tcp_dsack: "1"
    tcp_fack: "1"
    tcp_keepalive_time: "1200"
    tcp_fin_timeout: "20"
    tcp_retries1: "3"
    tcp_syn_retries: "3"
    tcp_synack_retries: "2"
    tcp_max_syn_backlog: "4096"
    rp_filter: "0"
    accept_source_route: "1"
    accept_source_route_ipv6: "0"
    bootp_relay: "1"
    ip_forward: "1"
    secure_redirects: "1"
    send_redirects: "1"
    proxy_arp: "1"
```

* "**directory.yml**" dosyası TestFirewall sunucusunda olması gereken dizinleri içeren dosyadır."**testfirewall_directories:**" fonksiyonu altına olması gereken dizinler yazılır.  “**owner**”, “**group**” ve “**mode**” ile bu dizinin sahibi olan kullanıcı, grup ve hakları belirlenir. İstenildiği kadar dizin eklenebilir.


```
# Dizinleri iceren dosyadir.
testfirewall_directories:
    directory01:
        path: "/var/log/ahtapot/fw"
        group: "ahtapotops"
        owner: "ahtapotops"
        mode: "755"
        state: "directory"
#    directoryXX:
#        path: ""
#        group: ""
#        owner: ""
#        mode: ""
#        state: ""
```


####Firewall

Ahtapot projesi kapsamında merkezde bulunan güvenlik duvarı sunucusunun kurulumunu sağlayan  playbook’dur. “**/etc/ansible/playbooks/**” dizini altında bulunan “**firewall.yml**” dosyasına bakıldığında, “**hosts**” satırında Ansible’a ait “**/etc/ansible/**” altında bulunan “**hosts**” dosyasında “**[firewall]**” satırı altına yazılmış tüm sunucularda bu playbookun oynatılacağı belirtilir. “**remote_user**” satırında, sistemler oynatılacak playbookun hangi kullanıcı ile oynatılacağı belirlenir. “**sudo**” satırı ile çalışacak komutların sudo yetkisi ile çalışması belirlenir. "**vars_files**" satırı altında firewall playbookunun değişken dosyaları belirtilmektedir. “**roles**” satırı altında bulunan satırlarda ise bu playbook çalıştığında “**base**” ve “**firewall**” rollerinin çalışacağı belirtilmektedir.
```
$ more /etc/ansible/playbooks/firewall.yml
# Calistirildiginda Guvenlik Duvari Kurulumu Yapilir
- hosts: firewall
  remote_user: ahtapotops
  sudo: yes
  vars_files:
  - /etc/ansible/roles/base/vars/group.yml
  - /etc/ansible/roles/base/vars/user.yml
  - /etc/ansible/roles/base/vars/repo.yml
  - /etc/ansible/roles/base/vars/rsyslog.yml
  - /etc/ansible/roles/base/vars/ntp.yml
  - /etc/ansible/roles/base/vars/package.yml
  - /etc/ansible/roles/base/vars/blacklist.yml
  - /etc/ansible/roles/base/vars/host.yml
  - /etc/ansible/roles/base/vars/audit.yml
  - /etc/ansible/roles/base/vars/sudo.yml
  - /etc/ansible/roles/base/vars/ssh.yml
  - /etc/ansible/roles/base/vars/grub.yml
  - /etc/ansible/roles/base/vars/logger.yml
  - /etc/ansible/roles/base/vars/logrotate.yml
  - /etc/ansible/roles/base/vars/profile.yml
  - /etc/ansible/roles/base/vars/directory.yml
  - /etc/ansible/roles/firewall/vars/group.yml
  - /etc/ansible/roles/firewall/vars/user.yml
  - /etc/ansible/roles/firewall/vars/package.yml
  - /etc/ansible/roles/firewall/vars/module.yml
  - /etc/ansible/roles/firewall/vars/sysctl.yml
  - /etc/ansible/roles/firewall/vars/iptables.yml
  - /etc/ansible/roles/firewall/vars/contrackd.yml
  - /etc/ansible/roles/firewall/vars/profile.yml
  - /etc/ansible/roles/firewall/vars/directory.yml
  roles:
  - { role: base }
  - { role: firewall }
```
####Firewall Rolü Değişkenleri

Bu rol Ahtapot projesi kapsamındaki Firewall rolünü üstlenecek sunucularda ayarlamaların yapıldığı roldür.  Bu rolün görevleri:

    * Firewall sunucusu üzerinde bulunması gereken paketlerin kurulum ve denetimleri: 
	iptables,iptables-persistent,rsync,keepalived,iptraf,ifenslave

    * Firewall sunucusu yapılması gereken genel işlemler:
	   * Limitli Kullanıcı Konsol yapılandırması
	   * Kuralların barındığı git deposunun tanımlanması
	   * modprobe yapılandırılması
	   * sysctl yapılandırılması
	   * Güvenlik duvarı sıkılaştırmaları


Bu roldeki değişkenler “**/etc/ansible/roles/firewall/vars/**” dizini altında yml dosyları içerisinde belirtilmiştir. yml dosyalarının içerikleri ve değişken bilgileri aşağıdaki gibidir;

* "**group.yml**" dosyası içerisinde "**gid**" bilgisine sahip, limitli kullanıcı konsolu için group oluşturulmaktadır.

```
# Grup degiskenlerini iceren dosyadir.
# Yorum satiri ile gosterilen sablon doldurularak istenilen kadar grup eklenebilir.
user_groups:
    group1:
        name: lkk
        gid: 1010
        state: present
#    groupX:
#        name:
#        gid:
#        state:
```

* "**user.yml**" içerisinde "**uid**" takil kimlik bilgisine sahip kullanıcı Firewall sunucusunda oluşturulur ve bu kullanıcının limitli kullanıcı konsoluna erişim yapmasını sağlanır.

```
# Kullanici degiskenlerini iceren dosyadir.
# Yorum satiri ile gosterilen sablon doldurularak istenilen kadar kullanici eklenebilir.
firewall_users:
    user1:
        name: "lkk"
        uid: "1010"
        group: "lkk"
        shell: "/bin/bash"
        state: "present"
        password: "$6$dLiZAJhE$4319ZGktWgTmK8gPTyHcoI09AyVRPdE1asy5FNB2hzWBnAymB61wOaUGl9uznaWnV3gbclTLt6FGOGYEhML.S/"
#    userX:
#        name: 
#        group:
#        shell: 
#        state:  
#        password:
```

* “**package.yml**” dosyasına sistemler üzerine kurulacak paket değişkenlerini içeren dosyadır. "**name**" satırına paket adı ve versiyon bilgisi yazılır. “**state**” satırı ile paketlerin durumu ile ilgili bilgi verilir. Üç farklı değişken kullanılabilir; “**present**” paket yüklü ise herhangi değişiklik yapmaz. “**absent**” değişkeni ile paketin yüklü olması durumunda sistemden silinmesi sağlanır. “**latest**” değişkeni ile paket reposunda ilgili paketin güncel versiyonu var ise otomatik güncellenmesi sağlanır.

```
# Paket degiskenlerini iceren dosyadir.
# Yorum satiri ile gosterilen sablon doldurularak istenilen kadar paket eklenebilir.
firewall_packages:
    package01:
        name: "iptables=1.4.21-2+b1" 
        state: "present" 
    package02:
        name: "iptables-persistent=1.0.3+deb8u1" 
        state: "present" 
    package03:
        name: "rsync=3.1.1-3" 
        state: "present" 
    package04:
        name: "keepalived=1:1.2.13-1" 
        state: "present" 
    package05:
        name: "iptraf=3.0.0-8.1" 
        state: "present" 
    package06:
        name: "ifenslave=2.6" 
        state: "present" 
    package07:
        name: "conntrackd=1:1.4.2-2+deb8u1" 
        state: "present" 
    package08:
        name: "atop=1.26-2" 
        state: "present" 
    package09:
        name: "mtr-tiny=0.85-3" 
        state: "present" 
    package10:
        name: "iptstate=2.2.5-1" 
        state: "present" 
    package11:
        name: "bmon=1:3.5-1"
        state: "present" 
    package12:
        name: "ahtapot-lkk=1.1.5" 
        state: "present" 
#    packageXX:
#        name: 
#        state:  
#    packageXX:
#        name: 
#        state:
```

* “**iptables.yml**” doyasında "**service**" fonksiyonu içerisinde ipv4 ve ipv6 için sırasıyla /etc/iptables/rules.v4 ve /etc/iptables/rules.v6 kuralları yapılandırılır. "**deploy**" fonksiyonu içerisinde yerel GitLab sunucunda bulunan gdys deposu sunucu üzerine alınarak, betiklerin çalıştırılması sağlanır. Farklı ssh portu kullanıldığı durumlarda “**dest_port**” satırına bu bilgi yazılmalıdır.

```
# Iptables yapilandirmasini iceren dosyadir.
iptables:
    service:
        v4conf: "/etc/iptables/rules.v4"
        v6conf: "/etc/iptables/rules.v6"
    deploy:
        repopath: "/etc/fw/gdys"
        filepath: "/etc/fw/gdys/files"
        rsync_opts: "--force"
        dest_port: "4444"
        recursive: "yes"
```

* “**module.yml**” dosyası “**source**” satırında belirtilen ve “**/etc/ansible/roles/firewall/templates**” altında bulunan “**modules.j2**” dosyanında yer alan bilgiler çalıştığı tüm makinelerde “**/etc/modules.conf**” dizini altına atmaktadır. Akabinde bu dosyanın hakları ve erişim yetkileri belirlenir. "**firewall_modules**" altında bulunan modüller Firewall sunucusunda oluşturulur.

```
# Module degiskenlerini iceren dosyadir.
# Yorum satiri ile gosterilen sablon doldurularak istenilen kadar modul eklenebilir.
modprobe:
    conf:
        source: "modules.j2" 
        destination: "/etc/modules.conf" 
        owner: "root" 
        group: "root" 
        mode: "0644" 

firewall_modules:
    module01:
        name: "nf_conntrack_broadcast" 
        state: "present" 
    module02:
        name: "nf_conntrack_ftp" 
        state: "present" 
    module03:
        name: "nf_conntrack_h323" 
        state: "present" 
    module04:
        name: "nf_conntrack_irc" 
        state: "present" 
    module05:
        name: "nf_conntrack" 
        state: "present" 
    module06:
        name: "nf_conntrack_netlink" 
        state: "present" 
    module07:
        name: "nf_conntrack_netbios_ns" 
        state: "present" 
    module08:
        name: "nf_conntrack_proto_dccp" 
        state: "present" 
    module09:
        name: "nf_conntrack_pptp" 
        state: "present" 
    module10:
        name: "nf_conntrack_proto_gre" 
        state: "present" 
    module11:
        name: "nf_conntrack_proto_udplite" 
        state: "present" 
    module12:
        name: "nf_conntrack_proto_sctp" 
        state: "present" ontrackd
    module13:
        name: "xt_conntrack" 
        state: "present" 
#    moduleXX:
#        name: 
#        state:  
#    moduleXX:
#        name: 
#        state:
```

* “**sysctl.yml**” dosyası “**source**” satırında belirtilen ve “**/etc/ansible/roles/firewall/templates**” altında bulunan “**sysctl.conf.j2**” dosyanında yer alan bilgiler çalıştığı tüm makinelerde “**/etc/sysctl.conf**” dizini altına atmaktadır. Akabinde bu dosyanın hakları ve erişim yetkileri belirlenir. Diğer satırlarda ise, güvenlik duvarları için sıkılaştırma işlemleri yapılmaktadır.

```
# Guvenlik duvari isletim sistemi bazinda hardening parametreleri belirtilmektedir.
sysctl:
    conf:
        source: "sysctl.conf.j2"
        destination: "/etc/sysctl.conf"
        owner: "root"
        group: "root"
        mode: "0644"  
    ip_conntrack_max: "65536"    
    nf_conntrack_max: "65536"
    nf_conntrack_tcp_timeout_established: "600"
    ip_conntrack_tcp_timeout_established: "600"
    nf_conntrack_tcp_timeout_time_wait: "90"
    ip_conntrack_tcp_timeout_time_wait: "90"
    ip_local_port_range_start: "24576"
    ip_local_port_range_end: "65534"
    icmp_ignore_bougs_error_responses: "1"
    icmp_echo_ignore_broadcasts: "1"
    log_martians: "1"
    tcp_ecn: "1"
    tcp_syncookies: "1"
    tcp_abort_on_overflow: "1"
    tcp_tw_recycle: "0"
    tcp_tw_reuse: "1"
    tcp_window_scaling: "1"
    tcp_timestamps: "0"
    tcp_sack: "1"
    tcp_dsack: "1"
    tcp_fack: "1"
    tcp_keepalive_time: "1200"
    tcp_fin_timeout: "20"
    tcp_retries1: "3"
    tcp_syn_retries: "3"
    tcp_synack_retries: "2"
    tcp_max_syn_backlog: "4096"
    rp_filter: "0"
    accept_source_route: "1"
    accept_source_route_ipv6: "0"
    bootp_relay: "1"
    ip_forward: "1"
    secure_redirects: "1"
    send_redirects: "1"
    proxy_arp: "1"
```

* "**contrackd.yml**" dosyası “**source**” satırında belirtilen ve “**/etc/ansible/roles/firewall/templates**” altında bulunan “**primary-backup.sh.j2**” dosyanında yer alan bilgiler çalıştığı tüm makinelerde “**/etc/conntrackd/primary-backup.sh**” dizini altına atmaktadır. Akabinde bu dosyanın hakları ve erişim yetkileri belirlenir.

```
# Contrackd yapilandirmasini iceren dosyadir.
conntrackd:
    script:
        source: "primary-backup.sh.j2"
        destination: "/etc/conntrackd/primary-backup.sh"
        owner: "root"
        group: "root"
        mode: "755"
```

* "**directory.yml**" dosyası Firewall sunucusunda olması gereken dizinleri içeren dosyadır."**firewall_directories**" fonksiyonu altına olması gereken dizinler yazılır.  “**owner**”, “**group**” ve “**mode**” ile bu dizinin sahibi olan kullanıcı, grup ve hakları belirlenir. İstenildiği kadar dizin eklenebilir.

```
# Dizinleri iceren dosyadir.
firewall_directories:
    directory01:
        path: "/var/log/ahtapot/fw"
        group: "ahtapotops"
        owner: "ahtapotops"
        mode: "755"
        state: "directory"
    directory02:
        path: "/etc/fw"
        group: "ahtapotops"
        owner: "ahtapotops"
        mode: "750"
        state: "directory"
    directory03:
        path: "/etc/fw/gdys"
        group: "ahtapotops"
        owner: "ahtapotops"
        mode: "750"
        state: "directory"
#    directoryXX:
#        path: ""
#        group: ""
#        owner: ""
#        mode: ""
#        state: ""
```

####Maintenance

Ahtapot projesi kapsamında Ansible tarafından yönetilen tüm sunucularda bakım işlemlerinin yapıldığı playbook’dur. “**/etc/ansible/playbooks/**” dizini altında bulunan “**maintenance.yml**” dosyasına bakıldığında tüm sunucularda bu playbookun oynatılacağı belirtilir. “**remote_user**” satırında, sistemler oynatılacak playbookun hangi kullanıcı ile oynatılacağı belirlenir. “**sudo**” satırı ile çalışacak komutların sudo yetkisi ile çalışması belirlenir. “**roles**” satırı altında bulunan satırlarda ise bu playbook çalıştığında “**maintenance**” rolünün çalışacağı belirtilmektedir.

```

$ more /etc/ansible/playbooks/maintenance.yml
# Bakim scripti
- hosts: all
  remote_user: ahtapotops 
  sudo: yes
  roles:
  - { role: maintenance }
```

####Maintenance Rolü Değişkenleri

Bu rol Ahtapot projesi kapsamındaki tüm sunucularda bakım işlemlerinin yapıldığı roldür.  Bu rolün görevleri:

* Tüm sistemlerde loglar ile ilgili yapılması gereken bakım işlemleri:


Bu roldeki değişkenler “**/etc/ansible/roles/maintenance/vars/main.yml**” dosyasında belirtilmiştir. “**main.yml**” dosyasının içeriği ve değişken bilgileri aşağıdaki gibidir;


* “**script**” fonksiyonunda “**source**” satırında belirtilen ve “**/etc/ansible/roles/maintenance/templates**” altında bulunan “**ahtapot-pyBekci.py.j2**” dosyasının içeriği playbookun çalıştığı tüm makinelerde “**/var/opt/ahtapot-pkBekci.py**” dosyasına kopyalanır. Akabinde bu dosyanın hakları ve erişim yetkileri belirlenir.

```

    script:
        source: ahtapot-pyBekci.py.j2 
        destination: /var/opt/ahtapot-pyBekci.py 
        owner: ahtapotops 
        group: ahtapotops 
        mode: 660 
```


* “**maintainer**” fonksiyonunda belirlenen süreden daha eski loglar “**/var/log/bekciarchive**” dizinine taşınır ve bu dizinin hakları ve erişim yetkileri belirlenir.

```

    maintainer:
        directory: 
            path: /var/log/bekciarchive/
            owner: ahtapotops 
            group: ahtapotops
            mode: 700 
            state: directory 
            recurse: yes 

```

####State

Ahtapot projesi kapsamında Ansible tarafından yönetilen tüm makinelerin durum kontrolünü yapan playbook’dur. Bu playbook, işletim sistemi bazında crontabta berlitilen zaman aralıkları ile çalışarak sistemlerin aynı durumda kalmasını sağlar. “**/etc/ansible/playbooks/**” dizini altında bulunan “**state.yml**” dosyasına bakıldığında tüm sunucularda bu playbookun oynatılacağı belirtilir. “**remote_user**” satırında, sistemler oynatılacak playbookun hangi kullanıcı ile oynatılacağı belirlenir. “**sudo**” satırı ile çalışacak komutların sudo yetkisi ile çalışması belirlenir. “**roles**” satırı altında bulunan satırlarda ise bu playbook çalıştığında oynayacak rolleri belirtilmektedir. 


```
$ more /etc/ansible/playbooks/state.yml
# Sistem stabilitesini tutacak olan ansible dosyasi
- hosts: all 
  remote_user: ahtapotops 
  sudo: yes
  vars_files:
  - /etc/ansible/roles/base/vars/group.yml
  - /etc/ansible/roles/base/vars/user.yml
  - /etc/ansible/roles/base/vars/repo.yml
  - /etc/ansible/roles/base/vars/rsyslog.yml
  - /etc/ansible/roles/base/vars/ntp.yml
  - /etc/ansible/roles/base/vars/package.yml
  - /etc/ansible/roles/base/vars/blacklist.yml
  - /etc/ansible/roles/base/vars/host.yml
  - /etc/ansible/roles/base/vars/audit.yml
  - /etc/ansible/roles/base/vars/sudo.yml
  - /etc/ansible/roles/base/vars/ssh.yml
  - /etc/ansible/roles/base/vars/grub.yml
  - /etc/ansible/roles/base/vars/profile.yml
  - /etc/ansible/roles/base/vars/logger.yml
  - /etc/ansible/roles/base/vars/logrotate.yml
  - /etc/ansible/roles/base/vars/directory.yml
  roles:
  - { role: base }

- hosts: ansible
  remote_user: ahtapotops 
  sudo: yes
  vars_files:
  - /etc/ansible/roles/ansible/vars/package.yml
  - /etc/ansible/roles/ansible/vars/ansible.yml
  - /etc/ansible/roles/ansible/vars/directory.yml
  - /etc/ansible/roles/ansible/vars/git.yml
  - /etc/ansible/roles/ansible/vars/gkts.yml
  roles:
  - { role: ansible }

- hosts: gitlab
  remote_user: ahtapotops
  sudo: yes
  vars_files:
  - /etc/ansible/roles/gitlab/vars/package.yml
  - /etc/ansible/roles/gitlab/vars/hook.yml
  roles:
  - { role: gitlab }

- hosts: firewallbuilder
  remote_user: ahtapotops 
  sudo: yes
  vars_files:
  - /etc/ansible/roles/firewallbuilder/vars/package.yml
  - /etc/ansible/roles/firewallbuilder/vars/fwbuilder.yml
  - /etc/ansible/roles/firewallbuilder/vars/directory.yml
  - /etc/ansible/roles/firewallbuilder/vars/git.yml
  roles:
  - { role: firewallbuilder }

- hosts: rsyslog 
  remote_user: ahtapotops 
  sudo: yes
  vars_files:
  - /etc/ansible/roles/rsyslog/vars/package.yml
  - /etc/ansible/roles/rsyslog/vars/logrotate.yml
  - /etc/ansible/roles/rsyslog/vars/signer.yml
  - /etc/ansible/roles/rsyslog/vars/rsyslog.yml
  roles:
  - { role: rsyslog }

- hosts: pwlm
  remote_user: ahtapotops
  sudo: yes
  vars_files:
  - /etc/ansible/roles/pwlm/vars/package.yml
  - /etc/ansible/roles/pwlm/vars/uwsgi.yml
  - /etc/ansible/roles/pwlm/vars/pwlm.yml
  - /etc/ansible/roles/pwlm/vars/git.yml
  roles:
  - { role: pwlm }

- hosts: gkts
  remote_user: ahtapotops
  sudo: yes
  vars_files:
  - /etc/ansible/roles/gkts/vars/package.yml
  - /etc/ansible/roles/gkts/vars/gkts.yml
  - /etc/ansible/roles/gkts/vars/nginx.yml
  - /etc/ansible/roles/gkts/vars/uwsgi.yml
  roles:
  - { role: gkts }

- hosts: testfirewall
  remote_user: ahtapotops
  sudo: yes
  vars_files:
  - /etc/ansible/roles/testfirewall/vars/group.yml
  - /etc/ansible/roles/testfirewall/vars/user.yml
  - /etc/ansible/roles/testfirewall/vars/package.yml
  - /etc/ansible/roles/testfirewall/vars/module.yml
  - /etc/ansible/roles/testfirewall/vars/sysctl.yml
  - /etc/ansible/roles/testfirewall/vars/directory.yml
  roles:
  - { role: testfirewall }

- hosts: firewall:firewall-proxy-dhcp:firewall-openvpn
  remote_user: ahtapotops
  sudo: yes
  vars_files:
  - /etc/ansible/roles/firewall/vars/group.yml
  - /etc/ansible/roles/firewall/vars/user.yml
  - /etc/ansible/roles/firewall/vars/package.yml
  - /etc/ansible/roles/firewall/vars/module.yml
  - /etc/ansible/roles/firewall/vars/sysctl.yml
  - /etc/ansible/roles/firewall/vars/iptables.yml
  - /etc/ansible/roles/firewall/vars/directory.yml
  - /etc/ansible/roles/firewall/vars/contrackd.yml
  - /etc/ansible/roles/firewall/vars/profile.yml
  roles:
  - { role: firewall }

- hosts: proxy:proxy-dhcp:firewall-proxy-dhcp
  remote_user: ahtapotops
  sudo: yes
  vars_files:
  - /etc/ansible/roles/squid/vars/package.yml
  - /etc/ansible/roles/squid/vars/squid.yml
  - /etc/ansible/roles/squid/vars/dansguardian.yml
  - /etc/ansible/roles/squid/vars/updshalla.yml
  - /etc/ansible/roles/squid/vars/zeustracker.yml
  - /etc/ansible/roles/squid/vars/sarg.yml
  - /etc/ansible/roles/squid/vars/nginx.yml
  roles:
  - { role: squid }

- hosts: dhcp:proxy-dhcp:firewall-proxy-dhcp
  remote_user: ahtapotops
  sudo: yes
  vars_files:
  - /etc/ansible/roles/dhcpd/vars/package.yml
  - /etc/ansible/roles/dhcpd/vars/dhcpd.yml
  roles:
  - { role: dhcpd }

- hosts: openvpn:firewall-openvpn
  remote_user: ahtapotops
  sudo: yes
  vars_files:
  - /etc/ansible/roles/openvpn/vars/package.yml
  - /etc/ansible/roles/openvpn/vars/openvpn.yml
  - /etc/ansible/roles/openvpn/vars/sysctl.yml
  roles:
  - { role: openvpn }
```

####Kullanıcı ve Grup Değiştirme (Daha sonra düzenlenecek)


Bu dokümanda, Ahtapot sistemindeki altyapıyı yöneten kullanıcı ve grubunu değiştirmek için yapılması gerekenler anlatılıyor.


####Sunucularda Yeni Kullanıcı ve Grup Oluşturma

* Sunuculara yeni kullanıcı ve grup oluşturmak için, Ansible makinesine bağlantı sağlanarak /etc/ansible klasörüne gidilir.

```
$ cd /etc/ansible

```

* İlgili klasör altında bulunan base rolünün dizininden presentgroup ve presentuser değerlerine yeni kullanıcı adı ve grup adı verilir. Dosya içerisinde ilgili parametreye karşılık gelen tüm satırlar aynı şekilde değiştirilir.

```
$ sudo vi roles/base/vars/main.yml
presentgroup: yeni_grup_adı
presentuser: yeni_kullanıcı_adı
```

* Gerekli değişiklikler yapıldıktan sonra, değişikliğin yapılacağı tüm sunucular üzerinde playbook oynaması beklenir. AHTAPOT GDYS Kullanım dokümanı takip edilerek daha önceden crontabta çalışması ayarlanmış olan playbookların oynama periyotları doğrultusunda tüm sistemlerde değişiklik otomatik olarak yapılacaktır. 

**NOT :** Tüm sunucularda ilgili playbookun oynatıldığından emin olmadan bir sonraki adıma geçmeyiniz.

####Rollerdeki Kullanıcı ve Grup Yapılandırması (Daha sonra düzenlenecek)

* İlk işlemi başarılı bir şekilde yaptıktan sonra eski kullanıcı ve grubun hardcoded yazılmış olduğu yerleri yeni kullanıcı ile değiştiriyoruz.
* Gitlab sunucusuna bağlantıda kullanılan anahtar dosyasının yeri yeni kullanıcı için oluşturulmuş anahtar dosyasının yeri ile değiştirilir. Dosya içerisinde ilgili parametreye karşılık gelen tüm satırlar aynı şekilde değiştirilir.

```
$ sudo vi /etc/ansible/roles/ansible/vars/main.yml
keyfile:/home/yeni_kullanıcı/.ssh/id_rsa
```

* Base role içerisinde tanımlanmış olan sudoers ve audit konfigurasyonunda kullanılan değişkenler için ilgili satırlar değiştirilir. Dosya içerisinde ilgili parametreye karşılık gelen tüm satırlar aynı şekilde değiştirilir.

```
$ sudo vi /etc/ansible/roles/base/vars/main.yml
newgroup:yeni_grup_adı
name:**”yeni_kullanıcı_adı**”
```

* Firewallbuilder rolü içerisinde, dosyaların haklarını düzenlemek ve gitlab sunucusuna parolasız erişim için kullanılan anahtar ile test güvenlik duvarında kuralların kopyalanacağı dizin belirtilir. Dosya içerisinde ilgili parametreye karşılık gelen tüm satırlar aynı şekilde değiştirilir.

```
$ sudo vi /etc/ansible/roles/firewallbuilders/vars/main.yml
ownergroup:yeni_grup_adı
owneruser:yeni_kullanıcı_adı
testpath:/home/yeni_kullanıcı_adı/testfw
keyfile:/home/yeni_kullanıcı_adı/.ssh/id_rsa
```

* Gerekli değişiklikler yapıldıktan sonra, değişikliğin yapılacağı tüm sunucular üzerinde playbook oynaması beklenir. AHTAPOT GDYS Kullanım dokümanı takip edilerek daha önceden crontabta çalışması ayarlanmış olan playbookların oynama periyotları doğrultusunda tüm sistemlerde değişiklik otomatik olarak yapılacaktır. 

**NOT: Tüm sunucularda ilgili playbookun oynatıldığından emin olmadan bir sonraki adıma geçmeyiniz.**


####Playbooklarda Çalışan Kullanıcının Değiştirilmesi

* İlk iki işlemi başarılı bir şekilde yaptıktan sonra ansible makinesinin başarılı olarak bağlanabilmesi için playbooklarda tanımlı remote_user ‘a yeni geçerli kullanıcı adının girilmesi gerekmektedir.
* Aşağıda belirtilen tüm “**vi**” komutları sırası ile çalıştırılarak “**remote_user:**” satırındaki ahtapotops kullanıcısı yerine yeni oluşturulan kullanıcı bilgisi yazılır.

```

$ sudo vi /etc/ansible/playbooks/ansible.yml
$ sudo vi /etc/ansible/playbooks/firewall.yml
$ sudo vi /etc/ansible/playbooks/firewallbuilder.yml
$ sudo vi /etc/ansible/playbooks/gitlab.yml
$ sudo vi /etc/ansible/playbooks/testbuilder.yml
$ sudo vi /etc/ansible/playbooks/deploy.yml
$ sudo vi /etc/ansible/playbooks/state.yml
remote_user: yeni_kullanıcı_adı
```

* Gerekli değişiklikler yapıldıktan sonra, değişikliğin yapılacağı tüm sunucular üzerinde playbook oynaması beklenir. AHTAPOT GDYS Kullanım dokümanı takip edilerek daha önceden crontabta çalışması ayarlanmış olan playbookların oynama periyotları doğrultusunda tüm sistemlerde değişiklik otomatik olarak yapılacaktır.  

**NOT :** Tüm sunucularda ilgili playbookun oynatıldığından emin olmadan bir sonraki adıma geçmeyiniz.



####Eski Kullanıcı ve Grup’ un Kaldırılması

* İşlemler başarılı bir şekilde yaptıktan sonra önceden tanımlı olan kullanıcı ve grubun kaldırılması işlemleri yapılır.
* Aşağıda belirtilen dosya içerisinde ki “**revokedgroup**” ve “**revokeduser**” satırlarına kaldırılmak istenen kullanıcı ve grup bilgisi girilir.

```
$ vi /etc/ansible/roles/base/vars/main.yml
revokedgroup:kaldırılacak_grup
revokeduser:kaldırılacak_kullanıcı
group:yeni_grup_adı
```

* Gerekli değişiklikler yapıldıktan sonra, değişikliğin yapılacağı tüm sunucular üzerinde playbook oynaması beklenir. AHTAPOT GDYS Kullanım dokümanı takip edilerek daha önceden crontabta çalışması ayarlanmış olan playbookların oynama periyotları doğrultusunda tüm sistemlerde değişiklik otomatik olarak yapılacaktır. 

**Sayfanın PDF versiyonuna erişmek için [buraya](mys-kullanim.pdf) tıklayınız.**

