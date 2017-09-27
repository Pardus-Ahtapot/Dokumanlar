![ULAKBIM](../img/ulakbim.jpg)
#Ahtapot Limitli Kullanıcı Konsolu
------

Bu dokümanda, AHTAPOT projesi kapsamında kullanılan Limitli Kullanıcı Konsolu genel özellikleri, bileşenleri ve bağımlılıkları dokümante edilmektedir.


[TOC]

Ahtapot-lkk, güvenlik duvarı yönetilirken yaşanabilecek sorunların çözümünde yada sistem kaynaklarının görüntülenmesi için konsol üzerinde kullanıcı ile etkileşimli olarak çalışan bir uygulamadır. Kullanıcıya, güvenlik duvarı üzerinden geçen ağ paketlerinin bilgileri, güvenlik duvarı logları, disk bilgileri, bellek ve işlemci bilgileri, hedefe gönderilen paketlerin izlediği ağ yolu, güvenlik duvarı kural durumu ve arp tablosu bilgilerini sunmaktadır. 

####Genel bileşenleri:

######1. IPTraf

* IPTraf Genel Özellikleri:

    * Ağ arabirimlerine ait ağ trafiğinin izlenmesi
    * TCP Bağlantılar
    * Aktif olarak arabirimden geçen paketler

* Ağ birimlerine ait trafiğe ait genel ve detaylı istatistik bilgileri
    * Arabirimden gelen ağ paketi sayıları
    * Aktiviteye göre dinamik olarak hesaplanan; saniye başına gelen byte sayısı
    * Arabirimlerden geçen TCP/UDP/ICMP/Other-IP/Non-IP paketlerinin sayıları ve byte mikatarı
    * Gelen ve gönderilen paket miktarları

######2. Güvenlik Duvarı Log Takibi

* **Anlık Logları GÖrüntüleme** : Anlık olarak oluşan güvenlik duvarları görüntülenir.
* **Alana Göre Arama** : Güvenlik duvarı loglarındaki alanlara göre arama yapılabilir.
* **Gelismis Arama** : Alana göre aramadan farklı olarak fieldlara bağımlı değil istenilen filtreler yazılarak arama yapılabilir.
* **Arsiv Loglarında Arama** : Arşivlenmiş ve sıkıştırılmış 1 günden daha eski güvenlik duvarı loglarında arama yapılabilir.

######3. Sistem Bilgileri

* **Disk Bilgileri (df -h)** : Güvenlik duvarının disk durumunu görüntüler. Dosyasistemi, boyut, kullanılan alan, kullanılabilir alan, kullanım oranı, bağlama noktası bilgilerini içerir.
* **Program Bilgileri (vmstat)**
	* Boş, swap, ön belleğe(cached) alınmış, tampon(buffer) memory kullanım bilgileri görüntülenebilir.
	* Bellekten diske takas edilmiş, diskten belleğe takas edilmiş bellek miktarı
	* Diske (blok cihaza) yazılan blok/saniye oranı, diskten okunan blok/saniye oranı
	* Saniye başına düşen interrupt sayısı
	* Saniye başına düşen context switch oranı
	* Kullanıcı, sistem, boşta, disk okuma/yazma, sanal sistemlerde diğer makineler tarafındna kullanılan işlemci oranları
görülebilmektedir.
* **Tracerouting (mtr)** : Verilen IP adresine ait cihaza ulaşırken, ağ paketlerin hangi ağ cihazları üzerinden geçtiği bilgisini verir.
* **Iptables Durumu (iptstate)** : Iptables durumu bilgilerini verir.
* **Arp tablosu (arp -an)** : Bulunduğu ağda paket alışverişi gerçekleştirdiği cihazların MAC ve IP adresi bilgileri görüntülenir.

####Araçlarda kullanılan komutlar ve bağımlılıkları

* **sudo komutu (sudo paketi)
Bağımlılıkları**:
    * Depends: libaudit1
    * Depends: libc6
    * Depends: libpam0g
    * Depends: libselinux1
    * Depends: libpam-modules
    * Conflicts: sudo-ldap
    * Replaces: sudo-ldap	


* **tail komutu (coreutils paketi)
Bağımlılıkları**:
    * PreDepends: libacl1
    * PreDepends: libattr1
    * PreDepends: libc6
    * PreDepends: libselinux1
    * Conflicts: <timeout>
    * Replaces: mktemp
    * Replaces: realpath
    * Replaces: <timeout>

* **cat komutu (coreutils paketi)
Bağımlılıkları**:
    * PreDepends: libacl1
    * PreDepends: libattr1
    * PreDepends: libc6
    * PreDepends: libselinux1
    * Conflicts: <timeout>
    * Replaces: mktemp
    * Replaces: realpath
    * Replaces: <timeout>

* less komutu (less paketi)
Bağımlılıkları:
Depends: libc6
Depends: libtinfo5
Depends: debianutils

* zcat komutu (gzip paketi)
Bağımlılıkları:
Depends: install-info
PreDepends: libc6
Suggests: less

* watch komutu (procps paketi)
Bağımlılıkları:
Depends: libc6
Depends: libncurses5
Depends: libncursesw5
Depends: libprocps3
Depends: libtinfo5
Depends: lsb-base
Depends: initscripts
Recommends: psmisc
Conflicts: <pgrep>
Conflicts: <w-bassman>
Breaks: guymager
Breaks: open-vm-tools
Breaks: <xmem>

* df komutu (coreutils paketi)
Bağımlılıkları:
PreDepends: libacl1
PreDepends: libattr1
PreDepends: libc6
PreDepends: libselinux1
Conflicts: <timeout>
Replaces: mktemp
Replaces: realpath
Replaces: <timeout>

* vmstat komutu (procps paketi)
Bağımlılıkları:
Depends: libc6
Depends: libncurses5
Depends: libncursesw5
Depends: libprocps3
Depends: libtinfo5
Depends: lsb-base
Depends: initscripts
Recommends: psmisc
Conflicts: <pgrep>
Conflicts: <w-bassman>
Breaks: guymager
Breaks: open-vm-tools
Breaks: <xmem>

* mtr komutu (mtr-tiny paketi)
Bağımlılıkları:
Depends: libc6
Depends: libncurses5
Depends: libtinfo5
Conflicts: mtr
Conflicts: <suidmanager>
Replaces: mtr

* iptstate komutu (iptstate  paketi)
Bağımlılıkları:
Depends: libc6
Depends: libgcc1
Depends: libncurses5
Depends: libnetfilter-conntrack3
Depends: libstdc++6
Depends: libtinfo5

* arp komutu (net-tools paketi)
Bağımlılıkları:
Conflicts: <ja-trans>
Replaces: <ja-trans>
Replaces: netbase

* iptraf komutu (iptraf paketi)
Bağımlılıkları:
Depends: libc6
Depends: libncurses5
Depends: libtinfo5


**Sayfanın PDF versiyonuna erişmek için [buraya](lkk-kullanim.pdf) tıklayınız.**
