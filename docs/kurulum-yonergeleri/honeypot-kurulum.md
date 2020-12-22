
# Balküpü Kurulum Yönergesi

Bu dokümanda, Ahtapot projesi kapsamında balküpü sunucusunun merkezi yönetim sisteminin ihtiyaçlarına cevap verecek şekilde nasıl kurulacağı anlatılmaktadır.

### Balküpü Sistemi Kurulum İşlemleri

* **NOT:** Dökümanda yapılması istenilen değişiklikler gitlab arayüzü yerine terminal üzerinden yapılması durumunda playbook oynatılmadan önce yapılan değişiklikler git'e push edilmelidir.

```
$ cd /etc/ansible
git status komutu ile yapılan değişiklikler gözlemlenir.
$ git status  
$ git add --all
$ git commit -m "yapılan değişiklik commiti yazılır"
$ git push origin master
```

* Gitlab adresine  bir web tarayıcı vasıtası ile girilerek Gitlab web arayüzüne “**https://gitlabsunucuadresi**” ile erişilir. 

* Gitlab arayüzünden mys resposundaki “**hosts**” dosyasında “**[honeypot]**” fonksiyonu altına balküpü sunucusunun FQDN bilgisi girilir.

```
[honeypot]
honeypot.gdys.local
``` 

* Gitlab arayüzünden mys reposundaki  “**roles/base/vars/host.yml**” dosyasına balküpü sunucusunun ip adresi, FQDN bilgisi ve hostname’i yeni bir server bloğu oluşturularak yazılır. 

```
serverN:
        ip: "X.X.X.X"
        fqdn: "honeypot.gdys.local"
        hostname: "honeypot"
```

Ardından balküpü sistemi ile ilgili aşağıda tanımlanmış değişkenler açıklamalarda belirtilen şekilde uygun değerlerle doldurulur.

- **NOT:** Aşağıdaki adıma geçilmeden önce bal küpü container yapısının network tipi kararlaştırılmalıdır. Bu noktada iki seçenek vardır.  
  - "**VETH:**" Bu yapıda lxc honeypot host makinesi üzerinde sanal bir bridge network oluşturarak containerlar için farklı subnette bir network yapısı kurar. Containerlara direk olarak erişilemez. Bunun için honeypot host'u üzerinde nat kuralları girilerek ilgili trafik ilgili honeypot container'ına aktarılır.  
  - "**MACVLAN:**" Bu yapı için honeypot host'u üzerinde minimum 2 adet NIC bulunması gerekmektedir. Birincisi honeypot host sunucusunun MYS ile haberleşmesinde kullanılmak üzere ikincisi ise honeypot containerları için tahsis edilmek üzeredir. Burada Honeypot containerları normal birer host gibi Network içerisine dahil olurlar ve ip alırlar.  
        
- **NOT:** Eğer yapılandırma MACVLAN olacak ise bal küpü sunucusu üzerinde aşağıdaki işlemler yapılmalıdır:  
  - Continerlar için tahsis edilen interface (örn ens224) aşağıdaki komut ile "**up**" konuma getirilmelidir: 
  ``` 
  sudo ip link set dev ens224 up
  ```
  - Daha sonra boot sırasında bu interface'in up duruma gelmesi için "**/etc/network/interfaces**" dosyasına aşağıdaki konfigürasyon eklenmelidir:  
  ```  
  auto ens224   
  iface ens224 inet manual   
  up ip link set ens224 up  
  ```  
        


