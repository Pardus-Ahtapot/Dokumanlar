# Standalone Kurulum Yönergesi
Bu dökümanda uç birimlerin periyodik olarak yapılandırmaları çekmesini sağlayan standalone rolünün kurulumu anlatılmaktadır.

#### Standalone Sistemi Kurulum İşlemleri 
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

* Gitlab arayüzünden mys resposundaki “**hosts**” dosyasında “**[standalone]**” fonksiyonu altına balküpü sunucusunun FQDN bilgisi girilir.

```
[standalone]
standalone.gdys.local
```
* Eğer bu cihaz daha önce yapılandırılmış bir cihaz ise ve yapılandırmayı sadece kendi üzerinden alması isteniyorsa standalone dışındaki bütün gruplardan çıkarılmalıdır ve aşağıdaki adım atlanabilir.

* Gitlab arayüzünden mys reposundaki  “**roles/base/vars/host.yml**” dosyasına standalone sunucusunun ip adresi, FQDN bilgisi ve hostname’i yeni bir server bloğu oluşturularak yazılır. 

```
serverN:
        ip: "X.X.X.X"
        fqdn: "standalone.gdys.local"
        hostname: "standalone"
```

Ardından standalone sistemi ile ilgili aşağıda tanımlanmış değişkenler açıklamalarda belirtilen şekilde uygun değerlerle doldurulur.


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

İlgili değişkenler ayarlandıktan sonra aşağıdaki komut ile standalone yapılandırması aktarılır.

```
ansible-playbook /etc/ansible/playbooks/standalone.yml
```
