﻿# Antispam
Ahtapot projesi kapsamında Antispam işlevinin kurulumunu ve yönetimini sağlayan playbook’dur. “**/etc/ansible/playbooks/**” dizini altında bulunan “**antispam.yml**” dosyasına bakıldığında, “**hosts**” satırında Ansible’a ait “**/etc/ansible/**” altında bulunan “**hosts**” dosyasında “**[antispam]**” satırı altına yazılmış tüm sunucularda bu playbookun oynatılacağı belirtilir. “**sudo**” satırı ile çalışacak komutların sudo yetkisi ile çalışması belirlenir. “**vars_files**” satırı antispam playbookunun değişken dosyalarını belirtmektedir. “**roles**” satırı altında bulunan satırlarda ise bu playbook çalıştığında “**base**” ve “**spamassassin**”rollerinin çalışacağı belirtilmektedir.


```
- hosts: antispam
  sudo: yes
  vars_files:
  - /etc/ansible/roles/base/vars/group.yml
  - /etc/ansible/roles/base/vars/user.yml
  - /etc/ansible/roles/base/vars/repo.yml
  - /etc/ansible/roles/base/vars/rsyslog.yml
  - /etc/ansible/roles/base/vars/ntp.yml
  - /etc/ansible/roles/base/vars/package.yml
  - /etc/ansible/roles/base/vars/kernelmodules_remove.yml
  - /etc/ansible/roles/base/vars/kernelmodules_blacklist.yml
  - /etc/ansible/roles/base/vars/host.yml
  - /etc/ansible/roles/base/vars/audit.yml
  - /etc/ansible/roles/base/vars/sudo.yml
  - /etc/ansible/roles/base/vars/ssh.yml
  - /etc/ansible/roles/base/vars/grub.yml
  - /etc/ansible/roles/base/vars/logger.yml
  - /etc/ansible/roles/base/vars/logrotate.yml
  - /etc/ansible/roles/base/vars/directory.yml
  - /etc/ansible/roles/base/vars/profile.yml
  - /etc/ansible/roles/base/vars/fusioninventory.yml
  - /etc/ansible/roles/spamassassin/vars/main.yml

  roles:
    - role: base
    - role: spamassassin


```

#### Spamassassin Rolü Değişkenleri
Bu roldeki değişkenler “**/etc/ansible/roles/spamassassin/vars/**” dizini altında bulunan yml dosyalarında belirtilmiştir. yml dosyalarının içerikleri ve değişken bilgileri aşağıdaki gibidir;

-   “**main.yml**” dosyasında bulunan değişkenlerin görevi şu şekildedir. "**antispam_smtpd_tls_cert_file**" değişkeni, mail sunucusunda oluşturulup, antispam sistemine aktarılan cert dosyasının bulunduğu dosya yolunu belirtmektedir. "**antispam_smtpd_tls_key_file**" değişkeni, mail sunucusunda oluşturulup, antispam sistemine aktarılan key dosyasının bulunduğu dosya yolunu belirtmektedir. "**antispam_smtpd_tls_CAfile**" değişkeni, mail sunucusunda oluşturulup, antispam sistemine aktarılan CA dosyasının bulunduğu dosya yolunu belirtmektedir. "**antispam_avas_hostname**" değişkeni antispam sisteminin bilgisayar adının (hostname) belirtildiği değikendir. "**antispam_domain**" değişkeni antispam sisteminin bulunduğu alanın adının belirtildiği değişkendir.  "**antispam_inet_protocols**" değişkeni antispam sisteminin çalışacağı IP protokolünün belirtildiği değişkendir. ipv4, ipv6 veya all yazılabilir. "**antispam_nameserver**" değişkeni antispam sistemi tarafından kullanılacak DNS sunucusunun belirtildiği değişkendir. "**clamav_check_freq**" clamav veritabanı güncelliğinin bir gün içinde kaç kez kontrol edileceğinin belirtildiği değişkendir. "**clamav_mirror**" clamav'ın hangi sunuculardan güncelleme alacağının belirtildiği değişkendir. "**spam_regexes**" altına tek tek spam olarak algılanması istenen düzenli ifadeler eklenmelidir. Burada "**name**" kullanıcı tarafından belirlenen ayırt edici bir isimdir. "**where**" ise bu düzenli ifadenin mailin hangi kesiminde aratılacağının belirtildiği parametredir. "**regex**" istenen düzenli ifadenin yazıldığı parametredir. "**score**" parametresi spamassasin tarafından bu düzenli ifadeye uyan bir e-postaya kaç skor verileceğinin belirlendiği parametredir. "**describe**" parametresi ise bu düzenli ifade kuralının açıklamasının yazıldığı parametredir.

```
---
antispam_smtpd_tls_cert_file: /etc/postfix/ssl/smtpd.crt
antispam_smtpd_tls_key_file: /etc/postfix/ssl/smtpd.key
antispam_smtpd_tls_CAfile: /etc/postfix/ssl/cacert.pem
antispam_avas_hostname: avas
antispam_domain: ahtapot
antispam_inet_protocols: ipv4 #ipv4, ipv6, all
antispam_nameserver: 8.8.8.8
clamav_check_freq: 24
clamav_mirrors:
  - db.local.clamav.net
  - database.clamav.net
spam_regexes:
  - name: PORN
    where: full
    regex: /porn/i
    score: 20
    describe: Spam Warning
```


**Not:** Antispam sistemi kurulmadan önce yukarıda belirtilen tls sertifika dosylaraı mail sunucuda oluşturulup, antispam sunucusuna kopyalanmalıdır. Kopyalanan doısya yolları ise yukarıda belirtilen tls ile ilgili parametrelere girilmelidir. Bu dosyaların mail sunucu üzerinde oluşturulması için örnek komutlar ise şu şekildedir:
```
mkdir /etc/postfix/ssl
cd /etc/postfix/ssl/
openssl genrsa -des3 -rand /etc/hosts -out smtpd.key 2048

chmod 600 smtpd.key
openssl req -new -key smtpd.key -out smtpd.csr

openssl x509 -req -days 3650 -in smtpd.csr -signkey smtpd.key -out smtpd.crt

openssl rsa -in smtpd.key -out smtpd.key.unencrypted

mv -f smtpd.key.unencrypted smtpd.key
openssl req -new -x509 -extensions v3_ca -keyout cakey.pem -out cacert.pem -days 3650
chmod 600 cakey.pem
```
