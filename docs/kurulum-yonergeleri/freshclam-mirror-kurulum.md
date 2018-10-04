# Freshclam-mirror Kurulum Yönergesi



Bu dokümanda, Ahtapot projesi kapsamında freshclam-mirror sunucusunun merkezi yönetim sisteminin ihtiyaçlarına cevap verecek şekilde nasıl kurulacağı anlatılmaktadır.

### Freshclam-mirror Sistemi Kurulum İşlemleri

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
[freshclam-mirror]
freshclam-mirror.gdys.local
``` 

* Gitlab arayüzünden mys reposundaki  “**roles/base/vars/host.yml**” dosyasına freshclam-mirror sunucusunun ip adresi, FQDN bilgisi ve hostname’i yeni bir server bloğu oluşturularak yazılır. 

```
serverN:
        ip: "X.X.X.X"
        fqdn: "sks.gdys.local"
        hostname: "sks"
```

Ardından freshclam-mirror sistemi ile ilgili aşağıda tanımlanmış değişkenler açıklamalarda belirtilen şekilde uygun değerlerle doldurulur.
#### Freshclam-mirror Rolü Değişkenleri
Bu roldeki değişkenler “**/etc/ansible/roles/freshclam-mirror/vars/**” dizini altında bulunan yml dosyalarında belirtilmiştir. yml dosyalarının içerikleri ve değişken bilgileri aşağıdaki gibidir;

-   “**main.yml**” dosyasında bulunan değişkenlerin görevi şu şekildedir. "**freshclam_cron_string**" değişkeni, clamav sunucularından ne sıklıkla güncellemelerin alınıp mirrorlanacağının belirtildiği cron syntaxına uygun yazılması gereken değişkendir.
```
---
freshclam_cron_string: "30 * * * *"

```

İlgili değişkenler ayarlandıktan sonra aşağıdaki komut ile freshclam-mirror sunucusu kurulur.

```
ansible-playbook /etc/ansible/playbooks/freshclam-mirror.yml
```

