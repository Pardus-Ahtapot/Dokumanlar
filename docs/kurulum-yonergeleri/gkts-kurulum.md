![ULAKBIM](../img/ulakbim.jpg)
# Geçici Kural Tanımlama Sistemi Kurulum Yönergesi
------

[TOC]

Bu dokümanda, Ahtapot bütünleşik güvenlik yönetim sisteminde kullanılan Geçici Kural Tanımlama Sistemi (Port Knocking) Kurulumu ve Kullanımı anlatılıyor.

Ahtapot GKTS uygulaması önceden IP adresi belirlenmiş bir bilgisayarın, güvenlik duvarları arkasında bulunan ve IP adresi bilinen servislere zaman kısıtlı erişim sağlamak işlemini gerçekleştirir. Bu işlemler onay gerektirmeden gerçekleşir.

####Kurulum İşlemleri

* **NOT:** Dökümanda yapılması istenilen değişiklikler gitlab arayüzü yerine terminal üzerinden yapılması durumunda playbook oynatılmadan önce yapılan değişiklikler git'e push edilmelidir.

```
$ cd /etc/ansible
git status komutu ile yapılan değişiklikler gözlemlenir.
$ git status  
$ git add --all
$ git commit -m "yapılan değişiklik commiti yazılır"
$ git push origin master
```
**NOT:** Kurulacak sistem, SIEM yapısına dahil edilmek isteniyorsa, kurulum sonrasında Siber Olay, Açıklık, Risk İzleme ve Yönetim Sistemi Kurulumu sayfasında bulunan [LMYS Clientlarında Ossec Agent Dağıtımı](siem-kurulum.md) başlığı incelenmelidir.

* Pardus Temel ISO dosyasından Pardus kurulumu tamamlandıktan sonra sisteme “**ahtapotops**” kullanıcısı ile giriş yapılır. ahtapotops kullanıcısının parolası “**LA123!!**” olarak öntanımlıdır.

**NOT :** Pardus Temel ISO dosyasından Pardus kurulumu adımları için “**AHTAPOT Pardus Temel ISO Kurulumu**” dokümanına bakınız.

* Sisteme giriş sağlandıktan sonra, aşağıdaki komut ile root kullanıcısına geçiş yapılır. root kullanıcısı için parola Pardus Temel ISO kurulumu sırasında belirlenmiş paroladır.

```
$ sudo su -
```

* Sisteme root kullanıcısı ile bağlantı sağlandıktan sonra aşağıdaki komut ile ansible ve git kurulumları yapılır:

```
# apt-get install -y ansible
# apt-get install -y git
```

* Bu adımda kurulum, sıkılaştırma vb. gibi işleri otomatize etmeyi sağlayan ansible playbook’ları Pardus Ahtapot deposundan indirilir. 

```
# apt-get install -y ahtapot-mys
# cp -rf /ahtapotmys/* /etc/ansible/
```

