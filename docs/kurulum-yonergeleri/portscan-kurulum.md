# Portscanner Kurulum

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

* Tercih ettiğimiz metin düzenleyicisini kullanarak hosts dosyasını düzenliyoruz. Aşağıdaki örnekte vi kullanılır. Açılan dosyada [portscanner] kısmı altına portscanner makinesinin tam ismi (FQDN) girilir.

```
$ cd /etc/ansible/
$ sudo vi hosts
[portscanner]
portscanner.alan.adi
```

* Ansible makinesinin portscanner makinesine erişmesi için “roles/base/vars/host.yml” dosyası içerisine portscanner makinesinin bilgileri aşağıdaki gibi yazılır.

```
$ vi /etc/ansible/roles/base/vars/host.yml
    serverX:
        ip: "10.112.2.19"
        fqdn: "portscanner01.gdys.local"
        hostname: "portscanner01"
```
* "**/etc/ansible/roles/portscanner/vars**" dizininde Portscanner değişkenlerinin bulunduğu "**portscanner.yml**" dosyası içerisindeki "**target**" bölümüne hangi networkün tarancağı bilgisi girilmelidir.

```
$ vi /etc/ansible/roles/portscanner/vars/portscanner.yml
# Portscanner'in degiskenlerini iceren dosyadir
portscanner:
    conf:
        source: "portscan.conf.j2"
        destination: "/var/opt/portscan/portscan.conf"
        owner: "ahtapotops"
        group: "ahtapotops"
        mode: "0644"
    output_dir: "/var/opt/output/"
    log_dir: "/var/opt/portscan/"
    db_dir: "/var/opt/ahtapot-ps/"
    target: "172.16.0.0/24"
```

* "**/etc/ansible/roles/portscanner/vars**" dizininde nginx değişkenlerinin bulunduğu "**nginx.yml**" dosyası içerisindeki "**server_name**" bölümüne portscanner makinesinin fqdn bilgisi girilmelidir.

```
$ vi /etc/ansible/roles/portscanner/vars/nginx.yml
# Nginx'in degiskenlerini iceren dosyadir
nginx:
    conf:
        source: "portscanner.conf.j2"
        destination: "/etc/nginx/conf.d/portscanner.conf"
        owner: "root"
        group: "root"
        mode: "0644"
    portscanner:
        listen: "443"
        server_name: "portscanner01.gdys.local"
        access_log: "/var/log/nginx/portscanner-access.log"
        error_log: "/var/log/nginx/portscanner-error.log"
```

* "**Ansible Playbookları**" dokümanında detaylı anlatımı bulunan, sunucu üzerinde gerekli sıkılaştırma işlemleri ve Portscanner kurulumu yapacak olan "portscanner.yml" playbook’u çalıştırılır.

```
ansible-playbook playbooks/portscanner.yml
```

**Sayfanın PDF versiyonuna erişmek için [buraya](portscan-kurulum.pdf) tıklayınız.**
