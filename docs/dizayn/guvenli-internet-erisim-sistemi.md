![ULAKBIM](../img/ulakbim.jpg)
#Güvenli İnternet Erişim Sistemi
------

Bu dokümanda, Güvenli İnternet Erişim Sistemi (Proxy) tasarım ve çalışma prensibi anlatılmaktadır.

------

![WebProxy](../img/WebProxyDiyagram.jpg)

  * Kullanıcı gitmek istediği sayfaya girmek için browser üzerinden web proxye istek gönderir.
  * Web Proxydeki beyaz listede ilgili sayfa olmadığından ya da kara listede bulunduğundan kullanıcının girişine izin vermez.
  * Kullanıcının karşısına 403 sayfası çıkar, hatalı engelleme olduğunu düşünüyorsanız buraya tıklayın seçeneğine tıklar.
  * Web uygulama sunucusu üzerinde çalışan web uygulaması çağırılır.
  * Açılan ekranda, beyaz listeye eklenmek istenen URL ve hangi web proxy sunucusu üzerinde yapılacağı seçilir.
  * Web uygulamada seçim yapıldıktan sonra git sunucusu üzerinde bulunan repodaki beyaz liste güncellenir.
  * Ansible makinası beyaz listeyi git pull ile çeker.
  * Ansible makinası state cron jobı geldiğinde web proxy makinası üzerinde oynatarak ilgili değişikliği lokalde bulunan beyaz listeye yazar.

**NOT:** Merkezde bulunan 2 adet rsyslog sunucusuna aşağıdaki sunuculardan log gönderimi yapılır.
    
    Web Proxy
    DHCP
    Ansible
    Gitlab
    Web Uygulama Sunucusu

**Sayfanın PDF versiyonuna erişmek için [buraya](guvenli-internet-erisim-sistemi.pdf) tıklayınız.**

