# Kurulumlara Başlamadan Önce Yapılması Gereken Hazırılıklar

### Pardus 17 Ahtapot ISO'sunun indirilmesi

**Pardus 17 Ahtapot ISO** 'su indirmek için; [http://ahtapot.org.tr/indirmeler.html](http://ahtapot.org.tr/indirmeler.html)

**NOT:** Pardus 17 Ahtapot, **ahtapotops** ön tanımlı kullanıcısı ile gelmektedir. Ön tanımlı ahtapotops kullanıcısının parolası **LA123**  Parola ilk giriş sırasında değiştirilir.

### Pardus-Ahtapot Kurumsal 5 ISO'sunun indirilmesi

**Pardus-Ahtapot Kurumsal 5 ISO** 'su indirmek için; [http://ahtapot.org.tr/indirmeler.html](http://ahtapot.org.tr/indirmeler.html) 
**NOT: ahtapotops** ön tanımlı kullanıcısı ile gelmektedir. Ön tanımlı ahtapotops kullanıcısının parolası **LA123!!**

### Pardus17 Sunucu ISO'nun İndirilmesi ve Repo Ayarları

**Pardus17 Sunucu ISO** 'su indirmek için [indir.pardus.org.tr/ISO/Pardus17/Pardus-17.4-SERVER-amd64.iso](indir.pardus.org.tr/ISO/Pardus17/Pardus-17.4-SERVER-amd64.iso) Pardus17 isosunda gerekli üzenlemeleri el ile yapılması gerekmektedir. Öntanımlı kullanıcı parola yoktur.

* Depo adreslerini /etc/apt/sources.list dosyasından düzenleyiniz.

```
ahtapotops@ansible:~$ sudo nano /etc/apt/source.list
```
```
deb [trusted=yes] http://depo.pardus.org.tr/ahtapot yenikusak main
deb [trusted=yes] http://depo.pardus.org.tr/ahtapot-siem yenikusak main
deb [trusted=yes] http://depo.pardus.org.tr/pardus-yenikusak yenikusak main non-free contrib
deb http://depo.pardus.org.tr/pardus onyedi main contrib non-free
deb http://depo.pardus.org.tr/guvenlik onyedi main contrib non-free
deb http://depo.pardus.org.tr/ahtapot stable main
deb http://depo.pardus.org.tr/ahtapot testing main
```
* Yenikuşak reposuna anahtar eklemek için aşağıdaki komutlar yardımı ile pardus reposundan anahtar indirilir ve eklenir.

```
$ wget http://depo.pardus.org.tr/pardus/pool/main/p/pardus-archive-keyring/pardus-archive-keyring_2017.2_all.deb
$ wget http://depo.pardus.org.tr/pardus-yenikusak-public.asc
$ sudo dpkg -i pardus-archive-keyring_2017.2_all.deb
$ sudo apt-key add pardus-yenikusak-public.asc
$ sudo apt-get update
```
**DİKKAT:** Pardus Ahtapot ISOları, Pardus Sunucu ISO 'sunun sıkılaştırma ve Ahtapot projesi için gerek görülmeyen paketlerin kaldırılmasıyla oluşturulur. Test ortamında Pardus Sunucu versiyonu kullanılabilir, fakat gerçek ortamda Ahtapot ISOlarının tercih edilmesi güvenlik açısından önerilir.

### Sertifika Otoritesi Sunucusunun Kurulması

Kuracağınız sistemde CA sunucusunun ayrı bir sunucu olarak yer almasını istiyor iseniz, Ahtapot kurulumlarına başlanılmadan önce Pardus-Ahtapot ISO kurulmuş bir sunucu "**CA Sunucusu**" olarak ayrılmalıdır.

Ayrı bir sunucu olmasına gerek duymuyor iseniz, Merkezi Yönetim Sistemi (ansible) için kuracağımız sunucu ile CA sunucusu aynı sunucu oalbilir. Kurulum dokümanında CA ve MYS sunucusu aynı sunucusudur.

### Kurulum Sırasındaki Önceliklendirmeler

Diğer Ahtapot sistemlerinin verimli ve hızlı bir şekilde kurulabilmesi için izlenmesi gereken adımlar;

* Sertifika Otoritesi Kurulumu
* Gitlab Kurulumu
* Merkezi Yönetim Sistemi Kurulumu

Merkezi Yönetim Sistemi kurulumu tamamlandıktan sonra ihtiyaca göre diğer bileşenlerin kurulumları yapılmalıdır.

* Eğer merkezi olarak yönetilecek diğer ahtapot bileşenlerine Sanal Özel Ağ ile erişilmesi gerekiyorsa bir sonraki adımda da  Sanal Özel Ağ Sistemi kurulumu gerçekleştirilmelidir. 
* Bundan sonraki sıralama kullanıcı tercihine göre belirlenebilir. Bileşenler kuruldukça kayıtlarının (log) Siber Olay, Açıklık, Risk İzleme ve Yönetim Sistemine aktarılması isteniyorsa bir sonraki adım olarak bu sistemin kurulması tercih edilebilir.

