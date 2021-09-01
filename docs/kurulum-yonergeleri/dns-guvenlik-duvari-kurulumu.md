# DNS Güvenlik Duvarı 



Bu dokümanda, Ahtapot projesi kapsamında DNS Güvenlik Duvarı (DNSFW) bileşeninin, merkezi yönetim sistemi ile nasıl kurulacağı anlatılmaktadır.

### DNS Güvenlik Duvarı Kurulum İşlemleri

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

* Gitlab arayüzünden mys resposundaki “**hosts**” dosyasında “**[waf]**” fonksiyonu altına web uygulama güvenlik duvarı sunucusunun FQDN bilgisi girilir.

```
[dnsfw]
dnsfw.local
``` 

* Gitlab arayüzünden mys reposundaki  “**roles/base/vars/host.yml**” dosyasına web uygulaması güvenlik duvarı sunucusunun ip adresi, FQDN bilgisi ve hostname’i yeni bir server bloğu oluşturularak yazılır. 

```
serverN:
        ip: "X.X.X.X"
        fqdn: "dnsfw.local"
        hostname: "dnsfw"
```

Ardından dns güvenlik duvarı sistemi ile ilgili aşağıda tanımlanmış değişkenler açıklamalarda belirtilen şekilde uygun değerlerle doldurulur.

## Web Uygulama Güvenlik Duvarı Değişkenleri
### Ahtapot Web Uygulama Güvenlik Duvarı Genel Ayarlar
Bu roldeki değişkenler “**/etc/ansible/roles/dnsfw/vars/**” dizini altında bulunan waf.yml dosyalarında belirtilmiştir. yml dosyalarının içerikleri ve değişken bilgileri aşağıdaki gibidir;

 “**main.yml**” dosyasında bulunan değişkenlerin görevi şu şekildedir. 

- **verbosity** değişkeni, log seviyesini belirler. 0 hiç bir log yok demektir, 1 operasyonel bilgiler sunar, 2 her sorgu için detaylı bilgi sunar. 4 algoritma seviyesinde log üretirken, 5 değeri istemci tanımlama bilgileri ve cache bilgilerini de içerir.
- **num\_threads** değişkeni, kaç alt çalışan yordam olacağını belirler. Eğer 1 verilirse, threading özelliği kapatılmış olur.

- **interface** değişkeni,dinlenecek olan ip adresini belirler. Eğer hiç bir değer verilmezse, **localhost** dinlenecektir.
- **port** DNS servisi tarafından dinlenecek olan portu belirler. Varsayılan değeri **53** dür.
- **outgoing\_range** Açılacak port sayısı. Bu değer tanımlayıcılar için thread başına açılacak port sayısını belirler. Daha iyi performans için yüksek bir değer iyidir.

- **num\_queries\_per\_thread** Her threading cevaplayacağı istek sayısını belirler. Bir thread belirtilen sayıya (anlık) ulaşınca, yeni bir thread (en fazla num_thread kadar) açılmasını sağlar.

- **forward\_addr** Gelen isteklerin yönlendirileceği üst DNS sunucusunu belirtir. Liste olarak, istenilen kadar sunucu belirtilebilir.

- **download_bl** Kurulum işlemi tamamlandıktan sonra, zararlı alanadı listesinin otomatik olarak indirilmesini sağlar.

- **autodownload** Zararlı adres listelerinin, otomatik olarak her gün indirilip güncellenmesini sağlar.

- **usom\_domain\_list** USOM formatında zararlı domain listesi için, liste adresini belirtir.

- **ahtapot\_cti\_dnsbl** Ahtapot Siber Istihbarat Servisi tarafından üretlien zararlı listesinin otomatik olarak indirilmesini sağlar.

- **local\_data** Ahtapot DNSFW tarafından üst dns sunucusuna yönlendirilmeden, dahili olarak çözümleme yapılmasını istediğiniz alan adresi ve dns kaydı türü, karşılık değerini belirtir. local_data için aşağıdaki format kullanılmalıdır;



```
local_data:
    local01:
         domain: "ahtapot.org.tr"
         type: "A"
         content: "172.16.103.200"
    local02:
         domain: "pardus.org.tr"
         type: "A"
         content: "172.16.103.220"
```






İlgili değişkenler ayarlandıktan sonra aşağıdaki komut ile "**Ahtapot DNS Güvenlik Duvarı**" aşağıdaki komut ile kurulabilir.

```
ansible-playbook /etc/ansible/playbooks/dnsfw.yml 
```


