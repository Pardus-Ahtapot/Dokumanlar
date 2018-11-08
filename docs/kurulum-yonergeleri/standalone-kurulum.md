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

* Gitlab arayüzünden mys resposundaki “**hosts**” dosyasında “**[standalone]**” fonksiyonu altına standalone sunucusunun FQDN bilgisi girilir.

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

* Uç cihazın git makinasından yapılandırmaları çekebilmesi için ssh key'inin git sunucusuna gönderilmesi gerekmektedir. **ssh-keygen** komutu ile key yaratılır.
```
$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:HlKd8jITJhVZ2zfu6DNbocrBLFkzli3ealfl0CRe8CM root@pardus
The key's randomart image is:
+---[RSA 2048]----+
|        o+.   .. |
|       ... +  ..o|
|      . = + .Eo*.|
|       + + o o+.+|
|      . S O . o+ |
|       o % = +...|
|        + = +.o  |
|         o.=+.   |
|         .+.o+   |
+----[SHA256]-----+
```
* Daha sonra **ssh-copy-id** komutu ile key sunucuya atılır.
```
$ ssh-copy-id kullanici@gitlabsunucuadresi
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
kullanici@gitlabsunucuadresi's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'kullanici@gitlabsunucuadresi'"
and check to make sure that only the key(s) you wanted were added.
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
