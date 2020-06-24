# Kurulumlara Başlamadan Önce Yapılması Gereken Hazırılıklar

### Pardus 17 Ahtapot ISO'sunun indirilmesi

**Pardus 17 Ahtapot ISO**  indirmek için; [http://depo.ahtapot.org.tr/ISO/](http://depo.ahtapot.org.tr/ISO/)

**NOT:** Ahtapot ISO **ahtapotops** ön tanımlı kullanıcısı ile gelmektedir. Ön tanımlı ahtapotops kullanıcısının parolası **LA123**  Parola ilk giriş sırasında değiştirilir.

### Repo Ayarları

Ahtapot resmi repo bilgileri belirtilmiştir. NAC, SIEM ve EPS repoları özelleşirilmiş bileşenler içindir.

* Depo adreslerini /etc/apt/sources.list dosyasından düzenleyiniz.

```
ahtapotops@ansible:~$ sudo nano /etc/apt/source.list
```
```
deb http://depo.pardus.org.tr/ahtapot stable main
deb http://depo.pardus.org.tr/ahtapot testing main
deb http://depo.pardus.org.tr/ahtapot nac main
deb http://depo.pardus.org.tr/ahtapot siem main
deb http://depo.pardus.org.tr/ahtapot eps main
deb http://depo.pardus.org.tr/pardus onyedi main contrib non-free
deb http://depo.pardus.org.tr/guvenlik onyedi main contrib non-free
```

**DİKKAT:** Pardus Ahtapot ISO, Pardus Sunucu ISO 'sunun sıkılaştırma ve Ahtapot projesi için gerek görülmeyen paketlerin kaldırılmasıyla oluşturulur.

### Sertifika Otoritesi Sunucusunun Kurulması

Kuracağınız sistemde CA sunucusunun ayrı bir sunucu olarak yer almasını istiyor iseniz, Ahtapot kurulumlarına başlanılmadan önce Pardus-Ahtapot ISO kurulmuş bir sunucu "**CA Sunucusu**" olarak ayrılmalıdır.

Ayrı bir sunucu olmasına gerek duymuyor iseniz, Merkezi Yönetim Sistemi (ansible) için kuracağımız sunucu ile CA sunucusu aynı sunucu oalbilir. Kurulum dokümanında CA ve MYS sunucusu aynı sunucusudur.

### Kurulum Sırasındaki Önceliklendirmeler

Diğer Ahtapot sistemlerinin verimli ve hızlı bir şekilde kurulabilmesi için izlenmesi gereken adımlar;

* Merkezi Yönetim Sistemi Kurulumu
* Gitlab Kurulumu

Merkezi Yönetim Sistemi kurulumu tamamlandıktan sonra ihtiyaca göre diğer bileşenlerin kurulumları yapılmalıdır.

* Eğer merkezi olarak yönetilecek diğer ahtapot bileşenlerine Sanal Özel Ağ ile erişilmesi gerekiyorsa bir sonraki adımda da  Sanal Özel Ağ Sistemi kurulumu gerçekleştirilmelidir. 
* Bundan sonraki sıralama kullanıcı tercihine göre belirlenebilir. Bileşenler kuruldukça kayıtlarının (log) Siber Olay, Açıklık, Risk İzleme ve Yönetim Sistemine aktarılması isteniyorsa bir sonraki adım olarak bu sistemin kurulması tercih edilebilir.

