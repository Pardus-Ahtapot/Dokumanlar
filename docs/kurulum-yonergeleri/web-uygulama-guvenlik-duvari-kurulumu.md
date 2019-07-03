# Web Uygulama Güvenlik Duvarı (WAF) Kurulumu 



Bu dokümanda, Ahtapot projesi kapsamında Web Uygulama Güvenlik Duvarı (WAF) bileşeninin, merkezi yönetim sistemi ile nasıl kurulacağı anlatılmaktadır.

### Web Uygulama Güvenlik Duvarı Kurulum İşlemleri

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

* Gitlab arayüzünden mys resposundaki “**hosts**” dosyasında “**[waf]**” fonksiyonu altına web uygulama güvenlik duvarı sunucusunun FQDN bilgisi girilir.

```
[waf]
waf.gdys.local
``` 

* Gitlab arayüzünden mys reposundaki  “**roles/base/vars/host.yml**” dosyasına web uygulaması güvenlik duvarı sunucusunun ip adresi, FQDN bilgisi ve hostname’i yeni bir server bloğu oluşturularak yazılır. 

```
serverN:
        ip: "X.X.X.X"
        fqdn: "waf.gdys.local"
        hostname: "waf"
```

Ardından web uygulama güvenlik duvarı sistemi ile ilgili aşağıda tanımlanmış değişkenler açıklamalarda belirtilen şekilde uygun değerlerle doldurulur.

