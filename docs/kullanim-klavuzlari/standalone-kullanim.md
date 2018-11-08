# Standalone
Standalone, uç birimlerin yapılandırmalarını periyodik olarak çekmesi için tasarlanan playbook'tur. “**/etc/ansible/playbooks/**” dizini altında bulunan “**standalone.yml**” dosyasına bakıldığında, “**hosts**” satırında ansible’a ait “**/etc/ansible/**” altında bulunan “**hosts**” dosyasında “**[standalone]**” satırı altına yazılmış tüm sunucularda bu playbookun oynatılacağı belirtilir. “**sudo**” satırı ile çalışacak komutların sudo yetkisi ile çalışması belirlenir. “**vars_files**” satırı standalone playbookunun değişken dosyalarını belirtmektedir. “**roles**” satırı altında bulunan satırlarda ise bu playbook çalıştığında “**standalone**” rolünün çalışacağı belirtilmektedir.
```
- hosts: standalone  
  sudo: yes  
  vars_files:  
  - /etc/ansible/roles/standalone/vars/main.yml  
  roles:  
  - role: standalone
```
#### Standalone Rolü Değişkenleri
Bu roldeki değişkenler “**/etc/ansible/roles/standalone/vars/**” dizini altında bulunan **standalone.yml** dosyasında belirtilmiştir. Değişken bilgileri aşağıdaki gibidir;

- "**ansible_git_url**" değişkeni uç birimin pull ediceği repoyu belirtir. Uç birim ile git reposu arasında ssh yapılandırılması yapılmalıdır. "**branch**" değişkeni hangi git branch'ının kullanılacağını belirtir. "**directory**" değişkeni ansible resosunun nereye kaydedilmesi gerektiğini belirtir. Bu klasörun MYS cihazındaki ile aynı olması gerektiğine dikkat ediniz. "**cron_file**" cron yapılandırmalarının kaydedileceği dosyayı belirtir. "**cron_minute**" cron dakika yapılandırması, "**cron_hour**" cron saat yapılandırması, "**cron_day**" cron gün yapılandırmasıdır. 
"**hosts**" değişkeninin altında standalone hostlar yapılandırılır. "**host_fqdn**" cihazın fqdn'idir. "**role_dir**" değişkeni bu hostun rölüne ait klasördür. Bu değişken klasör adı olmalıdır çünkü playbook değişikliği bu değişken ile kontrol edilmektedir. "**playbook**" değişkeni bu hostta calıştırılacak playbooku belirtir. 


```
---  
standalone:  
  ansible_git_url: "ahtapotops@10.0.0.200:/srv/git/ansible.git"  
  branch: "master"  
  directory: "/etc/ansible"  
  cron_file: "/etc/cron.d/ahtapot-standalone"  
  cron_minute: "0"  
  cron_hour: "*/4"  
  cron_day: "*"  
  
  hosts:  
#   hostX:  
#     host_fqdn: myhost  
#     role_dir: ntp  
#     playbook: ntp.yml
```
