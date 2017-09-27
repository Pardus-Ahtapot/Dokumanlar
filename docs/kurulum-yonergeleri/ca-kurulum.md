![ULAKBIM](../img/ulakbim.jpg)
# CA Kurulumu ve Anahtar Yönetimi
------

[TOC]

------

Bu dokümanda, Ahtapot bütünleşik güvenlik yönetim sisteminde kullanılan SSH anahtarlarını yöneten CA (Certificate Authority) sisteminin kurulması ve anahtar imzalama prosedürü anlatılmaktadır.

Gereken : 
Pardus Temel ISO’ dan kurulumu tamamlanmış bir sunucu.

####Önemli Uyarılar
  1. Kurulacak sunucu, PKI (Public Key Infrastructure) yapısının omurgasını teşkil edeceğinden yüksek düzeyli korunacak sistemler arasında yer almalıdır.
  2. Pardus Temel ISO ile birlikte, lab ve demo ortamlarında kurulumu kolaylaştırmak için sisteme ilk erişimi sağlamak üzere kurulumla birlikte bir CA (ahtapot.ca) dosyası dağıtılıyor. Canlı sistemde kullanılacak CA dosyası, canlı ortamın kurulumunda bu dokümanda tarif edilen yöntemlerle oluşturulmalı ve ilk adımlarla birlikte geçici ve güvensiz olan dosyanın yerine yerleştirilmeli.


####CA Temel Anahtarı Oluşturma

**UYARI :** Aşağıdaki adımların çalıştırılacağı sistem "**Ahtapot CA Sunucusu**" olmalıdır.

  * Pardus Temel ISO’ dan Pardus kurulumu tamamlandıktan sonra sistemde tanımlı bir kullanıcı ile (tercihen root) Ahtapot CA olacak sunucu sistemine bağlantı sağlanır. ssh-keygen kullanılarak standart bir SSH anahtarı oluşturulur. Bu anahtar dosya ismi olarak "**ahpapot_ca**" ön eki ile oluşturulur. SSH anahtarı oluşturulurken kullanılan şifrenin özenle saklanması gerekmektedir.

``` 
ahtapotops@ahtapot:~/ahtapot/lab> ssh-keygen -f ahtapot_ca
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in ahtapot_ca.
Your public key has been saved in ahtapot_ca.pub.
The key fingerprint is:
ad:78:1c:b3:32:09:0d:d0:4e:3a:37:8a:fd:81:73:fd [MD5] ahtapotops@lab.ahtapot.com
The key's randomart image is:
+--[ RSA 2048]----+
|  ..             |
|   .o            |
|   +.            |
|  o +o   .       |
| o =.o. S .      |
|. = o..+ =       |
|   + .=.=        |
|    .  +E        |
|                 |
+--[MD5]+
```


  * Yukarıdaki adım ile 2 adet dosya oluşturulur.  Bu dosyalardan "**ahtapot_ca**" özenle korunması gereken gizli anahtar (Private Key), "**ahtapot_ca.pub**" dosyası ise her yere dağıtılabilen açık anahtar (Public Key) olarak kaydedilir.

```

ahtapotops@ahtapot:~/ahtapot/lab> ls -al
total 8
drwxr-xr-x 1 ahtapotops users   52 Oct 29 10:44 .
drwxr-xr-x 1 ahtapotops users  274 Oct 29 10:34 ..
-r- 1 ahtapotops users 1766 Oct 29 10:44 ahtapot_ca
-rw-r--r-- 1 ahtapotops users  405 Oct 29 10:44 ahtapot_ca.pub
```


####İmzalanacak Kullanıcı Anahtarı Oluşturma

**UYARI :** Aşağıdaki adımların çalıştırılacağı sistem "**Ahtapot Ansible Merkezi Yönetim Sistemi**" olmalıdır.

  * Ahtapot sistemi adına tüm yönetimi gerçekleştirecek olan kullanıcı için, yönetimi gerçekleştirilecek olan sunucuda tamamen aynı şekilde başka bir anahtar oluşturulur. Bu anahtar otomatik sistemlerle kullanılacağından ötürü şifre verilmeden oluşturulmalıdır.

```

ahtapotops@ahtapot:~/ahtapot/lab> ssh-keygen -f kaptan
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in kaptan.
Your public key has been saved in kaptan.pub.
The key fingerprint is:
51:5c:40:e8:6e:3d:b4:6d:8f:49:7f:b3:ad:de:51:d6 [MD5] ahtapotops@lab.ahtapot.com
The key's randomart image is:
+--[ RSA 2048]----+
|         ++o.    |
|        ...      |
|       ..        |
|        ...     .|
|       .So o    E|
|        o + +  ..|
|       .   + = . |
|            o oo+|
|             .o+=|
+--[MD5]+

```

  * Yukarıdaki adım ile 2 adet dosya oluşturulur.  Bu dosyalardan "**kaptan**" özenle korunması gereken gizli anahtar (Private Key), "**kaptan.pub**" dosyası ise her yere dağıtılabilen açık anahtar (Public Key) olarak kaydedilir.

