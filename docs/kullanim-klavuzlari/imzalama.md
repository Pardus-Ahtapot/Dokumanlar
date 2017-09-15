![ULAKBIM](../img/ulakbim.jpg)
#5651 İmzalama Kullanımı
------

[TOC]


Bu dökümanda Merkezi Yönetim Sistemi bileşenlerinde logların 5651 kapsamında imzalanması anlatılmaktadır.

####KamuSM ile İmzalama

* Internet Bağlantısının olduğu ortamlarda imzalama rolu rsyslog makinesine verilmiştir. Ansible playbookları içerisinde imzalama işleminin gerçekleştirilebilmesi için gerekli bilgiler eklenmelidir. 
* "**/etc/ansible/roles/rsyslog/vars**" dizini içerisinde "**signer.yml**" dosyası düzenlenerek gerekli değişkenler girilir.
```
---
# Signer yapilandirmasini belirtmektedir.
signer:
    conf:
        source: "signer.bash.j2"
        destination: "/opt/signer.bash"
        owner: "root"
        group: "root"
        mode: "0750" 
    cron:
        source: "signercron.sh.j2"
        destination: "/etc/cron.d/signercron.sh"
        owner: "root"
        group: "root"
        mode: "0750"
    min: "00"
    hour: "07"
    directory:
        path: "/data/log/5651"
        owner: "root"
        group: "root"
        mode: "750" 
        state: "directory"
    type: "remote" # (remote or local) remote for tubitak, local for openssl
    username: "tubitak"
    password: "'tubitak'"
    signingdirectory: "/data/log/5651/tmp" 
    signedlogs: "/data/log/5651/signedlogs" 
    invalidlogs: "/data/log/5651/invaledlogs"
    signedlogsarchive: "/data/log/5651/signedlogsarchive"  # exist only for local signing
    invalidlogsarchive: "/data/log/5651/invaledlogsarchive" # exist only for local signing 
    serverfiles: "ossimcik0*"
    command: "/opt/ZamaneConsole-2.0.5/ZamaneConsole-2.0.5.jar"
    logs: "/data/log"
    proxyuser: "proxyuser"
    proxypassword: "proxypass"
    proxyip: "proxyip"
    proxyport: "proxyport"
```
* KamuSM Zamane ile imzalanacak durumlarda "**username**" ve "**password**" bölümlerine ilgili kullanıcı adı ve parola bilgileri girilmelidir. **signedlogs** imzalanan logların tutulacağı, **invalidlogs** loglar imzalanırken herhangi bir hata ile karşılaşılması sırasında logların tutulacağı dizinlerdir. "**serverfiles**" imzalanacak logların tutulduğu dizinlerin bulunduğu ortak bir isim olmalıdır. Log dizinlerinin haricinde başka bir dizin olmaması durumunda "*" olarakta verilebilir. "**logs**" içerisine ossimciklerden gelen logların rsyslog içerisinde yazılacağı dizin bilgisi bulunmalıdır. Rsyslog makinesi proxy arkasında bulunuyor ise "**proxy**" ile ilgili bilgiler girilmelidir.

* Gerekli değişkenlerin girilmesi ile "**rsyslog.yml**" çalıştırılarak rsyslog playbook oynatılır. 
```
$ cd /etc/ansible/
$ ansible-playbook playbooks/rsyslog.yml
```

####Local İmzalama Sunucusu ile Imzalama

* Local imzalama yapılabilmesi için öncelikle **local imzalama sunucusu** kurulmalıdır. Bu durumda logların toplandığı rsyslog sunucunda loglar imzalanmak üzere imzalama sunucusuna gönderilecek, openssl kullanılarak imzalanılacak, imzalama işlemi tamamlanan loglar belirlenen dizin altına atılacaktır.

* Rsyslog sunucusu ile imzalama sunucusu arasında "ssh-keygen" kullanarak şifresiz ssh yapılabilmesi için anatar oluşturulmalıdır. Oluşturulan ssh anahtarları **root** ve **ahtapotops** kullanıcılarının  home dizinleri altında ".ssh" dizini içerisine kopyalanmalıdır. Ssh anahtar oluşturulması için CA Kurulumu ve Anahtar Yönetimi dökümanındaki [CA Anahtarı ile Kullanıcı Anahtarı İmzalama](../kurulum-yonergeleri/ca-kurulum.md) başlığı incelenmelidir.

* Ssh anahtarları oluşturulması ile rsyslog sunucundan imzalama sunucusuna ssh yapılarak test edilmelidir.

