# Ahtapot Projesi Güvenlik Yapılandırma Dökümanı
Bu dokümanda Ahtapot projesinde ki güvenlik playbook ve ayar yapılandırma adımlarından bahsedilmiştir.

## ISO Kurulumu

Uç makinaların iso kurulumu sırasında aşağıdaki her bir klasor için disk boyutlarını ihtiyaca göre belirleyip farklı bölüm yaratınız. Bu sayede bu bolümlerin farkında olmadan kaynak harcamasının önüne geçilmiş olur. 
* /tmp 
* /var
* /var/log
* /var/log/audit
* /home

## Playbook yapılandırmaları
Security playbook base rolu içindedir ve yapılandırmaları  **roles/base/vars/security.yml** dosyasında yeralmaktadır. 

### IPv6
Security playbooku default olarak IPv6 yı bütün hostlarda kapatır. Eğer bir hostda IPv6 aktif edilmek isteniyorsa vars aşağıdaki örnekteki gibi yapılandırılır. 
```
ipv6_hosts:
    - host1
    - host2
```
### İzinli host IP adreslerini tanımlama
Cihazın güvenlik seviyesini arttırmak adına uç makinelere sadece izinli IP addresslerinin bağlanmasını sağlar. Bu özellik varsayılan olarak kapalıdır. Aktif etmek için aşağıdaki örnekteki gibi yapılandırınız. 

```
host_access:
    allowed_hosts: "192.168.0.0/255.255.255.0, 10.0.0.0/255.0.0.0, 172.16.0.0/255.240.0.0"
    deny_all: "yes"
```

### Kullanıcı şifre ve giriş seçenekleri
Bu ayarlar sistem kullanıcıların şifrelerinin karakter özelliklerini belirler. Varsayılan ayarlar aşağıdaki gibidir. İstenildigi taktirde değiştirilebilir.

```
pam:
    password_file: "/etc/pam.d/common-password"	   
    password_setting: "password required pam_cracklib.so retry=3 minlen=14 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1"
    password_reuse_policy: "password [success=1 default=ignore] pam_unix.so obscure sha512 remember=5"
    
    login_file: "/etc/pam.d/login"
    login_setting: "auth required pam_tally2.so onerr=fail audit silent deny=5 unlock_time=900"

    su_file: "/etc/pam.d/su"
    su_setting: "auth required pam_wheel.so use_uid"

login_definitions:
    lock_inactive_user_account: "90"
    settings:
        PASS_MAX_DAYS: "90"
        PASS_MIN_DAYS: "7"
        PASS_WARN_AGE: "7"
```
**password_setting:** Bu değişken şifrelerin karakterini belirler. Varsayılan ayarlar aşağıdaki gibidir.

* **retry=3** - Sifreyi 3 kere denemeye izin ver.
* **minlen=14** - şifre en az 14 karakter olmalı
* **dcredit=-1** - en az bir rakam içermeli
* **ucredit=-1** - en az 1 büyük harf içermeli
* **ocredit=-1** - en az 1 özel karakter içermeli
* **lcredit=-1** - en az 1 küçük harf içermeli 

**password_reuse_policy:** Şifre tekrar kullanma politikasını belirler. Varsayılan olarak son 5 şifrenin kullanılması engellenmiştir.

**login_setting:** Yanlış şifre denemesi sonrası uygulanıcak politikayı belirler. Varsayılan olarak 5 yanlış deneme sonrası 900 saniye bloklanma uygulanmıştır. 

**su_setting**: Bu parametre ile **su** komutunun kullanımı kısıtlanır. Kullanıcı sudo komutu kullanmak zorundadır. 

**lock_inactive_user_account:** Bu süre boyunca inaktif olan kullanıcıları inaktif eder. Varsayılan değer 90 gündür. 

**PASS_MAX_DAYS:** Kullanıcı şifrelerinin maximum kullanılma süresini belirtir. Bu süre doldugunda şifrelerini yenilemek zorundadırlar. Varsayılan değer 90 gündür.

**PASS_MIN_DAYS:** Kullanıcı şifre değişikliği arasındaki minimum süreyi belirtir. Varsayılan değer 7 gündür.

**PASS_WARN_AGE:** Şifre değiştirme uyarısının kaç gün önceden başlaması gerektiğini belirtir. Varsayılan değer 7 gündür. 

Aşağıdaki komut ile kullanıcıların aktivite bilgileri görüntülenebilir. 
```
#chage --list <kullanici> 
```

### Cron erişim izinleri
Cron dosyalarına varsayılan olarak sadece **root** ve **ahtapotops** kullanıcılarının değiştirmesine izin verilmiştir. Bu ayar aşağıdaki parametre ile değiştirilebilir.

```
cron_configuration:
    allowed_users:
        - root
        - ahtapotops
```

### Sysctl yapılandırmaları
Güvenlik için uygulanan sysctl yapılandırmaları **/etc/sysctl.d/ahtapotbase.conf** dosyasına yazılır. Yeni bir parametre eklenmek istenirse aşağıdaki gibi eklenir.
```
#Onemli not: Eger burdaki bir parametre baska bir host grubunda farklı olması gerekiyorsa, o parametre icin ayri bir task yaziniz.
sysctl:
    settings:
        fs.suid_dumpable: 0
        kernel.randomize_va_space: 2
        net.ipv4.conf.all.accept_redirects: 0
        net.ipv4.conf.default.accept_redirects: 0
        net.ipv4.conf.all.log_martians: 1
        net.ipv4.conf.default.log_martians: 1
        net.ipv4.icmp_echo_ignore_broadcasts: 1
        net.ipv4.icmp_ignore_bogus_error_responses: 1
        net.ipv4.tcp_syncookies: 1
        net.ipv6.conf.all.accept_ra: 0
        net.ipv6.conf.default.accept_ra: 0
        net.ipv6.conf.all.accept_redirects: 0
        net.ipv6.conf.default.accept_redirects: 0
    #   key: value
  ```
   
   ### Deaktif edilmesi gereken servisler
   Sistemde çalışması istenmeyen servisler security playbook tarafından durdurulur. Varsayılan olarak aşağıdkai gibidir. Yeni servisler eklenebilir.
```
services:
    service1: avahi-deamon
    service2: cups
    service3: dovecot
```

### SSH yapılandırması
SSH güvenliğini arttıkmak amacıyla **roles/base/vars/security.yml** dosyasında aşağıdaki parametreler ile cihaza bağlantılar kısıtlanabilir. Varsayılan olarak bir kısıtlama yoktur.
```
ssh:
    AllowUsers: ""
    AllowGroups: ""
    DenyUsers: ""
    DenyGroups: ""
```