```

ahtapotops@ahtapot::~/ahtapot/test> ls -al
total 16
drwxr-xr-x 1 ahtapotops users   84 Oct 29 10:45 .
drwxr-xr-x 1 ahtapotops users  274 Oct 29 10:34 ..
-r- 1 ahtapotops users 1766 Oct 29 10:45 kaptan
-rw-r--r-- 1 ahtapotops users  405 Oct 29 10:45 kaptan.pub
```

  * Yukarıda hazırlanılan "**kaptan.pub**" anahtar dosyası korunması gerekmez, yerel ağda rahatlıkla kopyalanabilir durumdadır. Öte yandan gizli anahtar olan "**kaptan**" dosyası oluşturulduğu makinadan hiç bir şekilde dışarıya **çıkarılmaması** gerekir. Rahatlıkla kopyalanabilecek olan "**kaptan.pub**" dosyasını Ahtapot CA ve ya USB ve ya network üzerinden SCP ile kopyalanabilir. Önerilen yöntem Ahtapot CA makinasının yalıtılmış (AIR GAP) bir sunucu şeklinde korunması olacağından dolayı imzalanması gereken anahtarların USB gibi bir taşıma yöntemiyle  Ahtapot CA sunucusuna getirilmesi gerekir.


**NOT :** Bu yöntem kullanılarak aşağıdaki kullanıcı listesi için farklı anahtarlar oluşturulmalıdır.

        * ahtapotops
        * git
        * myshook
        * gdyshook



####CA Anahtarı ile Kullanıcı Anahtarı İmzalama 

**UYARI :** Aşağıdaki adımların çalıştırılacağı sistem "**Ahtapot CA**" sunucusudur.

  * Kullanıcı anahtarının Ahtapot CA sunucusunda imzalama anahtarıyla aynı dizine taşınmasından sonra şu şekilde imzalama işlemi gerçekleştirilir.

```
ahtapotops@ahtapot:~/ahtapot/lab> ssh-keygen -s ahtapot_ca -I ahtapotops@kaptan.ahtapot.lab -n ahtapotops -O source-address=10.0.7.0/24 -O no-agent-forwarding -O no-port-forwarding -O no-x11-forwarding kaptan.pub
Enter passphrase: 
Signed user key kaptan-cert.pub: id "ahtapotops@kaptan.ahtapot.lab" serial 0 for ahtapot valid forever
```
  * Yukarıdaki adım ile "**kaptan.pub**" dosyası sadece 10.0.7.0/24 network bloğundan, sadece ahtapot ve ahtapotops kullanıcıları olarak bağlanacak şekilde kısıtlandırılarak imzalanır. Ayrıca SSH yaparken port forward etme, X11 protokolüyle erişim gibi özellikler de kısıtlanır. Bu dokümanın sonunda SSH anahtarı imzalanırken kullanılabilecek olan tüm opsiyonlar detaylandırılmıştır.
  * Yukarıdaki komutta "**-V YYYYMMDDHHMMSS**" opsiyonu kullanılarak belli bir süreye kadar geçerli olma ayarlaması da yapılabilir. Örneğin, yukarıdaki anahtarı 1 Ocak 2016 ‘dan 1 Ocak 2018’e  kadar geçerli olacak şekilde oluşturmak için:

```
ahtapotops@ahtapot:~/.ssh$ ssh-keygen -s ahtapot_ca -I ahtapotops@kaptan.ahtapot.lab -n ahtapotops -O source-address=10.0.7.0/24 -O no-agent-forwarding -O no-port-forwarding -O no-x11-forwarding -V"20160101:20180101" id_rsa.pub
Signed user key id_rsa-cert.pub: id "ahtapotops@kaptan.ahtapot.lab" serial 0 for ahtapotops valid from 2016-01-01T00:00:00 to 2018-01-01T00:00:00
```

  * Oluşan imzalanmış anahtar dosyasının adı "**kaptan_cert.pub**" dir. Bu dosyada ki imzalanmış kısıtlamalara göz atmak için aşağıdaki komut kullanılır.