## Web Uygulama Güvenlik Duvarı Değişkenleri
### Ahtapot Web Uygulama Güvenlik Duvarı Genel Ayarlar
Bu roldeki değişkenler “**/etc/ansible/roles/waf/vars/**” dizini altında bulunan waf.yml dosyalarında belirtilmiştir. yml dosyalarının içerikleri ve değişken bilgileri aşağıdaki gibidir;

 “**waf.yml**” dosyasında bulunan değişkenlerin görevi şu şekildedir. 

- **waf\_listen\_ip** değişkeni, kurulan apache web sunucusunun varsayılan olarak dinleyeceği ip adresini belirtir. **0.0.0.0** varsayılan değeri, sunucu üzerindeki herhangi bir IP adresine yapılan istekleri belirtir.
- **waf\_listen_port** değişkeni, dinlenilen IP adresi üzerindek hangi port dinleneceğini belirtir, varsayılan değer **80** dir.
- **waf_default\_timeout** değişkeni, ms cinsinden, bağlantı zaman aşım süresini belirtir. Sorun yaşanan web sitelerinde bu değerler esnetilebilir.
- **waf\_keepalive** KeepAlive özelliğinin açıp kapatmak için kullanılır, varsayılan değeri **On** kapatmak için verilmesi gereken değer ise **Off** değeridir.
- **waf\_maxkeepalive\_requests** KeepAlive ile bağlantı sağlandığında, izin verilen maksimum bağlantı sayısını (eş zamanlı) limitler. KeepAlive, sunucu üzerinde yük oluşturan bir özellik olduğu için, değerler dikkatli bir şekilde değiştirilmelidir. 
- **waf\_keepalive\_timeout** KeepAlive bağlantı yapıldığında timeout süresini belirler.
- **waf\_hostname\_lookups** bağlanan istemcilerin IP adreslerinin hostname e çözümlenmesini belirtir, bu işlem ek yük ve DNS sunucu hızlarına göre yavaşlamaya sebep olabilir. Alabileceği değerler **On** ve **Off** değerleridir.
- **waf\_loglevel** sunucunun loglarının hangi seviyede tutulacağını belirtir. Alabileceği değerler **warn**, **error**, **debug**, **info**, **notice** değerleridir. Varsayılan değer **warn** olarak seçilmiştir.
- **waf_remote_ip_header** Web sunucusu üzerine proxy edilen bağlantının, gerçek IP adresini hangi http header bilgisi ile taşıyacağını belirtir. Varsayılan değer **X-Forwarded-For**.
- **waf\_server\_tokens** Sunucu bilgilerinin ne kadarının ifşa edileceğini belirtir. Örn; Pardus 17.5/Sunucu Apache 2.4 ..vs gibi. Bu değer **Full** olarak ayarlanmalıdır. Ahtapot WAF, ifşa edilen bu bilgileri, otomatik olarak düzeltecektir. 
- **waf\_http\_listen\_ip** Apache web sunucusunun ekstradan dinlemesi gereken HTTP IP bilgisi yazılır. Bu değer genellikle **waf\_listen\_ip** değeri ile aynı verilebilir.
- **waf\_http\_listen\_port** Apache web sunucusunun ekstradan dinlemesi gereken HTTP Port bilgisi yazılır. Bu değer genellikle **waf\_listen_port** değeri ile aynı verilebilir.
- **waf\_https\_listen\_ip** Apache web sunucusunun ekstradan dinlemesi gereken HTTPS IP bilgisi yazılır.
- **waf\_https\_listen\_port** Apache web sunucusunun ekstradan dinlemesi gereken HTTPS Port bilgisi yazılır. 	
- **waf\_global\_secrule\_engine** Ahtapot WAF modülünün handi modda çalışacağı belirtilir. Bu değer global ayar olsa da, vhostlar için ayrıca ayar tanımlanarak üzerine yazılabilir. Varsayılan değer **DetectionOnly** yani öğrenme modudur. Global olarak aktive etmek için **On** tamamen kapatmak için ise **Off** değerleri kullanılabilir.
- **waf\_global\_req\_body\_access** yapılan isteğin sadece parametre ve argumanlar değil, tüm içeriğinin incelenmesini sağlar. 
- **waf\_global\_req\_body\_limit** body access parametresi açık iken, incelenecek maksium boyut belirlenir.
- **waf\_global\_req\_body\_nofiles\_limit** dosya yükleme harici yapılan isteklerde incelencek maksimum boyut belirlenir.
- **waf\_global\_req\_body\_limit\_action** limit aşıldığında alınacak aksiyon belirlenir. Kullanılabilir değerler; **ProcessPartial** (kısmen incele) ve **Reject** (reddet) değerleridir.
- **waf\_global\_pcre\_match\_limit** Ahtapot WAF modülü veriyi incelerken regex kullanır. Regex ile karşılaştırılacak maksimum veri boyutunu belirler.
- **waf\_global\_pcre\_match\_limit\_recursion** Veri incelenirken recursion oluştuğunda kullanılacak limit değeridir.
- **waf\_global\_response\_body\_access** Backend (korunan sunucu) tarafından oluşturulan cevap verisinin incelenmesini sağlar. Olası değerler **On** ve **Off** değerleridir. 
- **waf\_global\_response\_body\_limit** cevap verisinin maksimum boyutunu belirler.
- **waf\_global\_response\_body\_action** maksimum boyut aşıldığında alınacak aksiyonu belirler.
- **waf\_global\_audit\_log\_parts** Audit log (detaylı log) içinde hangi alanların bulunacaığı belirler. B: Bad Request, C: Request Body, D: Reserved (kullanılmıyor fakat ayrılmış), I: C bölümü için özel değerler, J: yüklenen dosya hakkında detaylı bilgi içerir, E: dönülen cevap, F: cevap headerları, G: reserved (kullanılmıyor) , H: Audit verisi, A : Audit log üst bilgisi, K: karşılaştırılıp pozitif dönülen tüm kuralları içerir, Z: Audit log sonu. Bu durumda tam bir audit log için verilmesi gereken değer; **ABDEFHIJZ** şeklinde olacaktır.
- **waf\_whitelist\_ips** WAF Kurallarından istisna tutalacak IP adreslerinin listesini içerir Örnek Kullanım; ["192.168.1.10", "10.10.20.40"].. vb.
	
### Ahtapot Web Uygulama Güvenlik Duvarı Anti-DDoS Yapılandırması
	
Ahtapot Web Uygulama Güvenlik Duvarı entegre bir Anti-DDoS bileşeni ile gelir. Bu web anti-ddos bileşenin konfigurasyonu **waf_ddos_** ile başlayan değişkenler ile yapılır.

- **waf\_ddos > waf\_hash\_table\_size** değişkeni, bellek üzerinde oluşturulan sanal tabloda tutulacak hash değerlerinin kullanabileceği maksimum boyutu belirtir. 
- **waf\_ddos > waf\_page\_count** Anti-ddos algoritması için periyot içinde kaç sayfanın işleneceği belirtilir.
- **waf\_ddos > waf\_site\_count** Aynı IP adresinden waf sunucusu üzerindeki kaç sitenin bu tabloda yer alacağı belirtilir.
- **waf\_ddos > waf\_page\_interval** waf_page_count değerinin hangi periyot içerisinde değerlendirileceği belirtilir.
- **waf\_ddos > waf\_site\_interval** waf_site_count değerinin hangi periyot içerisinde değerlendirileceği belirtilir.
- **waf\_ddos > waf\_block\_period** tespit edilen IP adresinin ne kadar süreyle bloke edileceğini belirtir.
- **waf\_ddos > waf\_email\_notify** bir tespit yapıldığında, bildirim gönderilecek e-posta adresini belirtir.
- **waf\_ddos > waf\_ddos\_logs_dir** Anti-ddos loglarının nerede tutulacağını belirtir.
- **waf\_ddos > waf\_ddos\_sys_cmd** bir IP adresi tespit edildiğinde alınacak olan aksiyon için sistem tarafından çalıştırılması istenilen komut belirtilir. Örn: güvenlik duvarına kural girmesi için bir betik hazırlanarak buraya belirtilebilir.

### Ahtapot Web Uygulama Güvenlik Duvarı Sanal Sunucu Yapılandırması

Web uygulama güvenlik duvarı ile, birden fazla web sitesini/ web uygulamasını koruyabilirsiniz. Bunun için tıpkı virtualhost yapılandırmaları gibi sanal sunucu yapılandırması kullanılmaktadır. **waf_vhosts** değişkeni altında, waf sunucusunun FQDN bilgisini girerek, altına bu sanal sunucu yapılandırmalarını belirtmeliyiz. 

- **waf\_vhosts > WAF\_FQDN > waf\_hostname** değişkeni, karşılanacak alan adı bilgisini belirtir.
- **waf\_vhosts > WAF\_FQDN > server\_alias** karşılanacak domain bilgisine, alternatif bir isim eklenebilir. Örneğin; ahtapot.org.tr waf_hostname iken, www.ahtapot.org.tr ya da waf.ahtapot.org.tr gibi farklı alt alan adlarını burada belirtebilirsiniz.
- **waf\_vhosts > WAF\_FQDN > listen\_ip** bu alan adının hangi IP üzerinden dinleneceğini belirtir.
- **waf\_vhosts > WAF\_FQDN > listen\_port** IP adresi üzerinde hangi port üzerinden dinleneceğini belirtir.
- **waf\_vhosts > WAF\_FQDN > ssl\_engine** Bu yapılandırmanın SSL yapılandırması içerip içermediğini bilerltir.
- **waf\_vhosts > WAF\_FQDN > http\_protocol\_options** HTTP istek satırına HTTP istek başlığı alanlarına uygulanmış kuralları ön tanımlı olarak belirtir. Bu değer varsayılan olarak **Strict** olarak belirlenmiştir. Fakat geriye dönük uyumluluk açısından (eski web uygulamalarına destek verebilmek adına) **Unsafe** değeri atanabilir.
- **waf\_vhosts > WAF\_FQDN > waf\_status** Bu sanal sunucu için ahtapot web uygulama güvenlik duvarının aktif olup olmayacağını belitir.
- **waf\_vhosts > WAF\_FQDN > waf\_debug\_level** Web uygulama güvenlik duvarının debug loglarını açıp kapatır, varsayılan değer **0**
- **waf\_vhosts > WAF\_FQDN > preserve\_host** istek üst bilgileri içersindeki host başlığını, arkadaki sunucuya aynen aktarılmasını sağlar.
- **waf\_vhosts > WAF\_FQDN > remote\_ip\_header** istek yapan kullanıcı gerçek IP adresinin, X-Forwarded-For başlığı ile arkadaki sunucuya aktarılmasını sağlar.
- **waf\_vhosts > WAF\_FQDN > reverse\_cookie\_path** İstek başlıklarında bulunan cookie path bilgisini arkadaki sunucuya aktarmayı sağlar.
- **waf\_vhosts > WAF\_FQDN > reverse\_cookie\_domain** İstek başlıklarında bulunan cookie domain bilgisini arkadaki sunucuya aktarmayı sağlar.
- **waf\_vhosts > WAF\_FQDN > proxy\_ssl** Arkadaki sunucu ile SSL protokolü üzerinden iletişim kurmayı sağlar.
- **waf\_vhosts > WAF\_FQDN > proxy\_pass** İsteklerin aktarılacak olan suncuu bilgisi. Bu alana DNS çözümlemesi yapabiliyorsanız (yerel olarak) domain, yada sadece IP adresi belirtebilirsiniz.
- **waf\_vhosts > WAF\_FQDN > proxy\_reversev_pass** İsteklerin hangi sunucu üzerinden aktarılacağını belirtir. Yukarıdaki değerle aynı verilebilir.
- **waf\_vhosts > WAF\_FQDN > waf\_disabled\_rules** Web Uygulama Güvenlik Duvarı kuralları arasından sadece bu sanal sunucu için devre dışı bırakılacak olan kuralların ID bilgisini içerir. Örnek; ["93448", "34098"] gibi 

### Ahtapot Web Uygulama Güvenlik Duvarı Yük Dengeleme Yapılandırması

Ahtapot Web Uygulama Güvenlik duvarı , dahili bir yük dengeleyici ile gelmektedir. Yük dengeleyici, sanal sunucular üzerinde aktif olmaktadır. Eğer bir sanal sunucuya yapılan istekleri birden fazla backend sunucuya yük dengeleme metodları ile aktarmak istiyorsanız **proxy_load_balan_pool_name** değerine bir havuz ismi girerek, **proxy_load_balance_members** değeri olarak da arkadaki sunucuların IP adreslerini belirtirseniz, modül aktif olacaktır. Floating IP adres kullanan sistemlerde ve çok yük alan sistemlerde kullanılması tavsiye edilir.

- **waf\_vhosts > WAF\_FQDN > proxy\_load\_balance\_pool\_name** Sunucu havuzu için verilecek isim. Bu isim benzersiz olmalıdır. Yani başka sunucu havuzları ile aynı ismi kullanmayın.
- **waf\_vhosts > WAF\_FQDN > proxy\_load\_balance\_members** Bu sunucu havuzuna dahil edilecek olan sunucuların IP adresleri. Örnek Kullanım; ["192.168.2.10", "192.168.2.11"] gibi.
- **waf\_vhosts > WAF\_FQDN > proxy\_load\_balance\_method** Yük dengeleme yapılırken kullanılacak olan algoritma. **byrequests** ve **bytraffic** değerlerini alabilir. **byrequests** ile yapılan istek sayısını baz alarak, eşit dağılım sağlanır. **bytraffic** ile sunucuların trafikleri eşit olarak dağıtılır.

	
Değişkenlerin açıklamalarından bahsettik. Örnek bir değişken dosyası aşağıdaki gibi olmalıdır.

```

waf_listen_ip: "0.0.0.0"
waf_listen_port: "80"
waf_default_timeout: "200"
waf_keepalive: "On"
waf_maxkeepalive_requests: "100"
waf_keepalive_timeout: "30"
waf_hostname_lookups: "Off"
waf_loglevel: "warn"
waf_remote_ip_header: "X-Forwarded-For"
waf_server_tokens: "Full"
waf_http_listen_ip: "*"
waf_http_listen_port: "80"
waf_https_listen_ip: "*"
waf_https_listen_port: "443"
waf_global_secrule_engine: "DetectionOnly"
waf_global_req_body_access: "On"
waf_global_req_body_limit: "100000"
waf_global_req_body_nofiles_limit: "100000"
waf_global_req_body_limit_action: "Reject"
waf_global_pcre_match_limit: "100000"
waf_global_pcre_match_limit_recursion: "100000"
waf_global_response_body_access: "On"
waf_global_response_body_limit: "10000"
waf_global_response_body_action: "ProccessPartial"
waf_global_audit_log_parts: "ABDEFHIJZ"
waf_whitelist_ips: ["192.168.1.170", "192.168.1.172", "192.168.1.173"]
waf_ddos:
    waf_hash_table_size: "3097"
    waf_page_count: "2"
    waf_site_count: "50"
    waf_page_interval: "1"
    waf_site_interval: "1"
    waf_block_period: "10"
    waf_email_notify: "ahtapot@pardus.org.tr"
    waf_ddos_logs_dir: "/var/log/ahtapot/waf/mod_evasive.log"
    waf_ddos_sys_cmd: ""
waf_vhosts:
    wafsunucum.ahtapot.org.tr:
        - waf_hostname: "ahtapot.org.tr"
          server_alias: "www.ahtapot.org.tr"
          listen_ip: "*"
          listen_port: "80"
          ssl_engine: "on"
          http_protocol_options: "UnSafe"
          waf_status: "DetectionOnly"
          waf_debug_level: "0"
          preserve_host: "On"
          remote_ip_header: "X-Forwarded-For"
          reverse_cookie_path: "/ /"
          reverse_cookie_domain: "127.0.0.1 ahtapot.org.tr"
          proxy_ssl: "On"
          proxy_pass: '"/" "http://172.50.50.12/"'
          proxy_reverse_pass: '"/" "http://172.50.50.12/"'
          proxy_load_balance_pool_name: "websunucularim"
          proxy_load_balance_members: ["http://172.50.50.13/", "http://172.50.50.14/"]
          proxy_load_balance_method: "byrequests"
          waf_disabled_rules: ["340162", "340163"]
        - waf_hostname: "test1.ahtapot.org.tr"
          server_alias: "www.test1.ahtapot.org.tr"
          listen_ip: "*"
          listen_port: "80"
          ssl_engine: "Off"
          http_protocol_options: "UnSafe"
          waf_status: "DetectionOnly"
          waf_debug_level: "0"
          preserve_host: "On"
          remote_ip_header: "X-Forwarded-For"
          reverse_cookie_path: "/ /"
          reverse_cookie_domain: "127.0.0.1 ahtapot.org.tr"
          proxy_ssl: "On"
          proxy_pass: '"/" "http://172.50.50.12/"'
          proxy_reverse_pass: '"/" "http://172.50.50.12/"'
          proxy_load_balance_pool_name: ""
          proxy_load_balance_members: []
          proxy_load_banace_method: ""
          waf_disabled_rules: []

```
Görüldüğü gibi, waf_vhosts altında bulunan wafsunucum.ahtapot.org.tr adresindeki waf sunusuna , ahtapot.org.tr ve test1.ahtapot.org.tr sanal sunucularının yapılandırılması örnekteki gibi yapılmaktadır.

**NOT**: SSL yapılandırması kullanılan sanal sunucularda, ssl sertifikası ve anahtarı alanadi.com.crt.j2 ve alanadi.com.key.j2 isimleriyle templates/ klasorunun altına mutlaka konulmalıdır. Aksi halde SSL konfigurasyonu devreye girmeyecektir (ayarlardan açılsa dahi).


İlgili değişkenler ayarlandıktan sonra aşağıdaki komut ile "**Ahtapot Web Uygulama Güvenlik Duvarı**" aşağıdaki komut ile kurulabilir.

```
ansible-playbook /etc/ansible/playbooks/waf.yml 
```

