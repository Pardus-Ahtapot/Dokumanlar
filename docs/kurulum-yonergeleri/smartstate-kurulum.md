# Smartstate Kurulum Yönergesi
Bu dökümanda uç birimlerin periyodik olarak yapılandırmaları çekmesini sağlayan smartstate rolünün kurulumu anlatılmaktadır.

#### Smartstate Sistemi Kurulum İşlemleri 
* **NOT:** Dökümanda yapılması istenilen değişiklikler gitlab arayüzü yerine terminal üzerinden yapılması durumunda playbook oynatılmadan önce yapılan değişiklikler git'e push edilmelidir.

```
$ cd /etc/ansible
git status komutu ile yapılan değişiklikler gözlemlenir.
$ git status  
$ git add --all
$ git commit -m "yapılan değişiklik commiti yazılır"
$ git push origin master
```

* Gitlab adresine  bir web tarayıcı vasıtası ile girilerek Gitlab web arayüzüne “**https://gitlabsunucuadresi**” ile erişilir. 

* Gitlab arayüzünden mys resposundaki “**hosts**” dosyasında “**[smartstate]**” fonksiyonu altına smartstate sunucusunun FQDN bilgisi girilir.

```
[smartstate]
smartstate.gdys.local
```

* Gitlab arayüzünden mys reposundaki  “**roles/base/vars/host.yml**” dosyasına smartstate sunucusunun ip adresi, FQDN bilgisi ve hostname’i yeni bir server bloğu oluşturularak yazılır. 

```
serverN:
        ip: "X.X.X.X"
        fqdn: "smartstate.gdys.local"
        hostname: "smartstate"
```

Ardından smartstate sistemi ile ilgili aşağıda tanımlanmış değişkenler açıklamalarda belirtilen şekilde uygun değerlerle doldurulur.

#### Uç Sistemlere Değişen Yapılandırmaların Otomatik Olarak Yollaması
* Her bir commit sonrası değişen yapılandırmalar uç sistemlere merkezden aktarılmak isteniyorsa aşağıdaki komut MYS makinasında **.git/hooks/post-commit** dosyasına eklenerek her commit sonrası otomatik bir şekilde çağırılır.
```
/opt/ahtapot/smartstate.py --smart-push
```
* Her push sonrası smartstate hostlarının yapılandırmalarını çekmesi isteniyorsa aşağıdaki gibi bir alias eklenerek bu işlem yapılabilmektedir. 
```
$ git config alias.xpush '!git push $1 $2 && /opt/ahtapot/smartstate.py --smart-trigger'
```
Daha sonra push yapılmak istendiğinde **git push** yerine **git xpush** çağırılarak sistemler uyarılır ve yapılandırmaları çekerler. 

#### Smartstate Rolü Değişkenleri
Bu roldeki değişkenler “**/etc/ansible/roles/smartstate/vars/**” dizini altında bulunan **main.yml** dosyasında belirtilmiştir. Değişken bilgileri aşağıdaki gibidir;

- "**ansible_git_url**" değişkeni uç birimin pull ediceği ansible reposunu belirtir. 
"**gdys_git_url**" değişkeni uç birimin pull ediceği gdys reposunu belirtir. Firewall cihazları bu repodan değişiklik kontrolu yapmaktadır.
Uç birim ile git reposu arasında ssh yapılandırılması yapılmalıdır.
"**gitlab_api_url**" değişkeni gitlaba ssh key deploy etmek amacıyla kullanılacaktır.
"**gitlab_access_token**" değişkeni gitlab'a baglanabilmek icin kullanılacak tokendır. Kullanıcı bunu arayüzden yaratıp buraya ekler.  
"**gitlab_ssh_private_key_file**" değişkeni gitlaba baglanti icin kullanilan anahtardir.
"**branch**" değişkeni hangi git branch'ının kullanılacağını belirtir. 
"**ansible_directory**" ve "**gdys_directory**"değişkenleri ansible ve gdys repolarının nereye kaydedilmesi gerektiğini belirtir. Anbible için bu klasörun MYS cihazındaki ile aynı olması gerektiğine dikkat ediniz.
"**log_file**" değişkeni smartstate betiginin loglarını yazacağı dosyayı belirtir. 
"**script_file**" değişkeni smartstate betiginin nereye deploy edileceğini belirtir.
"**max_delay**" ve "**min_delay**" pull komutunun çalışmadan önce bu iki süre arasında rastgele olarak beklemesini sağlar. Dakika cinsinden girilmelidir.
"**cron_file**" cron yapılandırmalarının kaydedileceği dosyayı belirtir. 
"**mys_push**", "**mys_trigger**", "**host_pull**", "**mys_smartpush**", "**mys_smarttrigger**", "**host_smartpull**" değişkenlerinin altından pull, push, trigger, smartpull, smartpush ve smarttrigger komutları için cron yapılandırması yapılır. 
Pull host cihazlarda, push ve trigger ise mys üzerinde çalışır. Cron zamanlarının çakışmamasına dikkat edilmelidir.
"**not_pull_hosts**"" pull komutundan harici tutulacak hostları,
"**not_trigger_host**" trigger komutundan harici tutulacak hostları,
"**not_smartpull_hosts**"" smart pull komutundan harici tutulacak hostları,
"**not_smarttrigger_hosts**"" smart trigger komutundan harici tutulacak hostları belirtir.


```
smartstate:
  ansible_git_url: "git@10.0.0.200:labris/ansible.git"
  gdys_git_url: "git@10.0.0.200:labris/gdys.git"
  gitlab_api_url: "http://192.168.0.16/api/v3"
  gitlab_access_token: "szsYsEShyAx_UZL7s9X2"
  gitlab_ssh_private_key_file: "/home/ahtapotops/.ssh/id_rsa"
  branch: "master"
  ansible_directory: "/etc/ansible"
  gdys_directory: "/home/ahtapotops/gdys"
  log_file: "/var/log/ahtapot/smartstate.log"
  script_file: "/opt/ahtapot/smartstate.py"
  max_delay: "60"
  min_delay: "0"
  cron_file: "/etc/cron.d/smartstate"
  mys_push:
    cron_minute: "0"
    cron_hour: "5"
    cron_day: "*"

  mys_trigger:
    cron_minute: "0"
    cron_hour: "3"
    cron_day: "*/7"

  host_pull:
    cron_minute: "0"
    cron_hour: "6"
    cron_day: "*/7"

  mys_smartpush:
    cron_minute: "20"
    cron_hour: "*/5"
    cron_day: "*"

  mys_smarttrigger:
    cron_minute: "0"
    cron_hour: "*/4"
    cron_day: "*"

  host_smartpull:
    cron_minute: "15"
    cron_hour: "*/7"
    cron_day: "*"


  #not_pull_hosts:
    #- host1
    #- host2
    #- host3

  #not_trigger_hosts:
    #- host1
    #- host2
    #- host3

  #not_smartpull_hosts:
    #- host1
    #- host2
    #- host3

  #not_smarttrigger_hosts:
    #- host1
    #- host2
    #- host3

```

İlgili değişkenler ayarlandıktan sonra aşağıdaki komut ile smartstate yapılandırması aktarılır.

```
ansible-playbook /etc/ansible/playbooks/smartstate.yml
```