```
ahtapotops@ahtapot:~/ahtapot/ahtapot/os/keys> ssh-keygen -Lf kaptan-cert.pub 
kaptan-cert.pub:
        Type: ssh-rsa-cert-v01@openssh.com user certificate
        Public key: RSA-CERT 92:4b:a6:c5:8c:60:c5:c1:ab:37:a9:6f:64:22:1b:9e
        Signing CA: RSA 68:1c:65:34:85:10:d7:56:db:99:c5:31:43:4d:e5:24
        Key ID: "ahtapotops@kaptan.ahtapot.lab"
        Serial: 0
        Valid: from 2016-01-01T00:00:00 to 2018-01-01T00:00:00
        Principals: 
                ahtapot
                ahtapotops
        Critical Options: 
                source-address 10.0.7.0/24
        Extensions: 
                permit-pty
                permit-user-rc

```


  * Yukarıda imzalanmış anahtar USB gibi bir taşıma yöntemiyle, ilk oluşturulduğu sunucuya, gizli anahtarın olduğu dizine kopyalanması gerekir. Bu varsayılan ayarlar için, anahtarın oluşturulduğu kullanıcının ev dizini altındaki "**.ssh**" dizini olmak durumundadır. 
  * "**.ssh**" dizini bulunmaması durumunda kullanıcının ev dizini altında oluşturulmalıdır.
```
mkdir .ssh
```  

  **NOT :** Bu yöntem kullanılarak aşağıdaki kullanıcı listesi için farklı anahtarlar oluşturulmalıdır.
        
        * ahtapotops
        * git
        * myshook
        * gdyshook

####CA Anahtarı ile Sadece FirewallBuilder Kullanabilecek Anahtar İmzalama 

**UYARI :** Aşağıdaki adımların çalıştırılacağı sistem "**Ahtapot CA**" sunucusudur.

  * “**İmzalanacak Kullanıcı Anahtarı Oluşturma**” başlığında anlatıldığı adımlar kullanılarak, FWbuilder yönetme yetkisi verilecek kullanıcı için bir anahtar oluşturulur. Bu kullanıcının açık (Public) anahtarı Ahtapot CA makinasında imzalama anahtarının bulundugu dizine getirilir. Tercihen USB /CD gibi bir yöntem kullanarak, ağ kullanılmadan getirilmesi önerilir.
  * Kullanıcı anahtarının Ahtapot CA sunucusunda imzalama anahtarıyla aynı dizine taşınmasından sonra şu şekilde imzalama işlemi gerçekleştirilir. Aşağıda "**kaptan.pub**" dosyası içindeki kullanıcı açık anahtarı için kısıtlandırılmalı imzalama gerçekleştirilir.

```
ahtapotops@ahtapot:~/ahtapot/ahtapot-gereksinimler/keys$ ssh-keygen -s ahtapot_ca -I ahtapotops@ahtapot.ahtapot.lab -n ahtapotops -O permit-port-forwarding -O permit-x11-forwarding -O force-command="/var/opt/gdysgui/gdys-gui.py" kaptan.pub 
Signed user key kaptan.pub: id "kaptan@ahtapot.ahtapot.lab" serial 0 for ahtapotops valid forever
```
  * Oluşturulan anahtar bağlantı kurduğu sunucuda "**ahtapotops**" kullanıcı yetkilerine sahip olacak, X11 kullanabilecek ve **sadece** FirewallBuilder uygulamasına erişebilecektir. FireallBuilder uygulamasını başlatma komutu olan "**/var/opt/gdysgui/gdys-gui.py**" dışında herhangi başka bir komut **çalıştıramaması** SSH ve PKI alt yapısı tarafından garanti altına alınır.
  * Oluşturulan anahtarın kısıtlamalarına göz atmak için :

```

ahtapotops@ahtapot:~/ahtapot/ahtapot-gereksinimler/keys$ ssh-keygen -Lf kaptan-cert.pub 
kaptan-cert.pub:
        Type: ssh-rsa-cert-v01@openssh.com user certificate
        Public key: RSA-CERT 34:cc:67:20:2f:01:74:2f:e7:3f:f8:ca:a9:3a:ec:77
        Signing CA: RSA 62:56:a2:64:62:67:97:94:d2:9e:7b:5d:d9:35:95:0c
        Key ID: "kaptan@ahtapot.ahtapot.lab"
        Serial: 0
        Valid: forever
        Principals: 
                ahtapotops
        Critical Options: 
                force-command /var/opt/gdysgui/gdys-gui.py
        Extensions: 
                permit-X11-forwarding
                permit-agent-forwarding
                permit-port-forwarding
                permit-pty
                permit-user-rc

```

  * Bu imzalanmış "**kaptan-cert.pub**" anahtar dosyasının bağlantının yapılacağı FirewallBuilder yönetiminin gerçekleştirileceği XWindows çalıştırabilen sunucuya transfer edilerek bağlantıyı kuracak kullanıcının gizli anahtarının da bulunması gereken home dizinindeki "**.ssh**" dizini içine kopyalanması gerekir. Kopyalanacak dosya ismi "**id_rsa-cert.pub**" olarak değiştirilmelidir. Dizinde bulunan dosyalar :

