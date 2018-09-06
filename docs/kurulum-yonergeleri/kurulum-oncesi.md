# Kurulumlara Başlamadan Önce Yapılması Gereken Hazırılıklar

### Pardus-Ahtapot ISO'sunun indirilmesi

Pardus-Ahtapot ISO'su **http://depo.pardus.org.tr/pub/ISO/Ahtapot/pardus-ahtapot-kurumsal5-amd64.iso** adresinden indirebilinir.

### Sertifika Otoritesi Sunucusunun Kurulması

Ahtapot kuruacak sistemde Sertifika Otoritesi (CA) sunucusu mevcut değil ise Ahtapot kurulumlarına başlanılmadan önce Merkezi Yönetim Sisteminin diğer tüm sistemleri güvenilir şekilde yönetmesini sağlayacak olan sertifikaların oluşturulmasını sağlayacak olan Sertifika OtoritesiSunucusu Kurulmalıdır. Sertifika Otoritesi sunucusu kurulduktan sonra **Sertifika Otoritesi Kurulumu ve Anahtar Yönetimi** dökümanında belirtilen şekilde yönetim anahtarlarının oluşturulması gerekmektedir.

### Kurulum Sırasındaki Önceliklendirmeler

Diğer Ahtapot sistemlerinin verimli ve hızlı bir şekilde kurulabilmesi için Sertifika Otoritesi kurulumu tamamlandıktan sonra öncelikle Merkezi Yönetim Sistemi suncusu kurulmalı. Eğer merkezi olarak yönetilecek diğer ahtapot bileşenlerine Sanal Özel Ağ ile erişilmesi gerekiyorsa bir sonraki adımda da  Sanal Özel Ağ Sistemi kurulumu gerçekleştirilmelidir. Bundan sonraki sıralama kullanıcı tercihine göre belirlenebilir. Bileşenler kuruldukça kayıtlarının (log) Siber Olay, Açıklık, Risk İzleme ve Yönetim Sistemine aktarılması isteniyorsa bir sonraki adım olarak bu sistemin kurulması tercih edilebilir.
