# SKS Kurulum Yönergesi



Bu dokümanda, Ahtapot projesi kapsamında sks sunucusunun merkezi yönetim sisteminin ihtiyaçlarına cevap verecek şekilde nasıl kurulacağı anlatılmaktadır.

### SKS Sistemi Kurulum İşlemleri

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

* Gitlab arayüzünden mys resposundaki “**hosts**” dosyasında “**[sks]**” fonksiyonu altına antispam sunucusunun FQDN bilgisi girilir.

```
[sks]
sks.gdys.local
``` 

* Gitlab arayüzünden mys reposundaki  “**roles/base/vars/host.yml**” dosyasına sks sunucusunun ip adresi, FQDN bilgisi ve hostname’i yeni bir server bloğu oluşturularak yazılır. 

```
serverN:
        ip: "X.X.X.X"
        fqdn: "sks.gdys.local"
        hostname: "sks"
```

Ardından sks sistemi ile ilgili aşağıda tanımlanmış değişkenler açıklamalarda belirtilen şekilde uygun değerlerle doldurulur.
#### Sks Rolü Değişkenleri
Bu roldeki değişkenler “**/etc/ansible/roles/sks/vars/**” dizini altında bulunan yml dosyalarında belirtilmiştir. yml dosyalarının içerikleri ve değişken bilgileri aşağıdaki gibidir;

-   “**main.yml**” dosyasında bulunan değişkenlerin görevi şu şekildedir. "**sks_listen_ip**" değişkeni, pgpkeyserver-lite web uygulamasının nginx ile hangi IP üzerinden sunulacağının belirtildiği parametredir.  "**sks_server_name**" ise nginx uygulamasının sunuşacağı sunucunun adıdır.
```
---
sks_listen_ip: 169.254.1.9
sks_server_name: example.org

```

İlgili değişkenler ayarlandıktan sonra aşağıdaki komut ile sks sunucusu kurulur.

```
ansible-playbook /etc/ansible/playbooks/sks.yml
```