* Ahtapot projesi kapsamında oluşacak tüm loglar “**/var/log/ahtapot/**” dizinine yazılmaktadır. Bu dizinin sahipliğini “**ahtapotops**” kullanıcısına vermek için aşağıdaki komut çalıştırılır.

```
# chown ahtapotops:ahtapotops -R /var/log/ahtapot
```

* Tercih ettiğimiz metin düzenleyicisini kullanarak hosts dosyasını düzenliyoruz. Aşağıdaki örnekte vi kullanılır. Açılan dosyada "**[gkts]**" kısmı altına gitlab makinasının tam ismi (FQDN) girilir.

```
# su - ahtapotops 
$ cd /etc/ansible/
$ sudo vi hosts
[gkts]
gkts.alan.adi
```
* “**roles/base/vars**” klasörü altında ntp değişkenlerinin barındıran “**ntp.yml**” dosyası içerisine "**base_ntp_servers**" fonksiyonu altında bulunan "**server1**" ve "**server2**" satırları altına NTP sunucularının FQDN bilgileri girilmelidir. Sistemde bir NTP sunucusu olduğu durumda "**server2**" satırları silinebilir yada istenildiği kadar NTP sunucusu eklenebilir. 

```
$ cd roles/base/vars/
$ sudo vi ntp.yml
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
        fqdn: "rsyslog01.gdys.local"
    server2:
        fqdn: "rsyslog02.gdys.local"
#    serverX:
#        fqdn: ""
```

* "**roles/base/vars**” klasörü altında rsyslog değişkenlerinin barındıran “**rsyslog.yml**” dosyası içerisine "**base_rsyslog_servers**" fonksiyonu altında bulunan “**server1**” ve “**server2**” satırları altına rsyslog sunucularına ait bilgiler girilmelidir. Sistemde bir rsyslog sunucusu olduğu durumda “**server2**” satırları silinebilir yada istenildiği kadar rsyslog sunucusu eklenebilir. 

```
$ cd roles/base/vars/
$ sudo vi rsyslog.yml
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

* "**roles/base/vars**” klasörü altında ssh değişkenlerinin barındıran “**ssh.yml**” dosyası içerisinde bulunan "**Port**" değişkenine istenen yeni değer yazılmalıdır.

```
$ cd roles/base/vars/
$ sudo vi ssh.yml
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
    Port: "4444" 
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

* “**roles/gkts/vars/**” klasörü altında değişkenleri barındıran “**gkts.yml**” dosyası üzerinde “**hook**” fonksiyonu altında bulunan “**server**” değişkenine Merkezi Yönetim Sisteminde bulunan ansible makinasının FQDN bilgisi, “**port**” değişkenine ansible makinesine ssh bağlantısı için kullanılcak ssh port bilgisi yazılır. 

```
# GKTS'in degiskenlerini iceren dosyadir
gkts:
# gkts playbooku ile kurulacak paketleri belirtmektedir.
    hook:
        conf:
            source: gktshook.sh.j2
            destination: /var/opt/ahtapot-gkts/gktshook.sh
            owner: ahtapotops
            group: ahtapotops
            mode: 755
        server: ansible01.gdys.local
        port: 4444

```

* "**roles/gkts/vars/**" dizini altında bulunan "**nginx.yml**" dosyası içerisine “**nginx**” fonksiyonunun alt fonksinyonu olan “**admin**” altında bulunan “**server_name**” değişkenine admin arayüzü için ayarlanması istenen url adres bilgisi yazılır (Örn: admin.gkts.local).  Yönetici arayüzüne erişim için internet tarayıcısında bu adres kullanılacaktır. “**nginx**” fonksiyonunun alt fonksinyonu olan “**developer**” altında bulunan “**server_name**” değişkenine admin arayüzü için ayarlanması istenen domain adres bilgisi yazılır(Örn: kullanici.gkts.local). Kullanıcı arayüzüne erişim için internet tarayıcısında bu adres kullanılacaktır. 

```
# Nginx'in degiskenlerini iceren dosyadir
nginx:
    conf:
        source: "gkts.conf.j2" 
        destination: "/etc/nginx/conf.d/gkts.conf" 
        owner: "root"
        group: "root" 
        mode: "0644" 
    admin:
        listen: "443" 
        server_name: "admin_url_adresi" 
        access_log: "/var/log/nginx/gkts-admin-access.log"
        error_log: "/var/log/nginx/gkts-admin-error.log"
    developer:
        listen: "443" 
        server_name: "kullanici_url_adresi" 
        access_log: "/var/log/nginx/gkts-developer-access.log"
        error_log: "/var/log/nginx/gkts-developer-error.log"
    service:
        name: "nginx" 
        state: "started" 
        enabled: "yes" 
    default:
        path: "/etc/nginx/sites-available/default"
        state: "absent"
    certificate:
        source: "gkts.crt.j2"
        destination: "/etc/nginx/ssl/gkts.crt"
        owner: "root"
        group: "root"
        mode: "0644"
    key:
        source: "gkts.key.j2"
        destination: "/etc/nginx/ssl/gkts.key"
        owner: "root"
        group: "root"
        mode: "0644"
    ssldir:
        path: "/etc/nginx/ssl"
        owner: "root"
        group: "root"
        mode: "755"
        state: "directory"
```

* “**Ansible Playbookları**” dokümanında detaylı anlatımı bulunan, sunucu üzerinde gerekli sıkılaştırma işlemleri ve GKTS kurulumu yapacak olan “**gkts.yml**” playbook’u çalıştırılır.

```
$ ansible-playbook playbooks/gkts.yml --connection=local --skip-tags=hook
```

* GKTS kurulumu tamamlandıktan sonra sunucu MYS ile yönetileceğinden, sunucu üzerindeki ansible paketi kaldırılır.

```
# dpkg -r ansible
```

* GKTS kurulumu tamamlanmış olacak ve kullanıcı tanımlama, depo oluşturma gibi yapılandırma işlemleri için hazır hale gelmiş olacaktır.

**Sayfanın PDF versiyonuna erişmek için [buraya](gkts-kurulum.pdf) tıklayınız.**
