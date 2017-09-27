![ULAKBIM](../img/ulakbim.jpg)
# Ocswb Kurulum
------

[TOC]

------
* **NOT:** Dökümanda yapılması istenilen değişiklikler gitlab arayüzü yerine terminal üzerinden yapılması durumunda playbook oynatılmadan önce yapılan değişiklikler git'e push edilmelidir.

```
$ cd /etc/ansible
git status komutu ile yapılan değişiklikler gözlemlenir.
$ git status  
$ git add --all
$ git commit -m "yapılan değişiklik commiti yazılır"
$ git push origin master
```
**NOT:** Kurulacak sistem, SIEM yapısına dahil edilmek isteniyorsa, kurulum sonrasında Siber Olay, Açıklık, Risk İzleme ve Yönetim Sistemi Kurulumu sayfasında bulunan [LMYS Clientlarında Ossec Agent Dağıtımı](siem-kurulum.md) başlığı incelenmelidir.

* Tercih ettiğimiz metin düzenleyicisini kullanarak hosts dosyasını düzenliyoruz. Aşağıdaki örnekte vi kullanılır. Açılan dosyada [ocswb] kısmı altına ocswb makinesinin tam ismi (FQDN) girilir.

```
$ cd /etc/ansible/
$ sudo vi hosts
[ocswb]
ocswb01.gdys.local
```

* Ansible makinesinin ocswb makinesine erişmesi için “roles/base/vars/host.yml” dosyası içerisine portscanner makinesinin bilgileri aşağıdaki gibi yazılır.

```
$ vi /etc/ansible/roles/base/vars/host.yml
    serverX:
        ip: "10.112.2.18"
        fqdn: "ocswb01.gdys.local"
        hostname: "ocswb01"
```
* "**/etc/ansible/roles/ocswb/vars**" dizininde Ocswb değişkenlerinin bulunduğu "**ocswb.yml**" dosyası içerisindeki "**host**" bölümüne ocswb makinesinin mysql bilgilerine erişecek Ossim makinesinin ip bilgisi, "**user**" bölümüne ossim makinesin mysql user bilgisi, "**password**" bölümüne mysql kulanıcı parolası "**db_name**" bölümüne mysql database adı girilmelidir. Ossim makinesinin "**ocs**" mysql kullanıcı parolasına ossim makinesi içerisinde "**/etc/ocsinventory/dbconfig.inc.php**" dosyasında "PSWD_BASE" değişkeni olarak verilmiştir. 

```
$ vi /etc/ansible/roles/ocswb/vars/ocswb.yml
---
# Ocswb'in degiskenlerini iceren dosyadir
ocswb:
    conf:
        source: "ocswb.config.ini.j2"
        destination: "/var/opt/ahtapot-ocs-wb/config.ini"
        owner: "ahtapotops"
        group: "ahtapotops"
        mode: "0644"
    host: "ossim_fqdn"
    user: "ocs"
    password: "tIOlsKbkhKc93XNV"
    db_name: "ocsweb"
```

* "**/etc/ansible/roles/ocswb/vars**" dizininde Ocswb alarm değişkenlerinin bulunduğu "**ocswbalarm.yml**" dosyası içerisindeki "**host**" bölümüne ocswb makinesinin mysql bilgilerine erişecek Ossim makinesinin ip bilgisi, "**user**" bölümüne ossim makinesin mysql user bilgisi, "**password**" bölümüne mysql kulanıcı parolası "**db_name**" bölümüne mysql database adı girilmelidir.

```
$ vi /etc/ansible/roles/ocswb/vars/ocswbalarm.yml
---
# Ocswbalarm'in degiskenlerini iceren dosyadir
ocswbalarm:
    conf:
        source: "ocswbalarm.config.ini.j2"
        destination: "/var/opt/ahtapot-ocs-wb-alarm/config.ini"
        owner: "ahtapotops"
        group: "ahtapotops"
        mode: "0644"
    host: "ossim_fqdn"
    user: "ocs"
    password: "tIOlsKbkhKc93XNV"
    db_name: "ocsweb"
    sqlite_db: "i/var/opt/ahtapot-ocs-wb/db.sqlite3"
```

* "**/etc/ansible/roles/ocswb/vars**" dizininde nginx değişkenlerinin bulunduğu "**nginx.yml**" dosyası içerisindeki "**server_name**" bölümüne ocswb arayüzünün hangi url ile açılacağı bilgisi yada fqdn girilir.

```
$ vi /etc/ansible/ocswb/base/vars/nginx.yml
---
# Nginx'in degiskenlerini iceren dosyadir
nginx:
    conf:
        source: "ocswb.conf.j2"
        destination: "/etc/nginx/conf.d/ocswb.conf"
        owner: "root"
        group: "root"
        mode: "0644"
    ocswb:
        listen: "443"
        server_name: "ocswb.gdys.local"
        access_log: "/var/log/nginx/ocswb-access.log"
        error_log: "/var/log/nginx/ocswb-error.log"
```

* "**Ansible Playbookları**" dokümanında detaylı anlatımı bulunan, sunucu üzerinde gerekli sıkılaştırma işlemleri ve Portscanner kurulumu yapacak olan "**ocswb.yml**" playbook’u çalıştırılır.

```
ansible-playbook playbooks/ocswb.yml
```
**Sayfanın PDF versiyonuna erişmek için [buraya](ocswb-kurulum.pdf) tıklayınız.**
