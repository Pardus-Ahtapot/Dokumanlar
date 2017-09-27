![ULAKBIM](../img/ulakbim.jpg)
#Ahtapot Hata Ayıklama Rehberi
------

[TOC]


Bu dökümanda Merkezi Yönetim Sistemi bileşenlerinde karşılaşılabilecek hatalar ve çözümleri anlatılmaktadır.

####Ahtapot Hata Ayıklama Rehberi

###Log Gönderimi Hataları

* Client makinelerden Ossimcik Makinesine veya Ossimcik makinelerinden Ossim ve Rsyslog makinelerine logların gönderilmemesi tespit edilmesi durumunda yapılması gerekenler:
 1. Logların gönderimi için nxlog ve rsyslog kullanılmaktadır. Hatanın tespiti için öncelikle uygulamaların kendi oluşturdukları loglar incelenmelidir. Rsyslog için "/var/log/syslog" nxlog için "/var/log/nxlog/nxlog.log" dosyaları incelenmelidir.
 2. Log gönderen ve log alan makinelerin "**/etc/rsyslog.conf**" dosyası, windows makineler için "**/etc/nxlog/nxlog.conf**" içerisinde verilen, şifreli log gönderiminde kullanılan anahtarların isimleri ve dizinleri kontrol edilmelidir. Makineler içerisinde anahtarlar kontrol edilmelidir.

```
cat /etc/rsyslog.conf
$DefaultNetstreamDriverCAFile  /etc/ssl/certs/rootCA.pem
$DefaultNetstreamDriverCertFile /etc/ssl/certs/ansible01.gdys.local.crt
$DefaultNetstreamDriverKeyFile /etc/ssl/private/ansible01.gdys.local.key
```

 3. Log gönderen makinenin "**/etc/rsyslog.conf**" dosyası içerisinde log'u gönderecek makinenin fqdn bilgisinin doğru girildiği kontrol edilmeli ve "**/etc/hosts**" dosyası içerisinde log gönderilecek makinenin bilgilerinin bulunduğu kontrol edilmelidir.

```
*.* @@ossimcik01.gdys.local:514 
```
 
 4. Log gönderen ve log alan makineler farklı subnetlerde bulunması ve arada güvenlik durumu bulunması durumunda rsyslog için "tcp 514" nxlog için "tcp 6514" portlarına güvenlik duvarından izin verilmelidir.
* Log gönderimi sırasında hatanın log gönderen veya log alan makinelerin hangisinde olduğunu tespit edilmesi için **tcpdump** kullanılır. Tcudump sonucunda hatanın hangi makineden kaynaklı olduğu tespit edilir.
 Client makine içerisinde aşağıdaki komut çalıştırılarak client makineden logların okunup server içerisine gönderimi kontrol edilir.
 ```
 tcpdump host server_ip and port 514
 ```
 Log alan server makinede yine tcpdump kullanılarak client makineden paketin gelmesi kontrol edilir.
 ```
 tcpdump host client_ip and port 514
 ```

###Kibana Hatalar

* Web Browser'ından kibana'ya bağlanılmak istenildiğinde nginx hatası alınıyor ise kibanın çalıştığı elasticsearch makinesine bağlanmalıdır. Makine içerisinde kibana status'üne bakılmalıdır. 
```
/etc/init.d/kibana status
kibana is not running
```
* "kibana is not running" mesajı alınması durumunda kibana start edilmeli ve status'e yeniden bakılmalıdır.  
```
/etc/init.d/kibana status
kibana is not running
```
* Kibana yeniden start edilmesine rağmen "kibana is not running" mesajının yeniden alınması durumunda manuel olarak kibana pid oluşturulmalıdır.

```
touch /var/run/kibana.pid
chown kibana:root /var/run/kibana.pid
/etc/init.d/kibana status
kibana is running
```

###Elasticsearch Hatalar

* Elasticsearch playbook ile kullanımı tamamlanması ile elasticsearch indexleri "curl" komutu ile incelenmek istenildiğinde "Searchguard not initilized" hatası alınması durumunda searchguard için gerekli yapılandırma komutu girilmelidir. Burada önemli olanlar komut yazılırken searchguard için gerekli anahtarların isimlerinin doğru olması ve "Cluster_Name" değişkeni içerisine elasticsearch içerisinde verilen cluster ismi yazılmalıdır.
```
cd /usr/share/elasticsearch/
/bin/bash plugins/search-guard-2/tools/sgadmin.sh -cd plugins/search-guard-2/sgconfig/ -ks /etc/elasticsearch/es01-keystore.jks -kspass KEYPASS -ts /etc/elasticsearch/truststore.jks -tspass TRUSTPASS -cn Cluster_Name -h es01.gdys.local -p 9300 -nhnv
```

**Sayfanın PDF versiyonuna erişmek için [buraya](hataayiklama.pdf) tıklayınız.**
