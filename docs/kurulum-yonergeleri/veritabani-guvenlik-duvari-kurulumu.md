# Veritabanı Güvenlik Duvarı Kurulumu



Bu dokümanda, Ahtapot projesi kapsamında Veritabanı Güvenlik Duvarı Bileşeninin, merkezi yönetim sistemi ile nasıl kurulacağı anlatılmaktadır.

### Veritabanı Güvenlik Duvarı Kurulum İşlemleri

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

* Gitlab arayüzünden mys resposundaki “**hosts**” dosyasında “**[dbfirewall]**” fonksiyonu altına antispam sunucusunun FQDN bilgisi girilir.

```
[dbfirewall]
dbfirewall.gdys.local
``` 

* Gitlab arayüzünden mys reposundaki  “**roles/base/vars/host.yml**” dosyasına veritabanı güvenlik duvarı sunucusunun ip adresi, FQDN bilgisi ve hostname’i yeni bir server bloğu oluşturularak yazılır. 

```
serverN:
        ip: "X.X.X.X"
        fqdn: "dbfirewall.gdys.local"
        hostname: "dbfirewall"
```

Ardından veritabanı güvenlik duvarı sistemi ile ilgili aşağıda tanımlanmış değişkenler açıklamalarda belirtilen şekilde uygun değerlerle doldurulur.
#### Veritabanı Güvenlik Duvarı Rolü Değişkenleri
Bu roldeki değişkenler “**/etc/ansible/roles/dbfirewall/vars/**” dizini altında bulunan yml dosyalarında belirtilmiştir. yml dosyalarının içerikleri ve değişken bilgileri aşağıdaki gibidir;

-   “**main.yml**” dosyasında bulunan değişkenlerin görevi şu şekildedir. 
	-   "**dbfw_conf_dir**" değişkeni, güvenlik duvarının konfigurasyon dosyalarının bulunacağı dizini belirtmektedir. Varsayılan olan "**/etc/dbshield**" dizini paket kurulumlarının standart olarak kullandığı dizin olduğu için değiştirmek gerekmemektedir.
	-   "**dbfw_mode**" değişkeni, güvenlik duvarının hangi modda çalışacağını belirtmektedir. Varsayılan olarak "**learning**" modda çalışır ve herhangi bir bloklama yapmaz, sadece veritabanı modeli oluşturur. Bloklama modu için bu değişken "**protection**" olarak ayarlanmalıdır.
	-   "**dbfw_dbms**" değişkeni, korunacak olan veritabanı türünü belirtmektedir. Varsayılan olarak "**mysql**" seçilmiştir. Olası diğer değerler; "**db2**", "**mariadb**", "**mysql**", "**oracle**", "**postgres**" değerleridir.
	-   "**dbfw_listenip**" değişkeni, dinlenecek IP adresini belirtmek için kullanılır. "**0.0.0.0**" değeri, sunucu üzerindeki tüm IP adreslerini dinler. Eğer veritabanınız, sunucu dışında bağlantılara kapalı olarak yapılandırıldıysa, bu değeri "**127.0.0.1**" olarak ayarlayarak, sadece yerel bağlantılara kısıtlayabilirsiniz. 
	-   "**dbfw_listenport**" değişkeni, güvenlik duvarı tarafından dinlenecek bağlantı noktasını belirtmektedir. Uygulamalarınız, veritabanı türünün gerçek portuna değil, bu port adresine bağlanmalıdır. Eğer uygulama tarafından bu port değerini değiştiremiyorsanız, veritabanı türüne göre, varsayılan Port bilgisini buraya yazarak, veritabanı sunucunuzu farklı bir porttan çalıştırabilirsiniz.
	-   "**dbfw_backendip**" değişkeni, korunacak olan veritabanının bağlantı IP adresini belirtmek için kullanılır. Veritabanı güvenlik duvarının, veritabanı sunucusu ile bu ip adresi üzerinden iletişim kurabilmesi gerekmektedir.
	-   "**dbfw_backendport**" değişkeni, korunacak olan veritabanı sunucusunun bağlantı noktasını, portunu belirtmektedir.
	-   "**dbfw_syncinterval**" değişkeni, veritabanı senkranizasyon periyodunu belirtir. "**0**" değeri verilirse, senkronizasyon her commit ile yapılacaktır. Verilebilecek değerler; ns, ms, s, m ve h olarak belirtilebilir (süre cinsinden).
	-   "**dbfw_action**" değişkeni, anormal davranışlar karşısında verilecek cevap için kullanılmaktadır. Kullanılabilecek değerler; bağlantıyı kesmek için "**drop**" ve bağlantıya izin vermek için "**pass**" değerleridir.
	-   "**dbfw_webui**" değişkeni, dahili web sunucusu üzerinden arayuzun çalıştırılması için kullanılmaktadır. alınabilecek değerler "**yes**" ve "**no**" , varsayılan değer "**yes**"dir.
	-   "**dbfw_webhttps**" değişkeni ile, web arayuzunun, https üzerinden çalışması seçilir.
	-   "**dbfw_webhttp_ip**" değişkeni, web arayuzu için dinlenilecek IP adresini belirtir.
	-   "**dbfw_webhttp_port**" değişkeni, web arayüzü için (http veya https) bağlantı noktasını belirtir.
	-   "**dbfw_webhttp_pass**" değişkeni, web arayüzü için kullanılacak olan şifreyi belirler.
	-   "**dbfw_additional_checks**" değişkeni, anormal sorgular için kontrol edilebilecek olan ek özellikleri belirtir. kullanılabilecek değerler; "**user**": kullanıcı adı ve "**source**": isteği yapan kaynak adresini belirtir. Birden fazla özellik belirtmek için virgül ile ayrılarak kullanılabilir. Tavsiye edilen değer; "**user, source**"
	-   "**dbfw_log_level**" değişkeni, log seviyesini belirtmektedir. Log seviyeleri ; 
		-   "**1- warning**", 
		-   "**2- info**", 
		-   "**3- warning+info**", 
		-   "**4- debug**" olarak seçilebilir. 

	Tavsiye edilen değer; "**3**"
	
	-   "**dbfw_log_path**" değişkeni, loglama dizinini belirtmektedir. Kullanılabilecek değerler; 
		-   stdout
		-   stderr
		-   /dosya/dizini.log 
		
		Varsayılan değer "**/var/log/ahtapot/database-fw.log**" 




İlgili değişkenler ayarlandıktan sonra aşağıdaki komut ile "**Ahtapot Veritabanı Güvenlik Duvarı**" aşağıdaki komut ile kurulabilir.

```
ansible-playbook /etc/ansible/playbooks/dbfirewall.yml 
```

