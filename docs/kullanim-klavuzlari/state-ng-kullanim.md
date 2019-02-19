# State-ng
State-ng, uç birimlerin yapılandırmalarını periyodik olarak çekmesi için tasarlanan playbook'tur. “**/etc/ansible/playbooks/**” dizini altında bulunan “**state-ng.yml**” dosyasına bakıldığında, “**hosts**” satırında ansible’a ait “**/etc/ansible/**” altında bulunan “**hosts**” dosyasında “**[state-ng]**” satırı altına yazılmış tüm sunucularda bu playbookun oynatılacağı belirtilir. “**sudo**” satırı ile çalışacak komutların sudo yetkisi ile çalışması belirlenir. “**vars_files**” satırı state-ng playbookunun değişken dosyalarını belirtmektedir. “**roles**” satırı altında bulunan satırlarda ise bu playbook çalıştığında “**state-ng**” rolünün çalışacağı belirtilmektedir.
```
- hosts: state-ng  
  sudo: yes  
  vars_files:  
  - /etc/ansible/roles/state-ng/vars/main.yml  
  roles:  
  - role: state-ng
```
#### State-ng Rolü Değişkenleri
Bu roldeki değişkenler “**/etc/ansible/roles/state-ng/vars/**” dizini altında bulunan **state-ng.yml** dosyasında belirtilmiştir. Değişken bilgileri aşağıdaki gibidir;

- "**ansible_git_url**" değişkeni uç birimin pull ediceği ansible reposunu belirtir. 
"**gdys_git_url**" değişkeni uç birimin pull ediceği gdys reposunu belirtir. Firewall cihazları bu repodan değişiklik kontrolu yapmaktadır.
Uç birim ile git reposu arasında ssh yapılandırılması yapılmalıdır. 
"**branch**" değişkeni hangi git branch'ının kullanılacağını belirtir. 
"**ansible_directory**" ve "**gdys_directory**"değişkenleri ansible ve gdys repolarının nereye kaydedilmesi gerektiğini belirtir.
 Anbible için bu klasörun MYS cihazındaki ile aynı olması gerektiğine dikkat ediniz. 
 "**cron_file**" cron yapılandırmalarının kaydedileceği dosyayı belirtir. 
 "**cron_minute**" cron dakika yapılandırması, 
 "**cron_hour**" cron saat yapılandırması, 
 "**cron_day**" cron gün yapılandırmasıdır.
 "**pull_hosts**" değişkenine eklenen hostlar yapılandırmalarını otomatik olarak cron ile alır. Öntanımlı olarak kapalıdır.  


```
state_ng:
  ansible_git_url: "ahtapotops@10.0.0.200:/srv/git/ansible.git"
  gdys_git_url: "ahtapotops@10.0.0.200:/srv/git/gdys.git"
  branch: "master"
  ansible_directory: "/etc/ansible"
  gdys_directory: "/home/ahtapotops/gdys"
  mys:
    cron_file: "/etc/cron.d/ahtapot-stateng"
    cron_minute: "0"
    cron_hour: "*/4"
    cron_day: "*"
  host:
    cron_file: "/etc/cron.d/ahtapot-stateng"
    cron_hour: "*/4"
    cron_day: "*"

  #pull_hosts:
    #- host1
    #- host2
    #- host3

```
