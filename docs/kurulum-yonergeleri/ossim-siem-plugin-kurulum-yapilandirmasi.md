# OSSIM Üzerine Custom Plugin Yazılması ve Herhangi Bir log Kaynağının SIEM ile Entegre Edilmesi

----
Alien Vault OSSIM üzerinde özel plugin yazmak için aşağıdaki adımlar takip edilir.

[Test ISO](http://indir.pardus.org.tr/ISO/Ahtapot/pardus-ahtapot-ossim-kurumsal5-amd64.iso)
 

----
1- Plugin konfigurasyon dosyası (*plugin_adi.cfg*) plugin pathi altına kopyalanır.

**plugins pathi:**

    /etc/ossim/agent/plugins/

----
2- Plugin için veritabanı dosyası (*plugin_adi.sql*) sql pathine kopyalanir ve ossim-db aracını kullanarak veritabanına dahil edilir.

**sql pathi:**

    /usr/share/doc/ossim-mysql/contrib/plugins/

**ossim-db icin gerekli komut:**

    ossim-db < /usr/share/doc/ossim-mysql/contrib/plugins/plugin_adi.sql

----
3- OSSIM üzerinde syslog yapılandırması dosyasi (*plugin_adi.conf*) rsyslog pathine kopyalanir.

**rsyslog conf pathi:**

    /etc/rsyslog.d/


----
4- OSSIM üzerinde syslog rotate ayarlari dosyasi (*plugin_adi.log*) rotate pathine kopyalanir.

**rsyslog rotate pathi:**

    /etc/logrotate.d/

----
5- Rsyslog servisi yeniden başlatılır.


    systemctl restart rsyslog

----
6- "alienvault-setup" komutu ile Sensör ayarlarından plugin aktif edilir.


    alienvault-setup > configure sensor > configure data source plugins > [x] plugin_adi

----
7- Seçim yapıldıktan sonra geri ana ekrana dönülür ve seçim uygulanır.

    alienvault-setup > Apply all changes

----
8- OSSIM web arabirimiden kayıtlar izlenir.

    https://ossim_ip_address > Analysis > Security Events > Real Time
