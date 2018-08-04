# Antispam Kurulum Yönergesi


Bu dokümanda, Ahtapot projesi kapsamında antispam sunucusunun merkezi yönetim sisteminin ihtiyaçlarına cevap verecek şekilde nasıl kurulacağı anlatılmaktadır.

### Antispam Sistemi Kurulum İşlemleri

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

* Gitlab arayüzünden mys resposundaki “**hosts**” dosyasında “**[antispam]**” fonksiyonu altına antispam sunucusunun FQDN bilgisi girilir.

```
[antispam]
antispam.gdys.local
``` 

* Gitlab arayüzünden mys reposundaki  “**roles/base/vars/host.yml**” dosyasına antispam sunucusunun ip adresi, FQDN bilgisi ve hostname’i yeni bir server bloğu oluşturularak yazılır. 

```
serverN:
        ip: "X.X.X.X"
        fqdn: "antispam.gdys.local"
        hostname: "antispam"
```

Ardından antispam sistemi ile ilgili aşağıda tanımlanmış değişkenler açıklamalarda belirtilen şekilde uygun değerlerle doldurulur.

#### Spamassassin Rolü Değişkenleri
Bu roldeki değişkenler “**/etc/ansible/roles/spamassassin/vars/**” dizini altında bulunan yml dosyalarında belirtilmiştir. yml dosyalarının içerikleri ve değişken bilgileri aşağıdaki gibidir;

-   “**main.yml**” dosyasında bulunan değişkenlerin görevi şu şekildedir. "**antispam_smtpd_tls_cert_file**" değişkeni, antispam sisteminde oluşturulan cert dosyasının bulunduğu dosya yolunu belirtmektedir. Varsayılan olarak bu konumda oluşturulmaktadır. "**antispam_smtpd_tls_key_file**" değişkeni, antispam sisteminde oluşturulan key dosyasının bulunduğu dosya yolunu belirtmektedir. Varsayılan olarak bu konumda oluşturulmaktadır.. "**antispam_smtpd_tls_CAfile**" değişkeni, antispam sisteminde oluşturulan ca dosyasının bulunduğu dosya yolunu belirtmektedir. Varsayılan olarak bu konumda oluşturulmaktadır. "**antispam_avas_hostname**" değişkeni antispam sisteminin bilgisayar adının (hostname) belirtildiği değişkendir. "**antispam_mail_hostname**" değişkeni antispam sisteminin temiz e-postaları aktaracağı e-posta sunucusunun alan adıdır. "**antispam_domain**" değişkeni antispam sisteminin bulunduğu alanın adının belirtildiği değişkendir.  "**antispam_inet_protocols**" değişkeni antispam sisteminin çalışacağı IP protokolünün belirtildiği değişkendir. ipv4, ipv6 veya all yazılabilir. "**antispam_nameserver**" değişkeni antispam sistemi tarafından kullanılacak DNS sunucusunun belirtildiği değişkendir. "**antispam_block_encrypted_archive**" şifreli arşiv dosyalarının engellenip engellenmeyeceğinin belirtildiği değişkendir. "**antispam_ssl_**" ile başlayan değişkenler, antispam sistemi üzerinde oluşturulacak ssl anahtarı ile ilgili bilgilerin ayarlandığı değişkenlerdir. "**clamav_check_freq**" clamav veritabanı güncelliğinin bir gün içinde kaç kez kontrol edileceğinin belirtildiği değişkendir. "**clamav_mirror**" clamav'ın hangi sunuculardan güncelleme alacağının belirtildiği değişkendir. "**spam_regexes**" altına tek tek spam olarak algılanması istenen düzenli ifadeler eklenmelidir. Burada "**name**" kullanıcı tarafından belirlenen ayırt edici bir isimdir. "**where**" ise bu düzenli ifadenin mailin hangi kesiminde aratılacağının belirtildiği parametredir. "**regex**" istenen düzenli ifadenin yazıldığı parametredir. "**score**" parametresi spamassasin tarafından bu düzenli ifadeye uyan bir e-postaya kaç skor verileceğinin belirlendiği parametredir. "**describe**" parametresi ise bu düzenli ifade kuralının açıklamasının yazıldığı parametredir.

```
---
antispam_smtpd_tls_cert_file: /etc/postfix/ssl/smtpd.crt
antispam_smtpd_tls_key_file: /etc/postfix/ssl/smtpd.key
antispam_smtpd_tls_CAfile: /etc/postfix/ssl/cacert.pem
antispam_avas_hostname: avas
antispam_mail_hostname: mail
antispam_domain: ahtapot
antispam_inet_protocols: ipv4 #ipv4, ipv6, all
antispam_nameserver: 8.8.8.8
antispam_block_encrypted_archive: "true"
antispam_ssl_country: "TR"
antispam_ssl_state: "Ankara"
antispam_ssl_locality: "Ankara"
antispam_ssl_organization: "organizasyon_adi"
antispam_ssl_organizationalunit: "organizasyon_birimi"
antispam_ssl_commonname: "alan_adi"
clamav_check_freq: 24
clamav_mirrors:
  - db.local.clamav.net
  - database.clamav.net
spam_regexes:
  - name: PORN
    where: full
    regex: /porn/i
    score: 20
    describe: Spam Warning
```

İlgili değişkenler ayarlandıktan sonra aşağıdaki komut ile antispam sunucusu kurulur.

```
ansible-playbook /etc/ansible/playbooks/antispam.yml
```

### İçeriden Dışarı Eposta tarama
Eposta sunucunun Smart Host, Relay Host ve benzeri başlıklarla anılan yöntemlerle giden epostaları Antispam sunucya yönlendirmesi sağlanır. Bu başlık için eposta sunucu üreticisinin dokümanlarını kullanınız.

### Dışarıdan İçeri Eposta tarama
Dışarıdan gelen SMTP bağlantılarının doğrudan ilk sunucu olarak Antispam sunucusuna düşmesi Güvenlik Duvarı/NAT sisteminden gerçekleştirilir. Antispam sistemi doğrudan SMTP konuşabilen bir sistem olup epostaları karşılayacaktır. Temiz epostalar antispam sistemi tarafından Ansible playbook içinde tanımlanmış olan Mail Host Name ile tanılı olan sunucu ismine gönderilir. Bu sunucunun dns tanımının dns'te yapıldığından emin olunmalıdır. 

