![ULAKBIM](../img/ulakbim.jpg)

# Sistem Bütünlüğü

Bu dokümanda, sistem bütünlüğü için yapılan periyodik kontrollerin çalışma prensibi anlatılmaktadır.

------


* Sistem bütünlüğü kontrolü için uç makinanın ilk kurulumundan sonra makinadan yüklü paketler, kullanıcılar, gruplar ve konfigürasyon bilgileri alınır.
* Bu bilgiler hem uzak makinanın kendisinde hemde merkezi bir git sunucusunda saklanır.
* Toplanan bu bilgileri bir betik kullanıcının belirleyeceği aralıklarla sistemi kontrol eder.
* Kontrol işlemi için öncelikle git sunucusundan güvenilir dosyaların bir kopyasını yerele alınır. Eğer git sunucusuna erişilemezse hali hazırda var olan dosyalar kullanılır.
* Kontrol işlemi sırasında betik, kendi üzerinde kullanıcı, grup ve yüklü paketlerin listesini alır. Bu listeler ile git sunucusundan gelen listeleri karşılaştırır. Farklılık durumunda alarm logu üretilir.
* Aynı şekilde betik, konfigürasyon listesindeki tüm dosyaların özet ve paketlerin özet değerlerini alır ve git sunucusundan gelen değerler ile karşılarştırma yapar. Farklılık durumda alaram logu üretilir.
* Periyodu belirlemek için /etc/ansible/roles/post/vars/integrity.yml dosyasının içinde bulunan **cron** konfigürasyonun **min** ve **hour** değerleri değiştirilir.
* Playbook tekrar çalıştığında öncelikle uç cihaz kontrol tetiklenir. Uç cihaz bilgileri git sunucusundan alır ve kontrollerini yapar. Farklılık olması halinde log üretilir.
* Bulunan olması gereken durumdan sapma(fazladan yaratılmış kullanıcı, değişmiş konfigürasyonlar, fazladan yüklenmiş paketler vs.) sistem alarm üretir ve kullanıcıyı uyarır.
* İsteğe bağlı olarak kullanıcı saptanmış fazlalıkların otomatik olarak giderilmesini ayarlayabilir. Bu sayede kontroller sırasında bulunan fazlalıklar kullanıcıyı uyarmakla beraber sistemden silinir.
* /etc/ansible/roles/post/vars/integrity.yml dosyasının **cron** kısmındaki **fix** ayarını true yaparak fazlalıkların otomatik olarak giderilmesi sağlanır.
* Kullanıcı isterse her bir makina için ayrı, kontrol edilmeyecek paket, kullancı ve grupları belirleyebilir. Bu bilgileri /etc/ansible/roles/post/vars/integrity.yml dosyasının içindeki **whitelist** değişkenine eklenir. Bu sayede istenmeyen paket, kullanıcı ve grup bilgileri için alarm üretilmez.
