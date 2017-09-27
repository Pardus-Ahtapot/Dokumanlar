![ULAKBIM](../img/ulakbim.jpg)
#MYS Yapısında Test Sistemi Oluşturulması ve Kullanımı
------

[TOC]


Bu dökümanda Merkezi Yönetim Sistemi bileşenlerinde yapılacak değişikliklerin öncelikle test sistemlerinde uygulanması için gerekli yapı ve yapılandırması anlatılmaktadır.

####MYS Yapısında Test Sistemi Oluşturulması

* Merkezi Yönetim Sistemi ile kapsamında kullanılan sistemlerde canlı ortam üzerinde değişiklik yapmadan, test sistemleri üzerinde değişiklerin denenmesi için; "**/etc/ansible**" dizini altında bulunan "**hosts**" dosyası içerisine "**[test_grubu]**" satırı eklenmelidir. 
```
ahtapotops@: vi /etc/ansible/hosts

[test_grubu]
```
* Bu grup altına yazılan her bileşende belirlenen playbook oynatılarak, sistemin test edilmesi sağlanmaktadır.

####MYS Yapısında Test Sistemi Kullanılması

* **NOT:** Dökümanda yapılması istenilen değişiklikler gitlab arayüzü yerine terminal üzerinden yapılması durumunda playbook oynatılmadan önce yapılan değişiklikler git'e push edilmelidir.

```
$ cd /etc/ansible
git status komutu ile yapılan değişiklikler gözlemlenir.
$ git status  
$ git add --all
$ git commit -m "yapılan değişiklik commiti yazılır"
$ git push origin master
```

* Oluşturulan test yapısının kullanılması için öncelikle "**/etc/ansible/hosts**" dosyası içerisinde bulunan "**[test_grubu]**" satırı altında testi yapılmak için sunucu fqdn bilgisi yazılır. 
**NOT:** Dökümanda örnek olarak Proxy sunucusu kullanılmıştır.
```
ahtapotops@: vi /etc/ansible/hosts

[test_grubu]
proxy01.gdys.local
```

* Oluşturulan test grubunu bileşenlerinin playbook ile çalışmasını sağlamak üzere "**/etc/ansible/playbooks**" dizini altında bulunan ve her playbook için ayrı bir dosya bulunan playbook dosyasında bulunan "**hosts**" satırında bulunan host grubu kaldırılarak yerine "**test_grubu**" ibaresi yazılır.
```
---
# Calistirildiginda Web Proxy Kurulumu Yapilir
- hosts: test_grubu 
  remote_user: ahtapotops
  sudo: yes
  vars_files:
  - /etc/ansible/roles/base/vars/group.yml
  - /etc/ansible/roles/base/vars/user.yml
  - /etc/ansible/roles/base/vars/repo.yml
  - /etc/ansible/roles/base/vars/rsyslog.yml
  - /etc/ansible/roles/base/vars/ntp.yml
  - /etc/ansible/roles/base/vars/package.yml
  - /etc/ansible/roles/base/vars/blacklist.yml
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
  - /etc/ansible/roles/squid/vars/package.yml
  - /etc/ansible/roles/squid/vars/squid.yml
  - /etc/ansible/roles/squid/vars/dansguardian.yml
  - /etc/ansible/roles/squid/vars/updshalla.yml
  - /etc/ansible/roles/squid/vars/zeustracker.yml
  - /etc/ansible/roles/squid/vars/sarg.yml
  - /etc/ansible/roles/squid/vars/nginx.yml
  roles:
  - { role: base }
  - { role: squid }
```

* İlgili yapılandırma değişikleri ister gitlab arayüzü ister komut satırı üzerinden yapıldıktan sonra, test grubu üzerinde playbook oynatılır.
```
ansible-playbook playbooks/proxy.yml
```

* Test sistemi üzerinde playbook çalıştırıldıktan sonra, ilgili playbookun belirlenmiş canlı sistem üzerinde oynamaya devam etmesi için, **/etc/ansible/playbooks**" dizini altında bulunan ve her playbook için ayrı bir dosya bulunan playbook dosyasında bulunan "**hosts**" satırında bulunan host grubu kaldırılarak yerine "**proxy**" ibaresi yazılır.
```
---
# Calistirildiginda Web Proxy Kurulumu Yapilir
- hosts: proxy
  remote_user: ahtapotops
  sudo: yes
  vars_files:
  - /etc/ansible/roles/base/vars/group.yml
  - /etc/ansible/roles/base/vars/user.yml
  - /etc/ansible/roles/base/vars/repo.yml
  - /etc/ansible/roles/base/vars/rsyslog.yml
  - /etc/ansible/roles/base/vars/ntp.yml
  - /etc/ansible/roles/base/vars/package.yml
  - /etc/ansible/roles/base/vars/blacklist.yml
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
  - /etc/ansible/roles/squid/vars/package.yml
  - /etc/ansible/roles/squid/vars/squid.yml
  - /etc/ansible/roles/squid/vars/dansguardian.yml
  - /etc/ansible/roles/squid/vars/updshalla.yml
  - /etc/ansible/roles/squid/vars/zeustracker.yml
  - /etc/ansible/roles/squid/vars/sarg.yml
  - /etc/ansible/roles/squid/vars/nginx.yml
  roles:
  - { role: base }
  - { role: squid }
```

**Sayfanın PDF versiyonuna erişmek için [buraya](test-sistem.pdf) tıklayınız.**
