# Smartstate
Smartstate, uç birimlerin yapılandırmalarını periyodik olarak çekmesi için tasarlanan playbook'tur. “**/etc/ansible/playbooks/**” dizini altında bulunan “**smartstate.yml**” dosyasına bakıldığında, “**hosts**” satırında ansible’a ait “**/etc/ansible/**” altında bulunan “**hosts**” dosyasında “**[smartstate]**” satırı altına yazılmış tüm sunucularda bu playbookun oynatılacağı belirtilir. “**sudo**” satırı ile çalışacak komutların sudo yetkisi ile çalışması belirlenir. “**vars_files**” satırı smartstate playbookunun değişken dosyalarını belirtmektedir. “**roles**” satırı altında bulunan satırlarda ise bu playbook çalıştığında “**smartstate**” rolünün çalışacağı belirtilmektedir.
```
- hosts: smartstate  
  sudo: yes  
  vars_files:  
  - /etc/ansible/roles/smartstate/vars/main.yml  
  roles:  
  - role: smartstate
```
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

#### Smartstate betigi
Smartstate playbooku host cihazlara ve mys üzerine deploy ettiği **/opt/ahtapot/smartstate** betiği ile calışır.
Yardım menüsü aşağıdaki gibidir. 

```
~$ /opt/ahtapot/smartstate.py --help
usage: smartstate.py [-h] [--host HOST] [--smart-pull] [--pull] [--smart-push]
                     [--push] [--smart-trigger] [--trigger]
                     [--check-inventory] [--delay]

optional arguments:
  -h, --help         show this help message and exit
  --host HOST        fqdn of host that playbook will run on. Needed when pull
                     is used
  --smart-pull       Pull playbooks and run if needed. It should be run on
                     remote device
  --pull             Pull playbooks and run regardless it changes or not
  --smart-push       Push changed playbooks. It should be used on post-commit
                     hook
  --push             Push all playbooks
  --smart-trigger    Trigger host to run smart pull
  --trigger          Trigger host to run pull
  --check-inventory  Check inventory file too on smart pull and push
  --delay            Delay random time before run
```
