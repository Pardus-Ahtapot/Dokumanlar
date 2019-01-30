
# MHN Kurulum Yönergesi


Bu dokümanda, Ahtapot projesi kapsamında Mhn sunucusunun merkezi yönetim sisteminin ihtiyaçlarına cevap verecek şekilde nasıl kurulacağı anlatılmaktadır.

### MHN Sistemi Kurulum İşlemleri

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

* Gitlab arayüzünden mys resposundaki “**hosts**” dosyasında “**[mhn]**” fonksiyonu altına mhn sunucusunun FQDN bilgisi girilir.

```
[mhn]
mhn.gdys.local
``` 

* Gitlab arayüzünden mys reposundaki  “**roles/base/vars/host.yml**” dosyasına mhn sunucusunun ip adresi, FQDN bilgisi ve hostname’i yeni bir server bloğu oluşturularak yazılır. 

```
serverN:
        ip: "X.X.X.X"
        fqdn: "mhn.gdys.local"
        hostname: "mhn"
```

Ardından mhn sistemi ile ilgili aşağıda tanımlanmış değişkenler açıklamalarda belirtilen şekilde uygun değerlerle doldurulur.

#### MHN Rolü Değişkenleri
Bu roldeki değişkenler “**/etc/ansible/roles/mhn/vars/**” dizini altında bulunan yml dosyalarında belirtilmiştir. yml dosyalarının içerikleri ve değişken bilgileri aşağıdaki gibidir;


-   “**main.yml**” dosyasında bulunan değişkenlerin görevi şu şekildedir. "**mhn_email**" değişkeni, mhn arayüzüne giriş için kullanılacak e-posta adresidir. Aynı zamanda mhn tarafından yollanan e-postalar bu adrese gönderilmektedir. "**mhn_password**" değişkeni, mhn arayüzüne giriş için gerekli şifrenin belirlendiği değişkendir. "**mhn_base_url**" değişkeni, mhn arayüzünün hizmet vereceği adresin belirtildiği değişkendir. "**mhn_honeymap_url**" değişkeni mhn haritasının hizmet vereceği adresin belirtildiği değişkendir. "**mhn_mail_server**" değişkeni, mhn tarafından yollanacak e-postalar için kullanılacak posta sunucusunun adresinin belirtildiği değişkendir.  "**mhn_mail_port**" değişkeni, mhn tarafından yollanacak e-postalar için kullanılacak posta sunucusunun port bilgisinin belirtildiği değişkendir. "**mhn_mail_user**" değişkeni, mhn tarafından bağlanılan e-posta sunucusunda doğrulama yapılacak kullanıcı adının belirtildiği değişkendir. "**mhn_mail_pass**"  değişkeni, mhn tarafından bağlanılan e-posta sunucusunda doğrulama yapılacak kullanıcı adının şifresinin belirtildiği değişkendir. "**mhn_mail_sender**" değişkeni, mhn tarafından yollanacak e-postalar için gönderici e-posta adresinin belirtildiği değişkendir."**mhn_log_file_path**" değişkeni, mhn tarafından oluşturulan kayıtların hangi dosyaya kayıt edileceğinin belirtildiği değişkendir. 

```
---
mhn_email: mhn@ahtapot.org
mhn_password: ahtapot
mhn_base_url: http://169.254.1.9
mhn_honeymap_url: http://169.254.1.9:3000
mhn_mail_server: localhost
mhn_mail_port: 25
mhn_mail_user: user1@ahtapot.org
mhn_mail_pass: labris
mhn_mail_sender:  noreply@ahtapot.org
mhn_log_file_path: /var/log/mhn/mhn.log
```

İlgili değişkenler ayarlandıktan sonra aşağıdaki komut ile mhn sunucusu kurulur.

```
ansible-playbook /etc/ansible/playbooks/mhn.yml
```