* Logların openssl kullanılarak imzalanması için gerekli anahtarlar oluşturulmalıdır. Kök dizini altında "**/CA**" dizini oluşturularak gerekli anahtarlar burada oluşturulur. Anahtarlar oluşturulmadan önce "**openssl.cnf**" dosyası düzenlenmelidir.
``` 
vi /etc/ssl/openssl.cnf
Dosya içerisinde "42." satırda bulunan "./demoCA" dizini "**/CA**" dizini olarak değiştirilmelidir.
[ CA_default ]

dir             = /CA              # Where everything is kept
Dosya içerisinde "330." satırda bulunan "./demoCA" dizini "**/CA**" dizini olarak değiştirilmelidir.
[ tsa_config1 ]
 
# These are used by the TSA reply generation only.
dir             = /CA              # TSA root directory
```
* **NOT:** openssl versiyona göre config dosyasında değişiklik gösterebilmektedir. Openssl.cnf dosyasın içerisinde "215." satırın yorum satırı olmaması gerektiğine dikkan edilmelidir. "extendedKeyUsage = critical,timeStamping" şeklinde olmalıdır.


Aşağıdaki komutlar çalıştırılarak anahtar oluşturma işlemleri tamamlanır.
```
touch /CA/index.txt
echo '1000' > /CA/seria
mkdir /CA/newcerts
openssl req -config /etc/ssl/openssl.cnf -days 1825 -x509 -newkey rsa:2048 -out cacert.pem -outform PEM
cp /CA/privkey.pem /CA/private/cakey.pem

echo '1000' > /CA/tsaseria
openssl genrsa -aes256 -out tsakey.pem 2048
openssl req -new -key tsakey.pem -out tsareq.csr
openssl ca -days 1825 -config /etc/ssl/openssl.cnf -in tsareq.csr -out tsacert.pem
```
* Oluşturulan anahtarlar imzalama sunucusu içerisine kök dizini içerisinde "**/CA** dizini altına  kopyalanmalıdır. Kök dizin altında başka bir dizin içerisine kopyalanması durumunda imzalama betiği konfigurasyon dosyası olan "config.ini" içerisine yazılmalıdır.
* Rsyslog sunucusu içerisine "**pyVerify**" paketinin kurulması ile gerekli betikler "/opt/pyVerify/" altında bulunmaktadır. "**/opt/pyVerify/**" dizinine gidilerek gerekli konfigurasyon dosyası düzenlenmelidir.
* Rsyslog sunucusu içerisinde bulunan "**config.ini*" dosyası içerisine gerekli değişkenler girilmelidir. 
* **Paths** başlığı altında "logs" değişkenine rsyslog makinesine gelen logların dizinlerinin bulunduğu dizin girilmelidir. "verified" ve "unverified" değişkenleri içerisine başarılı veya başarılısız imzalama sonucunda oluşan log dosyasının bulunması istenen dizinler girilmelidir. 
* **Server** başlığı altında "server_copy_path" değişkenini imzalama sunucusu içerisinde imzalanan ve rsyslog sunucusuna geri gönderilmesen önce log dosyalarının tutulması istenilen dizin girilmelidir. Bu dizin içerisinde atılan dosyalar işlemlerinin tamamlanması ile silineceklerdir. "server_ip" değişkeni içerisine imzalama sunucusunun ip adresi girilmelidir. "server_user" değişkeni içerisine imzalama yapacak kullanıcının adı girilmelidir. Default olarak ahtapotops kullanıcısı bulunmaktadır. "port_number" değişkeni içerisine imzalama sunucusunun ssh port bilgisi girilmelidir
* **CA** başlığı altında openssl ile oluşturulan anahtar bilgileri girilmelidir. "openssl_conf" değişkeni içerisine openssl.cnf dosyası dizini ile beraber girilmelidir. "ca_public_key" değişkeni içerisine openssl ile oluşturulan "cacert.pem" dosyası dizini ile beraber girilmelidir. "tsa_public_key" değişkeni içerisine openssl ile oluşturulan "tsacert.pem" dosyası dizini ile beraber girilmelidir. "sign_password" değişkeni içerisine openssl ile anahtar oluştururken girilen password yazılmalıdır.

```
vi config.ini
[Paths]
logs = /var/log/mys/
verified =
unverified =

[Server]
server_copy_path =
server_ip =
server_user =
port_number = 0

[CA]
openssl_path = /usr/bin/openssl
openssl_conf = /etc/ssl/openssl.cnf
ca_public_key = /CA/cacert.pem
tsa_public_key = /CA/tsacert.pem
sign_password =
```
* Konfigurasyon dosyası düzenlenmesi ile python betik manuel çalıştırılarak test edilmelidir.
```
sudo python verify.py
```

* **NOT:** İmzalama işlemi için gerekli olan komut crontab içerisine eklenilerek her gun çalışarak logların imzalanması sağlanılır.

**Sayfanın PDF versiyonuna erişmek için [buraya](imzalama.pdf) tıklayınız.**
