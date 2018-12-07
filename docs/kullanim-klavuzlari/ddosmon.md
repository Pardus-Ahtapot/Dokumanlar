# DDOSMON Kullanımı

DDOSMON aracı ile sunucu üzerine gelen trafik içerisinde aşağıdaki tiplerde saldırı tipleri monitor edilebilir.

-   SYN Flood
-   UDP Flood
-   ICMP Flood

## DDOSMON Kurulum ve Ayarları

**DDOSMON paketi kurulur.**

```
apt install ddosmon mysql mysql-client
```

>Eğer mysql server aynı cihazda olmayacak ise sadece mysql-client kurulur. Aynı cihazda olacak ise mysql kurulması yeterlidir.  
>Ayrıca mysql-client'i ipblock script'i kullanıyor. Eğer ipblock script'i kullanılmayacak ise mysql-client'in kurulmasına da gerek yok.

**Mysql DB import edilir**

```
mysql -u root -p < /usr/share/doc/ddosmon/ddosmon_db.sql
```

**Ayar dosyası oluşturulur**

```
cp /etc/ddosmon/example.lua cp /etc/ddosmon/config.lua
```
Aşağıdaki ayar dosyası istenilen değerlere göre düzenlenir.

**Interface** kısmı ayarlanarak hangi interface üzerinde çalışacağı belirlenir.

```
interface = "eth0"
global_traffic_threshold = 900000
global_packets_threshold = 30
ip_traffic_threshold = 500000
ip_packets_threshold = 125000
notification_traffic_threshold = 20000
notification_packets_threshold = 30
ipblock_retry_ticks = 5*3600*1000
notification_command = "/usr/sbin/notificate \"%1%\" \"%2%\" &"
onblockip_command = "/usr/sbin/ipblock block %1% &"
onunblockip_command = "/usr/sbin/ipblock unblock %1% &"
network_uncompromise_ticks = 30
onnetwork_compromise_command = "/usr/sbin/networkcompromise compromised &"
onnetwork_uncompromise_command = "/usr/sbin/networkcompromise uncompromised &"
log="/var/log/ddosmon/ddosmon.log"
watchedips="/etc/ddosmon/example_watchedips.xml"
notificationsubject="DDOS Monitor on server1 notification"
```
Ayar dosyasında belirlenen **watchedips** dosyasında hangi IP adreslerine gelen trafiği montior edeceği bilirlenir.

/etc/ddosmon/example_watchedips.xml

```
<?xml version="1.0"?>
<watchedips>
    <ip interface="eth0" ip="169.254.2.254"/>
</watchedips>
```

**Veri tabanı ayarları**

/etc/ddosmon/ip_block.conf

```
#Database configurations
MYSQL_HOST="localhost"
MYSQL_PORT="3306"
MYSQL_USER="root"
MYSQL_PASSWORD=""
MYSQL_DATABASE="ddosmon"
WATCHEDIPS_XML="/etc/ddosmon/*.xml"
```

**Servis başlatılır**

```
systemctl start ddosmon
```

## Test

Test için aynı cihaz üzerinde nginx kurulabilir.

```
apt install nginx
```

Saldırı yapılacak sistem üzerinde hping3 kurulur.

Aşağıdaki komut ile faklı bir sistem üzerinden atak başlatılır. (apt install hping3)

```
hping3 -S --flood -V -p 80 hedef_ip_address
```

Loglar aşağıdaki dosyadan izlenebilir.

```
tail -f /var/log/ddosmon/ddosmon.log
```

>Sistem Attak algıladığında config.lua içinde belirtilen onblockip_command ile tanımlanmış script'i çağırır. Bu script ile istenilen engelleme yapılabilir.  

>Hali hazırda tanımlı olan onblockip_command (ipblcok) script'i sadece mysql'e kayıt ekler, herhangi bir engelleme yapmaz.

> **Önemli Not:** Normal şartlarda onblockip_command ile tanımlanan script'e saldırıyı yapan ip adresini vermesi gerekiyorken saldırılan hedef ip adresini yani watchedips.xml içinde tanımlı olan ip adresini vererek kendisinin engellenmesine sebep olabiliyor. Bunun bir **BUG** olduğu değerlendirildi.
Projenin çok eskide kaldığı ve geliştirilmediği göz önüne alındığında çok verimli bir sonuç elde edilemeyeceği görülüyor.
En son commit 2013 yılında yapılmış. Ancak bu commit de projenin github'a yüklendiği tarih olarak gözüküyor.  
github sayfasında yazan aşağıdaki mesajda kodun çok daha eski olduğu görülüyor.
"Another old project that I've found lost in an old HD, DDOS Monitor"