#### Balküpü Rolü Değişkenleri
Bu roldeki değişkenler “**/etc/ansible/roles/honeypot/vars/**” dizini altında bulunan yml dosyalarında belirtilmiştir. yml dosyalarının içerikleri ve değişken bilgileri aşağıdaki gibidir;

"**main.yml**" dosyasında bulunan değişkenlerin görevi şu şekildedir:  
- "**container_mirror**" değişkeni lxc içine kurulacak pardus container'ı için repo adresinin tanımlandığı değişkendir.
- "**container_security_mirror**" değişkeni lxc içine kurulacak pardus container'ı için güvenlik repo adresinin tanımlandığı değişkendir.
- "**mhn_url**" değişkeni, mhn servisinin hizmet verdiği adresin belirtildiği değişkendir.
- "**mhn_honeymap_url**" değişkeni, mhn honeymap servisinin hizmet verdiği adresin belirtildiği değişkendir.
- "**mhn_deploy_key**" değişkeni mhn sistemine entegre edilecek balküpü sistemler için gerekli olan anahtarın belirtildiği değişkendir. Mhn sisteminin kurulumunun ardından arayüzden bu bilgi alınabilir.  
- "**lxc**" değişkeni altına "/etc/ansible/hosts" dosyasında [honeypot] altına tanımlanan sunucu fqdn adresleri girilir. Bu sayede farklı sunucular için farklı ayarlar yapılma imkanı olur. Her sunucu değişkeni altında da şu değişkenler bulunur:  
- "**network_type**" containerların kullanacağı ağ yapılandırması tipinin girildiği değişkendir. Basit kullanım için "veth" modunun kullanımı tavsiye edilir. Gelişmiş kullanım ve network içindeki doğal dağılım yapısını sağlamak için ise "macvlan" modu tavsiye edilir.
- "**network_link**" containerların erişeceği bridge ağ bacağının ismidir. Eğer;  
  - "network_type" değişkeni "veth" olarak girilmişse => Bu değişken değeri "lxcbr0" olmalıdır. Bu isimle bir bridge arabirim otomatik olarak yaratılacaktır.
  - "network_type" değişkeni "macvlan" olarak girilmişse => Bu değişken değeri yukarıda bahsedildiği üzere containerlar için tahsis edilmiş ağ arabiriminin adı olmalıdır.
- "**network_hwaddr**" containerlar için türetilecek MAC adresinin ilk üç segmentinin belirtildiği değişkendir. Son üç segment xx:xx:xx olarak yazılır.
- "**network_link_bridge_slave**" Eğer;  
  - "network_type" değişkeni "veth" olarak girilmişse => Yaratılacak bridge arabirime bağlanacak ağ arabiriminin adı olmalıdır.
  - "network_type" değişkeni "macvlan" olarak girilmişse => Bu değişken değeri yukarıda bahsedildiği üzere containerlar için tahsis edilmiş ağ arabiriminin adı olmalıdır.  
- "**containers**" değişkeni altına "/etc/ansible/hosts" dosyasında [honeypot] altına tanımlanan sunucu fqdn adresleri girilir. Bu sayede farklı sunucular için farklı ayarlar yapılma imkanı olur. Her sunucu değişkeni altında kurulması istenen balküpü sistemlerinin tanımlarından oluşan bir liste bulunur. Bu sistemlerin tipi şunlardan biri olmak zorundadır: "amun dionaea ftp pop3 smtp wordpot cowrie elastichoney glastopf p0f shockpot suricata conpot"  
- "**type**" değişkeni yukarıda belirtilen balküpü tiplerinden biri olabilir.
- "**start_auto**" değişkeni eğer 1 yapılırsa sunucu yeniden başlatıldığında bu balküpü otomatik olarak başlatılır, 0 yapılırsa başlatılmaz.
- "**start_delay**" değişkeni ile container başlatılmadan önce kaç saniye bekleneceği belirtilir.
- "**start_order**" değişkeni ile container'ın hangi öncelikle başlatılacağı belirtilir. Yüksek sayı yüksek öncelik demektir.
- "**force_register**" değişkeni ile container'ın yeniden MHN'e kayıt olup olmaması belirtilir. Eğer aynı container silinmeden tekrar kayıt edilirse MHN sensör listesinde çift kayıt oluşur. Bu nedenle container mhn arayüzünden silinmediği sürece bu değişkenin false olarak kalması tavsiye edilir.
- "**interfaces**"  değişkeni ile ilgili container'ın ağ arabirimleri ve yapılandırmaları belirtilir.

```
---
container_mirror: http://depo.pardus.org.tr/pardus/
container_security_mirror: http://depo.pardus.org.tr/guvenlik/
mhn_url: http://10.0.3.100 # Asagida tanimlanan mhn containerina ait IP bilgisi
mhn_honeymap_url: http://10.0.3.100:3000 # Mhn containerina ait IP bilgisi
mhn_deploy_key: xlINEePk
lxc_upgrade_minute: 0
lxc_upgrade_hour: 3
lxc:
  pardus.ahtapot:
    network_type: macvlan # veth|macvlan
    network_link: enp0s3 # type veth ise => lxcbr0
    network_hwaddr: 00:16:3e:xx:xx:xx
    network_link_bridge_slave: enp0s3
    rsyslog_type: omfile
    rsyslog_target:
    rsyslog_port:
    rsyslog_tls:
    rsyslog_tls_cacert:
    rsyslog_tls_mycert:
    rsyslog_tls_myprivkey:
    rsyslog_tls_authmode:
    rsyslog_tls_permittedpeer:
containers:
# amun dionaea ftp pop3 smtp wordpot cowrie elastichoney conpot glastopf p0f shockpot suricata
  pardus.ahtapot:
  - type: "mhn"
    start_auto: 1
    start_delay: 0
    start_order: 0
    force_register: true
    interfaces:
    - name: eth0
      type: static
      address: 10.0.3.100
      netmask: 255.255.255.0
      network: 10.0.3.0
      broadcast: 10.0.3.255
      gateway: 10.0.3.1
  - type: "cowrie"
    start_auto: 1
    start_delay: 0
    start_order: 0
    force_register: true
    interfaces:
    - name: eth0
      type: static
      address: 10.0.3.101
      netmask: 255.255.255.0
      network: 10.0.3.0
      broadcast: 10.0.3.255
      gateway: 10.0.3.1
  - type: "dionaea"
    start_auto: 1
    start_delay: 0
    start_order: 0
    force_register: false
    interfaces:
    - name: eth0
      type: static
      address: 10.0.3.102
      netmask: 255.255.255.0
      network: 10.0.3.0
      broadcast: 10.0.3.255
      gateway: 10.0.3.1
  - type: "p0f"
    start_auto: 1
    start_delay: 0
    start_order: 0
    force_register: false 
    interfaces:
    - name: eth0
      type: static
      address: 10.0.3.103
      netmask: 255.255.255.0
      network: 10.0.3.0
      broadcast: 10.0.3.255
      gateway: 10.0.3.1 
  - type: "smtp"
    start_auto: 1
    start_delay: 0
    start_order: 0
    force_register: true
    interfaces:
    - name: eth0
      type: static
      address: 10.0.3.104
      netmask: 255.255.255.0
      network: 10.0.3.0
      broadcast: 10.0.3.255
      gateway: 10.0.3.1
  - type: "glastopf"
    start_auto: 1
    start_delay: 0
    start_order: 0
    force_register: true
    interfaces:
    - name: eth0
      type: static
      address: 10.0.3.105
      netmask: 255.255.255.0
      network: 10.0.3.0
      broadcast: 10.0.3.255
      gateway: 10.0.3.1
  - type: "ftp"
    start_auto: 1
    start_delay: 0
    start_order: 0
    force_register: true
    interfaces:
    - name: eth0
      type: static
      address: 10.0.3.106
      netmask: 255.255.255.0
      network: 10.0.3.0
      broadcast: 10.0.3.255
      gateway: 10.0.3.1
  - type: "pop3"
    start_auto: 1
    start_delay: 0
    start_order: 0
    force_register: true
    interfaces:
    - name: eth0
      type: static
      address: 10.0.3.107
      netmask: 255.255.255.0
      network: 10.0.3.0
      broadcast: 10.0.3.255
      gateway: 10.0.3.1
  - type: "shockpot"
    start_auto: 1
    start_delay: 0
    start_order: 0
    force_register: false
    interfaces:
    - name: eth0
      type: static
      address: 10.0.3.108
      netmask: 255.255.255.0
      network: 10.0.3.0
      broadcast: 10.0.3.255
      gateway: 10.0.3.1
  - type: "wordpot"
    start_auto: 1
    start_delay: 0
    start_order: 0
    force_register: false
    interfaces:
    - name: eth0
      type: static
      address: 10.0.3.109
      netmask: 255.255.255.0
      network: 10.0.3.0
      broadcast: 10.0.3.255
      gateway: 10.0.3.1
  - type: "amun"
    start_auto: 1
    start_delay: 0
    start_order: 0
    force_register: false
    interfaces:
    - name: eth0
      type: static
      address: 10.0.3.110
      netmask: 255.255.255.0
      network: 10.0.3.0
      broadcast: 10.0.3.255
      gateway: 10.0.3.1
  - type: "suricata"
    start_auto: 1
    start_delay: 0
    start_order: 0
    force_register: false
    interfaces:
    - name: eth0
      type: static
      address: 10.0.3.111
      netmask: 255.255.255.0
      network: 10.0.3.0
      broadcast: 10.0.3.255
      gateway: 10.0.3.1
  - type: "elastichoney"
    start_auto: 1
    start_delay: 0
    start_order: 0
    force_register: false
    interfaces:
    - name: eth0
      type: static
      address: 10.0.3.112
      netmask: 255.255.255.0
      network: 10.0.3.0
      broadcast: 10.0.3.255
      gateway: 10.0.3.1
  - type: "conpot"
    start_auto: 1
    start_delay: 0
    start_order: 0
    force_register: false
    interfaces:
    - name: eth0
      type: static
      address: 10.0.3.113
      netmask: 255.255.255.0
      network: 10.0.3.0
      broadcast: 10.0.3.255
      gateway: 10.0.3.1
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
"**listen_ip**" glastopf balküpünün servis vereceği IP ağıdır. "**listen_port**" glastopf balküpünün servis vereceği portu belirtir. "**register_check_file**" glastopf balküpünün Mhn'e başarılı bir şekilde kayıt olduktan sonra oluşturduğu dosyanın yoludur.  

```  
---
glastopf_conf:
  listen_ip: 0.0.0.0
  listen_port: 80
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
- “**conpot.yml**” dosyası ile conpıt balküpü sistemlerinin ortak yapılandırmaları yapılır. Bu dosyada bulunan değişkenler şu şekildedir.  "**register_check_file**" wordpot balküpünün Mhn'e başarılı bir şekilde kayıt olduktan sonra oluşturduğu dosyanın yoludur.  

```  
---
conpot_conf:
  register_check_file: /etc/conpot_registered
```

İlgili değişkenler ayarlandıktan sonra aşağıdaki komut ile balküpü sistemleri kurulur.

```
ansible-playbook /etc/ansible/playbooks/honeypot.yml
```

Honeypot sisteminin ips tarafından engellenmemesi için "**/etc/ansible/roles/ips/vars/main.yml**" dosyasinda bulunan "**suricata_home_net**" ve "**suricata_external_net**" degiskenlerine "**!HONEYPOT_IP_ADDRESS**" seklinde honeypot IP adresi eklenir. Örneğin 192.168.0.4 IP adresine sahip bir sistemi ips dışında tutmak için şu şekilde bir değişiklik yapılır:

```
suricata_home_net: "[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12,!192.168.0.4]"
suricata_external_net: "[!$HOME_NET,!192.168.0.4]"
```

