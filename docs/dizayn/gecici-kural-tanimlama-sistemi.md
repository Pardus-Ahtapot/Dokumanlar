![ULAKBIM](../img/ulakbim.jpg)
#Geçici Kural Tanımlama Sistemi
------

Bu dokümanda, Geçici Kural Tanımlama Sistemi tasarım ve çalışma prensibi anlatılmaktadır.

------

![GKTS](../img/GKTSdiyagram.png)

  * Sistem yöneticisi tarafından Geçicici Kural Tanımlama Sistemini barındıran web uygulama sunucusu üzerinde izin verilecek kural ve kullanıcılar girilir. 
  * Erişim sağlamak isteyen geliştirici tarafından gerekli güvenlik duvarı kuralı aktif edilir.
  * Aktif edilmiş kural Geçici Kural Tanımlama Sistami web uygulama sunucusu üzerinde bulunan ansible playbook ile ilgili firewall üzerinde oynatılarak, sistem yöneticisi tarafından belirlenmiş süre boyunca erişimine izin verir.

**Sayfanın PDF versiyonuna erişmek için [buraya](gecici-kural-tanimlama-sistemi.pdf) tıklayınız.**
