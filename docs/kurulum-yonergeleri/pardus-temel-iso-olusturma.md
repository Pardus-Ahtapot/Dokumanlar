![ULAKBIM](../img/ulakbim.jpg)
# Pardus Temel ISO Yapım Yönergesi
------

[TOC]

------

Bu dokümanda, Ahtapot projesi kapsamında kullanılan Pardus Temel ISO yapımı anlatılmaktadır.

* Iso build işlemi yapılacak olan sunucuya bağlanılır.

* Build için gerekli olan yapılandırma dosyaları Pardus git deposundan alınır. Güncel ve geliştirilmekte olan yapılandırma dosyaları "**development**" branchinde "**ahtapot_build**" dizini altında yer almaktadır.

```
# git clone https://git.pardus.org.tr/ahtapot/Gereksinimler.git
# cd Gereksinimler/
# git checkout development
# cd files/ahtapot_build
```
* Dizinde bulunan "**build.sh**" betiği çalıştırılır. Betiğin çalışması tamamlandıktan sonra aynı dizinde "**LIVE**" adlı bir dizin oluşacaktır. Yeni üretilen iso bu dizin altında "**live-image-amd64.iso**" adıyla yer almaktadır.

```
# ./build.sh
```
**Sayfanın PDF versiyonuna erişmek için [buraya](pardus-temel-iso-olusturma.pdf) tıklayınız.**
