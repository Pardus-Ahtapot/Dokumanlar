![ULAKBIM](../img/ulakbim.jpg)
#Sistem Bütünlüğü
------

Bu dokümanda, sistem bütünlüğü için yapılan periyodik kontrollerin çalışma prensibi anlatılmaktadır.

------


* Sistem bütünlüğü kontrolü için uç makinanın ilk kurulumundan sonra makinadan yüklü paketler, kullanıcılar, gruplar ve konfigürasyon bilgileri alınır.
* Toplanan bu bilgiler kullanıcının belirleyeceği aralıklarla sistemi kontrol eder.
* Periyodu belirlemek için /etc/ansible/roles/post/vars/integrity.yml dosyasının içinde bulunan **cron** konfigürasyonun **min** ve **hour** değerleri değiştirilir.
* Bulunan olağandan sapmalarda(fazladan yaratılmış kullanıcı, değişmiş konfigürasyonlar, fazladan yüklenmiş paketler vs.) sistem alarm üretir ve kullanıcıyı uyarır.
* İsteğe bağlı olarak kullanıcı saptanmış fazlalıkların otomatik olarak giderilmesini ayarlayabilir. Bu sayede kontroller sırasında bulunan fazlalıklar kullanıcıyı uyarmakla beraber sistemden silinir.
* /etc/ansible/roles/post/vars/integrity.yml dosyasının **cron** kısmındaki **fix** ayarını true yaparak fazlalıkların otomatik olarak giderilmesi sağlanır.

**Sayfanın PDF versiyonuna erişmek için [buraya](sistem-butunlugu.pdf) tıklayınız.**