```
ahtapotops@ahtapot:~$ ls -alh /home/ahtapotops/.ssh/
total 112K
drw 1 ahtapotops users  230 Dec 26 20:23 .
drwxr-xr-x 1 ahtapotops ahtapotops  638 Dec 27 10:14 ..
-rw-r--r-- 1 ahtapotops users 1.3K Dec 27 12:33 config
-r- 1 ahtapotops users 1.8K Mar 25  2015 id_rsa
-rw-r--r-- 1 ahtapotops ahtapotops 1.6K Dec 27 12:12 id_rsa-cert.pub
-rw-r--r-- 1 ahtapotops users  405 Mar 25  2015 id_rsa.pub
-r- 1 ahtapotops ahtapotops  39K Dec 27 10:29 known_hosts
```

  * FirewallBuilder yönetilecek olan makinada SSH bağlantısının X11 yönlendirme yapacak olmasından dolayı performans ve kullanım kolaylığı için ssh_config (ssh sunucusu DEĞİL) ayarları yapılması gerekir. Bu ayarların bulunduğu dosya ismi "**/etc/ssh/ssh_config**". Dosyayı vi gibi bir editörle editleyerek aşağıdaki satırların bulunduğuna emin olunur.


```
    ForwardAgent Yes
    ForwardX11 Yes
    Port 22
    Compression Yes
    HashKnownHosts Yes
    StrictHostKeyChecking Yes
```


  * Yukarıda editlenirken standard dışı portta dinleme yapması önerilen SSH sunucular için "**Port**" değerini değiştirilmesi gerekir. Bu işlemden sonra SSH sunucunun tekrar başlatılması gerekmez.



####CA Anahtarı ile Kullanıcı Erişim Kısıtlama Ayarları 

| clear                        | Clear all enabled permissions.  This is useful for clearing the default set of permissions so permissions may be added individually.                                            |
|-- | ----- |
| force-command=command        | Forces the execution of command instead of any shell or command specified by the user when the certificate is used for authentication.                                          |
| no-agent-forwarding          | Disable ssh-agent(1) forwarding (permitted by default).                                                                                                                         |
| no-port-forwarding           | Disable port forwarding (permitted by default).                                                                                                                                 |
| no-pty                       | Disable PTY allocation (permitted by default).                                                                                                                                  |
| no-user-rc                   | Disable execution of ~/.ssh/rc by sshd(8) (permitted by default).                                                                                                               |
| no-x11-forwarding            | Disable X11 forwarding (permitted by default).                                                                                                                                  |
| permit-agent-forwarding      | Allows ssh-agent(1) forwarding.                                                                                                                                                 |
| permit-port-forwarding       | Allows port forwarding.                                                                                                                                                         |
| permit-pty                   | Allows PTY allocation.                                                                                                                                                          |
| permit-user-rc               | Allows execution of ~/.ssh/rc by sshd(8).                                                                                                                                       |
| permit-x11-forwarding        | Allows X11 forwarding.                                                                                                                                                          |
| source-address=address_list  | Restrict the source addresses from which the certificate is considered valid.  The address_list is a comma-separated list of one or more address/netmask pairs in CIDR format.  |

####Log Yönetimi Anahtar Oluşturma

* Rsyslog veya nxlog kullanılarak client-server arasında log gönderimi için öncelikle "**CA sunucusu**" üzerinde "**openssl**" kullanılarak "**rootCA**" oluşturulmalıdır.

```
openssl genrsa -out rootCA.key 2048
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.pem
```

* Log gönderecek veya log'u alacak makineler için openssl kullanılarak anahtarlar oluşturulur. İkinci komut çalıştırıldığında gelen soru ekranlarında "**Common Name**" satırına ilgili makinanın **FQDN** bilgisi girilmesi zaruridir.

```
openssl genrsa -out client_fqdn.key 2048
openssl req -new -key client_fqdn.key -out client_fqdn.csr
```

* Oluşturulan anahtarlar rootCA ile imzalanır.

```
openssl x509 -req -in client_fqdn.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out client_fqdn.crt -days 3650 -sha256
```

**NOT:** İstenilen durumlarda her makine için tek veya ayrı anahtarlar oluşturularak CA sunucunda imzalanılabilir. Her makinede aynı anahtar kullanılacak ise, makinelere taşınırken ilgili "**crt**" ve "**key**" dosyasının adı ilgili makinaının FQDN' i ile değiştirilmelidir.


**Sayfanın PDF versiyonuna erişmek için [buraya](ca-kurulum.pdf) tıklayınız.**
