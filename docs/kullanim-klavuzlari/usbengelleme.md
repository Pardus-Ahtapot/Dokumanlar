![ULAKBIM](../img/ulakbim.jpg)
#Sistemler Üzerinde USB Kullanımını Engelleme
------

[TOC]


Bu dökümanda Merkezi Yönetim Sistemi bileşenlerinde USB kullaımının engellenmesi anlatılmaktadır.

####Sistemler Üzerinde MYS ile USB Kullanımını Engelleme

* GitLab arayüzünde "**roles/base/vars/**" klasörü altında bulunan "**blacklist.yml**" dosyası karaliste çekirdek modüllerini içeren dosyadır. "**name**" satırı “**usb-storage**” olan **module01**'de sistemlerdeki usb kapılarının kapanması sağlanır. “**/etc/ansible/roles/base/templates**” dizini altında bulunan “**blacklist.conf.j2**” dosyasındaki izin verilmeyecek durumları modprobe’a yazar.

```
# Karaliste cekirdek modullerini iceren dosyadir.
# Yorum satiri ile gosterilen sablon doldurularak karalisteye istenilen kadar cekirdek modulu eklenebilir.
# Usb belleklerin calismasi icin gerekli olan modul bu sekilde karalisteye eklenmektedir

blacklists:
    conf:
        source: "blacklist.conf.j2"
        destination: "/etc/modprobe.d/blacklist.conf"
        owner: "root"
        group: "root"
        mode: "0644"


base_blacklist_modules:
    module01:
        name: "usb_storage"
        state: "absent"
#    moduleXX:
#        name:
#        state:
```

* USB engellerini kaldırmak için "**blacklist.yml**" dosyasında "**module01**" başlığı altından "**usb_storage**" modülünün kaldırılması yeterli olacaktır.

####Sistemler Üzerinde El ile USB Kullanımını Engelleme

* Sistemler üzerinde USB kullanımı el ile engellenmek istenildiğinde sunucuya bağlantı sağlanarak "**/etc/modprobe.d**" dizini altında "**blacklist.conf**" adında bir dosya oluşturulur. Ve içerisine "**usb_storage**" ibaresi yazılır.
```
ahtapotops@: sudo vi /etc/modprobe.d/blacklist.conf

usb_storage
```

* USB engellerini kaldırmak için "**blacklist.conf**" dosyasında "**usb_storage**" satırının kaldırılması yeterli olacaktır.

**NOT:** Ansible ile yönetilen sistemlerde el ile değişiklik yapıldığı durumlarda, "**state.yml**" ve ya ilgili playbook çalışır ise, base playbooku içerisinde bulunan blacklist bilgileri el ile yapılan ayarların üzerine yazılacaktır.

**Sayfanın PDF versiyonuna erişmek için [buraya](usbengelleme.pdf) tıklayınız.**
