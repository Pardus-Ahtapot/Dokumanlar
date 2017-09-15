![ULAKBIM](../img/ulakbim.jpg)
#Merkezi Yönetim Sistemi
------

Bu dokümanda, Merkezi Yönetim Sistemi tasarım ve çalışma prensibi anlatılmaktadır.

------

![MYS](../img/MYSdiyagram.png)

* Ahtapot projesinin temelini oluşturan Merkezi Yönetim Sisteminde, Sunucu yönetimleri Ansible sunucusu tarafından yapılmaktadır.
* Sistem Yöneticisi tarafından GitLab arayüzü kullanılarak Ansible Playbooklar üzerinde gerekli değişiklikler yapılarak, onaya gönderilir.
* Değişiklikler onaylandıktan sonra, Git'in sunduğu hook mekanizması kullanılarak Ansible makinasının güncel playbookları Git'ten çekilerek ilgili makina üzerinde çalıştırması sağlanır.
* FirewallBuilder makinası ile, Ahtapot Güvenlik Duvarı cihazlarının yönetimi yapılmaktadır. FirewallBuilder arayüzü kullanılarak yapılan işlemler Test Güvenlik Duvarı üzerinde yazım yönünden kontrol edildikten sonra Ansible sunucusu tarafından Ahtapot Güvenlik Duvarlarında oynatılmak üzere otomatik olarak Playbook çalışır.
* Geçici Kural Tanımlama Sistemi ile, Ahtapot Güvenlik Duvarları üzerinde, belirlenmiş zaman aralığı için güvenlik duvarı kuralları belirlenebilmektedir. Çalışması istenen geçici güvenlik duvarı kuralı, Ahtapot Güvenlik Duvarları üzerinde otomatik oynamaktadır.
* Yapıda kullanılan her sunucunun logları Rsyslog suncularında toplanmaktadır.

**Sayfanın PDF versiyonuna erişmek için [buraya](merkezi-yonetim-sistemi.pdf) tıklayınız.**
