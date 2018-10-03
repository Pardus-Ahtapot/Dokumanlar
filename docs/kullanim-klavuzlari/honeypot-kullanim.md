
# Balküpü
Ahtapot projesi kapsamında balküpü işlevinin kurulumunu ve yönetimini sağlayan playbook’dur. “**/etc/ansible/playbooks/**” dizini altında bulunan “**honeypot.yml**” dosyasına bakıldığında, “**hosts**” satırında Ansible’a ait “**/etc/ansible/**” altında bulunan “**hosts**” dosyasında “**[honeypot]**” satırı altına yazılmış tüm sunucularda bu playbookun oynatılacağı belirtilir. “**sudo**” satırı ile çalışacak komutların sudo yetkisi ile çalışması belirlenir. “**vars_files**” satırı antispam playbookunun değişken dosyalarını belirtmektedir. “**roles**” satırı altında bulunan satırlarda ise bu playbook çalıştığında “**base**” ve “**honeypot**”rollerinin çalışacağı belirtilmektedir.


```
- hosts: honeypot
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
  - /etc/ansible/roles/honeypot/vars/main.yml
  - /etc/ansible/roles/honeypot/vars/cowrie.yml
  - /etc/ansible/roles/honeypot/vars/dionaea.yml
  - /etc/ansible/roles/honeypot/vars/p0f.yml
  - /etc/ansible/roles/honeypot/vars/smtp.yml
  - /etc/ansible/roles/honeypot/vars/glastopf.yml
  - /etc/ansible/roles/honeypot/vars/pop3.yml
  - /etc/ansible/roles/honeypot/vars/ftp.yml
  - /etc/ansible/roles/honeypot/vars/shockpot.yml
  - /etc/ansible/roles/honeypot/vars/wordpot.yml
  - /etc/ansible/roles/honeypot/vars/amun.yml
  - /etc/ansible/roles/honeypot/vars/suricata.yml
  - /etc/ansible/roles/honeypot/vars/elastichoney.yml

  roles:
    - role: base
    - role: honeypot

```


#### Balküpü Rolü Değişkenleri
Bu roldeki değişkenler “**/etc/ansible/roles/honeypot/vars/**” dizini altında bulunan yml dosyalarında belirtilmiştir. yml dosyalarının içerikleri ve değişken bilgileri aşağıdaki gibidir;

-   “**main.yml**” dosyasında bulunan değişkenlerin görevi şu şekildedir. "**container_mirror**" değişkeni lxc içine kurulacak pardus container'ı için repo adresinin tanımlandığı değişkendir. "**container_security_mirror**" değişkeni lxc içine kurulacak pardus container'ı için güvenlik repo adresinin tanımlandığı değişkendir. "**mhn_url**" değişkeni, mhn servisinin hizmet verdiği adresin belirtildiği değişkendir. "**mhn_deploy_key**" değişkeni mhn sistemine entegre edilecek balküpü sistemler için gerekli olan anahtarın belirtildiği değişkendir. Mhn sisteminin kurulumunun ardından arayüzden bu bilgi alınabilir. 
"**lxc**" değişkeni altına "/etc/ansible/hosts" dosyasında [honeypot] altına tanımlanan sunucu fqdn adresleri girilir. Bu sayede farklı sunucular için farklı ayarlar yapılma imkanı olur. Her sunucu değişkeni altında da şu değişkenler bulunur:
"**network_type**" containerların kullanacağı ağ yapılandırması tipinin girildiği değişkendir. "veth" modunun kullanımı tavsiye edilir.
"**network_link**" containerların erişeceği bridge ağ bacağının ismidir. Bu isimle bir bridge arabirim otomatik olarak yaratılacaktır.
"**network_hwaddr**" containerlar için türetilecek MAC adresinin ilk üç segmentinin belirtildiği değişkendir. Son üç segment xx:xx:xx olarak yazılır.
"**netowrk_link_bridge_slave**" yaratılacak bridge arabirime bağlanacak ağ arabiriminin belirtildiği değişkendir.
"**containers**" değişkeni altına "/etc/ansible/hosts" dosyasında [honeypot] altına tanımlanan sunucu fqdn adresleri girilir. Bu sayede farklı sunucular için farklı ayarlar yapılma imkanı olur. Her sunucu değişkeni altında kurulması istenen balküpü sistemlerinin tanımlarından oluşan bir liste bulunur. Bu sistemlerin tipi şunlardan biri olmak zorundadır: "amun dionaea ftp pop3 smtp wordpot cowrie elastichoney glastopf p0f shockpot suricata"
"**type**" değişkeni yukarıda belirtilen balküpü tiplerinden biri olabilir.
"**start_auto**" değişkeni eğer 1 yapılırsa sunucu yeniden başlatıldığında bu balküpü otomatik olarak başlatılır, 0 yapılırsa başlatılmaz.
"**start_delay**" değişkeni ile container başlatılmadan önce kaç saniye bekleneceği belirtilir.
"**start_order**" değişkeni ile container'ın hangi öncelikle başlatılacağı belirtilir. Yüksek sayı yüksek öncelik demektir.
"**force_register**" değişkeni ile container'ın yeniden MHN'e kayıt olup olmaması belirtilir. Eğer aynı container silinmeden tekrar kayıt edilirse MHN sensör listesinde çift kayıt oluşur. Bu nedenle container mhn arayüzünden silinmediği sürece bu değişkenin false olarak kalması tavsiye edilir.
"**interfaces**"  değişkeni ile ilgili container'ın ağ arabirimleri ve yapılandırmaları belirtilir.

```
---
container_mirror: http://depo.pardus.org.tr/pardus/
container_security_mirror: http://depo.pardus.org.tr/guvenlik/
mhn_url: http://169.254.1.9
mhn_deploy_key: r0SwHB9N
lxc:
  pardus.ahtapot:
    network_type: veth # veth|macvlan
    network_link: br0
    network_hwaddr: 00:16:3e:xx:xx:xx
    netowrk_link_bridge_slave: enp0s3
containers:
# amun dionaea ftp pop3 smtp wordpot cowrie elastichoney glastopf p0f shockpot suricata
  pardus.ahtapot:
  - type: "cowrie"
    start_auto: 1
    start_delay: 0
    start_order: 0
    force_register: true
    interfaces:
    - name: eth0
      type: static
      address: 169.254.1.101
      netmask: 255.255.255.0
      network: 169.254.1.0
      broadcast: 169.254.1.255
      gateway: 169.254.1.9
  - type: "dionaea"
    start_auto: 1
    start_delay: 0
    start_order: 0
    force_register: false
    interfaces:
    - name: eth0
      type: static
      address: 169.254.1.102
      netmask: 255.255.255.0
      network: 169.254.1.0
      broadcast: 169.254.1.255
      gateway: 169.254.1.9
  - type: "p0f"
    start_auto: 1
    start_delay: 0
    start_order: 0
    force_register: false 
    interfaces:
    - name: eth0
      type: static
      address: 169.254.1.103
      netmask: 255.255.255.0
      network: 169.254.1.0
      broadcast: 169.254.1.255
      gateway: 169.254.1.9 
  - type: "smtp"
    start_auto: 1
    start_delay: 0
    start_order: 0
    force_register: true
    interfaces:
    - name: eth0
      type: static
      address: 169.254.1.104
      netmask: 255.255.255.0
      network: 169.254.1.0
      broadcast: 169.254.1.255
      gateway: 169.254.1.9
  - type: "glastopf"
    start_auto: 1
    start_delay: 0
    start_order: 0
    force_register: true
    interfaces:
    - name: eth0
      type: static
      address: 169.254.1.105
      netmask: 255.255.255.0
      network: 169.254.1.0
      broadcast: 169.254.1.255
      gateway: 169.254.1.9
  - type: "ftp"
    start_auto: 1
    start_delay: 0
    start_order: 0
    force_register: true
    interfaces:
    - name: eth0
      type: static
      address: 169.254.1.106
      netmask: 255.255.255.0
      network: 169.254.1.0
      broadcast: 169.254.1.255
      gateway: 169.254.1.9
  - type: "pop3"
    start_auto: 1
    start_delay: 0
    start_order: 0
    force_register: true
    interfaces:
    - name: eth0
      type: static
      address: 169.254.1.107
      netmask: 255.255.255.0
      network: 169.254.1.0
      broadcast: 169.254.1.255
      gateway: 169.254.1.9
  - type: "shockpot"
    start_auto: 1
    start_delay: 0
    start_order: 0
    force_register: false
    interfaces:
    - name: eth0
      type: static
      address: 169.254.1.108
      netmask: 255.255.255.0
      network: 169.254.1.0
      broadcast: 169.254.1.255
      gateway: 169.254.1.9
  - type: "wordpot"
    start_auto: 1
    start_delay: 0
    start_order: 0
    force_register: false
    interfaces:
    - name: eth0
      type: static
      address: 169.254.1.109
      netmask: 255.255.255.0
      network: 169.254.1.0
      broadcast: 169.254.1.255
      gateway: 169.254.1.9
  - type: "amun"
    start_auto: 1
    start_delay: 0
    start_order: 0
    force_register: false
    interfaces:
    - name: eth0
      type: static
      address: 169.254.1.110
      netmask: 255.255.255.0
      network: 169.254.1.0
      broadcast: 169.254.1.255
      gateway: 169.254.1.9
  - type: "suricata"
    start_auto: 1
    start_delay: 0
    start_order: 0
    force_register: false
    interfaces:
    - name: eth0
      type: static
      address: 169.254.1.111
      netmask: 255.255.255.0
      network: 169.254.1.0
      broadcast: 169.254.1.255
      gateway: 169.254.1.9
  - type: "elastichoney"
    start_auto: 1
    start_delay: 0
    start_order: 0
    force_register: false
    interfaces:
    - name: eth0
      type: static
      address: 169.254.1.112
      netmask: 255.255.255.0
      network: 169.254.1.0
      broadcast: 169.254.1.255
      gateway: 169.254.1.9

```

-   “**cowrie.yml**” dosyası ile cowrie balküpü sistemlerinin ortak yapılandırmaları yapılır. Bu dosyada bulunan değişkenler şu şekildedir.
"**cowrie_hostname**" değişkeni cowrie balküpü sisteminin hostname'inin belirtildiği değişkendir.  "**cowrie_enable_ssh**" değişkeni cowrie balküpü sisteminin ssh tuzak sisteminin aktif olup olmamasının belirtildiği değişkendir. "**cowrie_real_ssh_port**" cowrie balküpü sistemine erişip yönetebilmek için kullanılacak port tanımının yapıldığı değişkendir.   "**cowrie_ssh_port**" değişkeni, cowrie balküpü sisteminde tuzak ssh sunucusunun hizmet vereceği portun belirtildiği değişkendir. "**cowrie_ssh_version**" tuzak ssh sisteminin taklit edeceği ssh sürümünün belirtildiği değişkendir.  "**cowrie_enable_telnet**" değişkeni cowrie balküpü sisteminin telnet tuzak sisteminin aktif olup olmamasının belirtildiği değişkendir. "**cowrie_telnet_port**" değişkeni, cowrie balküpü sisteminde tuzak telnet sunucusunun hizmet vereceği portun belirtildiği değişkendir. "**cowrie_register_check_file**" cowrie balküpünün Mhn'e başarılı bir şekilde kayıt olduktan sonra oluşturduğu dosyanın yoludur.
```
---
cowrie_hostname: cowrie
cowrie_enable_ssh: true
cowrie_real_ssh_port: 2222
cowrie_ssh_port: 22
cowrie_ssh_version: SSH-2.0-OpenSSH_6.7p1 Ubuntu-5ubuntu1.3
cowrie_enable_telnet: true
cowrie_telnet_port: 2223
cowrie_register_check_file: /etc/cowrie_registered
```

-   “**ftp.yml**” dosyası ile ftp balküpü sistemlerinin ortak yapılandırmaları yapılır. Bu dosyada bulunan değişkenler şu şekildedir.
"**honeypot_ftp_pubdir**" tuzak ftp sunucusunun çalışacağı dosya yoludur. "**honeypot_ftp_passwdfile**" tuzak ftp sunucusunun şifre dosyasıdır. "**honeypot_ftp_filename**" tuzak ftp sunucusunun oluşturduğu kayıtların yazıldığı dosyadır. "**honeypot_ftp_port**" tuzak ftp sunucusunun hizmet vereceği porttur. "**honeypot_ftp_sslport**" tuzak ftp sunucusunun ssl üzerinden hizmet vereceği porttur. "**honeypot_ftp_sslcertprivate**" tuzak ftp sunucusu için kullanılacak gizli anahtarın bulunduğu dosya yoludur. "**honeypot_ftp_sslcertpublic**" tuzak ftp sunucusu için kullanılacak açık anahtarın bulunduğu dosya yoludur. "**honeypot_ftp_create_ssl**" ile ssl sertifikasının yaratılıp yaratılmayacağı belirtilir. Eğer "True" yapılırsa self-signed bir sertifika otomatik olarak oluşturulur. Eğer "False" yapılırsa yukarıda belirtilen dosya yollarına setifikaların kopyalanması gerekir. "**honeypot_ftp_ssl_**" ile başlayan değişkenler, balküpü sistemi üzerinde oluşturulacak ssl anahtarı ile ilgili bilgilerin ayarlandığı değişkenlerdir.
```
---
honeypot_ftp_pubdir: /var/tmp/honeypot-ftp-pub/
honeypot_ftp_passwdfile: /etc/honeypot-ftp/ftp_user_pass
honeypot_ftp_sslcertprivate: /etc/honeypot-ftp/keys/ftpd.key
honeypot_ftp_sslcertpublic: /etc/honeypot-ftp/keys/ftpd.crt
honeypot_ftp_filename: /var/log/honeypot_ftp.log
honeypot_ftp_sslport: 990
honeypot_ftp_port: 21
honeypot_ftp_create_ssl: True
honeypot_ftp_ssl_country: "TR"
honeypot_ftp_ssl_state: "Ankara"
honeypot_ftp_ssl_locality: "Ankara"
honeypot_ftp_ssl_organization: "organizasyon_adi"
honeypot_ftp_ssl_organizationalunit: "organizasyon_birimi"
honeypot_ftp_ssl_commonname: "alan_adi"
```
-   “**smtp.yml**” dosyası ile smtp balküpü sistemlerinin ortak yapılandırmaları yapılır. Bu dosyada bulunan değişkenler şu şekildedir.
 "**honeypot_smtp_hostname**" değişkeni tuzak smtp sisteminin hostname'inin belirtildiği değişkendir.  "**honeypot_smtp_domain**" değişkeni tuzak smtp sisteminin alan adının belirtildiği değişkendir. "**honeypot_smtp_filename**" tuzak smtp sunucusunun oluşturduğu kayıtların yazıldığı dosyadır. "**honeypot_smtp_port**" tuzak smtp sunucusunun hizmet vereceği porttur. "**honeypot_smtp_sslport**" tuzak smtp sunucusunun ssl üzerinden hizmet vereceği porttur. "**honeypot_smtp_sslcertprivate**" tuzak smtp sunucusu için kullanılacak gizli anahtarın bulunduğu dosya yoludur. "**honeypot_smtp_sslcertpublic**" tuzak smtp sunucusu için kullanılacak açık anahtarın bulunduğu dosya yoludur. "**honeypot_smtp_create_ssl**" ile ssl sertifikasının yaratılıp yaratılmayacağı belirtilir. Eğer "True" yapılırsa self-signed bir sertifika otomatik olarak oluşturulur. Eğer "False" yapılırsa yukarıda belirtilen dosya yollarına setifikaların kopyalanması gerekir. "**honeypot_smtp_ssl_**" ile başlayan değişkenler, balküpü sistemi üzerinde oluşturulacak ssl anahtarı ile ilgili bilgilerin ayarlandığı değişkenlerdir.
```
---
honeypot_smtp_hostname: smtp
honeypot_smtp_domain: example.com
honeypot_smtp_sslcertprivate: /etc/honeypot-smtp/keys/smtpd.key
honeypot_smtp_sslcertpublic: /etc/honeypot-smtp/keys/smtpd.crt
honeypot_smtp_filename: /var/log/honeypot_smtp.log
honeypot_smtp_sslport: 465
honeypot_smtp_port: 25
honeypot_smtp_create_ssl: True
honeypot_smtp_ssl_country: "TR"
honeypot_smtp_ssl_state: "Ankara"
honeypot_smtp_ssl_locality: "Ankara"
honeypot_smtp_ssl_organization: "organizasyon_adi"
honeypot_smtp_ssl_organizationalunit: "organizasyon_birimi"
honeypot_smtp_ssl_commonname: "alan_adi"
```
-   “**pop3.yml**” dosyası ile pop3 balküpü sistemlerinin ortak yapılandırmaları yapılır. Bu dosyada bulunan değişkenler şu şekildedir.
 "**honeypot_pop3_hostname**" değişkeni tuzak pop3 sisteminin hostname'inin belirtildiği değişkendir.  "**honeypot_pop3_domain**" değişkeni tuzak pop3 sisteminin alan adının belirtildiği değişkendir.  "**honeypot_pop3_maildir**" tuzak pop3 sunucusu tarafından alınan e-postaların kayıt edildiği dizindir. "**honeypot_pop3_filename**" tuzak pop3 sunucusunun oluşturduğu kayıtların yazıldığı dosyadır. "**honeypot_pop3_port**" tuzak pop3 sunucusunun hizmet vereceği porttur. "**honeypot_pop3_sslport**" tuzak pop3 sunucusunun ssl üzerinden hizmet vereceği porttur. "**honeypot_pop3_sslcertprivate**" tuzak pop3 sunucusu için kullanılacak gizli anahtarın bulunduğu dosya yoludur. "**honeypot_pop3_sslcertpublic**" tuzak pop3 sunucusu için kullanılacak açık anahtarın bulunduğu dosya yoludur. "**honeypot_pop3_create_ssl**" ile ssl sertifikasının yaratılıp yaratılmayacağı belirtilir. Eğer "True" yapılırsa self-signed bir sertifika otomatik olarak oluşturulur. Eğer "False" yapılırsa yukarıda belirtilen dosya yollarına setifikaların kopyalanması gerekir. "**honeypot_pop3_ssl_**" ile başlayan değişkenler, balküpü sistemi üzerinde oluşturulacak ssl anahtarı ile ilgili bilgilerin ayarlandığı değişkenlerdir.
```
---
honeypot_pop3_hostname: pop3
honeypot_pop3_domain: example.com
honeypot_pop3_maildir: /var/depo/mail/
honeypot_pop3_sslcertprivate: /etc/honeypot-pop3/keys/pop3d.key
honeypot_pop3_sslcertpublic: /etc/honeypot-pop3/keys/pop3d.crt
honeypot_pop3_filename: /var/log/honeypot_pop3.log
honeypot_pop3_sslport: 465
honeypot_pop3_port: 25
honeypot_pop3_create_ssl: True
honeypot_pop3_ssl_country: "TR"
honeypot_pop3_ssl_state: "Ankara"
honeypot_pop3_ssl_locality: "Ankara"
honeypot_pop3_ssl_organization: "organizasyon_adi"
honeypot_pop3_ssl_organizationalunit: "organizasyon_birimi"
honeypot_pop3_ssl_commonname: "alan_adi"
```
-   “**elastichoney.yml**” dosyası ile elasticsearch balküpü sistemlerinin ortak yapılandırmaları yapılır. Bu dosyada bulunan değişkenler şu şekildedir.
"**elastichoney_logfile**" tuzak elasticsearch sunucusunun oluşturduğu kayıtların yazıldığı dosyadır. "**elastichoney_use_remote**" değişkeni ile uzak bir sunucuya HTTP POST ile logları aktarıp aktarmayacağımız ayarlanıyor. Eğer true yapılırsa bu sunucunun bilgileri şu değişkenlere yazılmalı. "**elastichoney_remote_url**" log aktarılacak uzak sunucunun URL bilgisi. "**elastichoney_remote_url_use_auth**" log aktarılacak uzak sunucuda kimlik doğrulaması yapılacaksa bu değişken true edilmeli ve kimlik bilgileri ayarlanmalıdır aksi durumda false yapılmalıdır. "**elastichoney_remote_url_username**" log aktarılacak uzak sunucuda kimlik doğrulaması için kullanılacak kullanıcı adı. "**elastichoney_remote_url_password**" log aktarılacak uzak sunucuda kimlik doğrulaması için kullanılacak şifre. "**elastichoney_anonymous**" oluşan kayıtlarda dış IP adresinin bulunup bulunmayacağının belirtildiği değişkendir. Eğer true yapılırsa sistem belirlenen adrese bir istek atıp dış IP adresini öğrenmeye çalışır. "**elastichoney_public_ip_url**" dış IP adresi öğrenilmek istenildiğinde bağlanılacak sunucunun adresidir. "**elastichoney_spoofed_version**" tuzak sistemin taklit edeceği elasticsearch sürümünün belirtildiği değişkendir. "**elastichoney_register_check_file**" elastichoney balküpünün Mhn'e başarılı bir şekilde kayıt olduktan sonra oluşturduğu dosyanın yoludur.
```
---
elastichoney_logfile: "/var/log/elastichoney/elastichoney.log"
elastichoney_use_remote: "false"
elastichoney_remote_url: "http://example.com"
elastichoney_remote_url_use_auth: "false"
elastichoney_remote_url_username: "user"
elastichoney_remote_url_password: "pass"
elastichoney_anonymous: "true"
elastichoney_spoofed_version: "1.4.1"
elastichoney_public_ip_url: "http://ip1.dynupdate.no-ip.com/"
elastichoney_register_check_file: "/etc/elastichoney_registered"
```

- “**amun.yml**” dosyası ile amun balküpü sistemlerinin ortak yapılandırmaları yapılır. Bu dosyada bulunan değişkenler şu şekildedir.  
"**listen_ip**" değişkeni amun balküpü sisteminin dinleyeceği IP networküdür. "**register_check_file**" amun balküpünün Mhn'e başarılı bir şekilde kayıt olduktan sonra oluşturduğu dosyanın yoludur.  
```  
---  
amun_conf:
  register_check_file: /etc/amun_registered
  listen_ip: 0.0.0.0

```

- “**dionaea.yml**” dosyası ile dionaea balküpü sistemlerinin ortak yapılandırmaları yapılır. Bu dosyada bulunan değişkenler şu şekildedir.  
"**http_port**" değişkeni dionaea balküpünün hizmet vereceği http portudur. "**https_port**" değişkeni dionaea balküpünün hizmet vereceği https portudur. "**root_path**" değişkeni http sunucunun dosyaları hangi klasorden servis ediceğini belirtir"**max_request_size**" bir istek için maksimum boyuttur. "**register_check_file**" dionaea balküpünün Mhn'e başarılı bir şekilde kayıt olduktan sonra oluşturduğu dosyanın yoludur.  

```  
---
dionaea_conf:
  http_port: 80
  https_port: 443
  root_path: /opt/dionaea/var/dionaea/roots/www
  max_request_size: 32768
  register_check_file: /etc/dionaea_registered 
```

- “**glastopf.yml**” dosyası ile glastopf balküpü sistemlerinin ortak yapılandırmaları yapılır. Bu dosyada bulunan değişkenler şu şekildedir.  
"**register_check_file**" glastopf balküpünün Mhn'e başarılı bir şekilde kayıt olduktan sonra oluşturduğu dosyanın yoludur.  

```  
---
glastopf_conf:
  register_check_file: /etc/glastopf_registered

```

- “**p0f.yml**” dosyası ile p0f balküpü sistemlerinin ortak yapılandırmaları yapılır. Bu dosyada bulunan değişkenler şu şekildedir.  
"**listen_interface**" p0f balküpünün trafiğini izleyeceği arayüzü belirtir. "**register_check_file**" p0f balküpünün Mhn'e başarılı bir şekilde kayıt olduktan sonra oluşturduğu dosyanın yoludur.  

```  
---
p0f_conf:
  listen_interface: eth0
  register_check_file: /etc/p0f_registered
```

- “**suricata.yml**” dosyası ile suricata balküpü sistemlerinin ortak yapılandırmaları yapılır. Bu dosyada bulunan değişkenler şu şekildedir.  
"**home_net**" suricata nın kullandığı imzalarda tanımlanan ağdır. Bu ağa gelen paketler incelenir. "**register_check_file**" suricata balküpünün Mhn'e başarılı bir şekilde kayıt olduktan sonra oluşturduğu dosyanın yoludur.  

```  
---
suricata_conf:
  register_check_file: /etc/suricata_registered
  home_net: "[169.254.1.0/24,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"
```

- “**wordpot.yml**” dosyası ile wordpot balküpü sistemlerinin ortak yapılandırmaları yapılır. Bu dosyada bulunan değişkenler şu şekildedir.  
"**listen_ip**" wordpot balküpünün servis vereceği IP ağıdır. "**listen_port**" wordpot balküpünün servis vereceği portu belirtir. "**register_check_file**" wordpot balküpünün Mhn'e başarılı bir şekilde kayıt olduktan sonra oluşturduğu dosyanın yoludur.  

```  
---
wordpot_conf:
  register_check_file: /etc/wordpot_registered
  listen_ip: 0.0.0.0
  listen_port: 80
```

İlgili değişkenler ayarlandıktan sonra aşağıdaki komut ile balküpü sistemleri yapılandırılır.

```
ansible-playbook /etc/ansible/playbooks/honeypot.yml
```


