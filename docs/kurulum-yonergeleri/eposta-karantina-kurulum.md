
# E-Posta Karantina Kurulum Yönergesi


Bu dokümanda, Ahtapot projesi kapsamında e-posta karantina sunucusunun merkezi yönetim sisteminin ihtiyaçlarına cevap verecek şekilde nasıl kurulacağı anlatılmaktadır.

### E-Posta Karantina Sistemi Kurulum İşlemleri

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

* Gitlab arayüzünden mys resposundaki “**hosts**” dosyasında “**[mail-quarantine]**” fonksiyonu altına e-posta karantina sunucusunun FQDN bilgisi girilir.

```
[mail-quarantine]
quarantine.gdys.local
``` 

* Gitlab arayüzünden mys reposundaki  “**roles/base/vars/host.yml**” dosyasına e-posta karantina sunucusunun ip adresi, FQDN bilgisi ve hostname’i yeni bir server bloğu oluşturularak yazılır. 

```
serverN:
        ip: "X.X.X.X"
        fqdn: "quarantine.gdys.local"
        hostname: "quarantine"
```

Ardından e-posta karantina sistemi ile ilgili aşağıda tanımlanmış değişkenler açıklamalarda belirtilen şekilde uygun değerlerle doldurulur.

#### E-Posta Karantina Rolü Değişkenleri
Bu roldeki değişkenler “**/etc/ansible/roles/mail-quarantine/vars/**” dizini altında bulunan yml dosyalarında belirtilmiştir. yml dosyalarının içerikleri ve değişken bilgileri aşağıdaki gibidir;


-   “**main.yml**” dosyasında bulunan değişkenlerin görevi şu şekildedir. "**quarantine_mail_domain**" karantina sisteminin alan adının belirtildiği değişkendir. "**quarantine_subdomain_name**" karantina sisteminin alt alan adının belirtildiği değişkendir. .  "**quarantine_db_host**" karantina sunucusunun veritabanının IP adresinin belirtildiği değişkendir.  "**quarantine_db_user**" karantina sunucusunun veritabanının kullanıcı adının belirtildiği değişkendir.  "**quarantine_db_pass**" karantina sunucusunun veritabanının şifresinin belirtildiği değişkendir.  "**quarantine_db_root_user**" karantina sunucusunun veritabanının root kullanıcı adının belirtildiği değişkendir.  "**quarantine_db_root_pass**" karantina sunucusunun veritabanının root şifresinin belirtildiği değişkendir. 

```
quarantine_mail_domain: "mail.test.org"
quarantine_subdomain_name: "karantina"
quarantine_db_host: "127.0.0.1"
quarantine_db_user: "ahtapot"
quarantine_db_pass: "ahtapot"
quarantine_db_root_user: "root"
quarantine_db_root_pass: "root"
```


İlgili değişkenler ayarlandıktan sonra aşağıdaki komut ile e-posta karantina sunucusu kurulur.

```
ansible-playbook /etc/ansible/playbooks/mail-quarantine.yml
```

