# ELK Kurulum

### Elasticsearch Kurulum

* **NOT:** Dökümanda yapılması istenilen değişiklikler gitlab arayüzü yerine terminal üzerinden yapılması durumunda playbook oynatılmadan önce yapılan değişiklikler git'e push edilmelidir.

```
$ cd /etc/ansible
git status komutu ile yapılan değişiklikler gözlemlenir.
$ git status  
$ git add --all
$ git commit -m "yapılan değişiklik commiti yazılır"
$ git push origin master
```
**NOT:** Kurulacak sistem, SIEM yapısına dahil edilmek isteniyorsa, kurulum sonrasında Siber Olay, Açıklık, Risk İzleme ve Yönetim Sistemi Kurulumu sayfasında bulunan [LMYS Clientlarında Ossec Agent Dağıtımı](siem-kurulum.md) başlığı incelenmelidir.

* Tercih ettiğimiz metin düzenleyicisini kullanarak hosts dosyasını düzenliyoruz. Aşağıdaki örnekte vi kullanılır. Açılan dosyada [elasticsearch] kısmı altına elasticsearch makinesinin tam ismi (FQDN) girilir.

```
$ cd /etc/ansible/
$ sudo vi hosts
[elasticsearch]
es01.gdys.local
```

* Ansible makinesinin elasticsearch makinesine erişmesi için “roles/base/vars/host.yml” dosyası içerisine elasticsearch makinesinin bilgileri aşağıdaki gibi yazılır.

```
$ vi /etc/ansible/roles/base/vars/host.yml
    serverX:
        ip: "10.112.2.19"
        fqdn: "es01.gdys.local"
        hostname: "es01"
```


* "**/etc/ansible/roles/elasticsearch/vars**" dizininde Elasticsearch değişkenlerinin bulunduğu "**elasticsearch.yml**" dosyası içerisindeki "**elasticsearch_servers**" fonksyionu içerisindeki "**node01**" satırının altında bulunan "**fqdn**" bölümüne elasticsearch makinesinin fqdn bilgisi, "**network_host**" bölümüne elasticsearch makinesinin ip bilgisi, "**http_port**" bölümüne elasticsearch ün hangi port üzerinde çalışacağı bilgileri girilmelidir. Kaç tane elasticsearch makinesi kurulacak ise node olarak aşağıdaki gibi eklenebilir.

```
$ vi /etc/ansible/roles/elasticsearch/vars/elasticsearch.yml
elasticsearch_servers:
    node01:
        fqdn: "es01.gdys.local"
        network_host: "172.16.16.86"
        http_port: "9200"
        node_name: "es01"
        node_data: "true"
        node_master: "true"
        transport_keystore_pass: "KEYPASS"
        http_keystore_pass: "KEYPASS"
    node02:
        fqdn: "es02.gdys.local"
        network_host: "172.16.16.87"
        http_port: "9200"
        node_name: "es02"
        node_data: "true"
        node_master: "false"
        transport_keystore_pass: "KEYPASS"
        http_keystore_pass: "KEYPASS"
#    nodeXX:
#        fqdn: ""
#        network_host: ""
#        http_port: ""
#        node_name: ""
#        node_data: ""
#        node_master: ""
#        transport_keystore_pass: ""
#        http_keystore_pass: ""
```
* "**/etc/ansible/roles/elasticsearch/handlers/searchguard.yml**" dizininde Searchguard değişkenlerinin bulunduğu "**searchguard.yml**" dosyası içerisinde searchguard konfigurasyonunun yeniden yüklenmesi için "**-h**" değeri için "**fqdn**" değeri yerine elasticsearch makinesinin fqdn bilgisi girilir.

```
$ vi /etc/ansible/roles/elasticsearch/handlers/searchguard.yml
---
- name: searchguard konfigurasyonu yeniden yukleniyor
  shell: "/bin/bash plugins/search-guard-2/tools/sgadmin.sh -cd plugins/search-guard-2/sgconfig/ -ks /etc/elasticsearch/es01-keystore.jks -kspass KEYPASS -ts /etc/elasticsearch/truststore.jks -tspass TRUSTPASS -cn {{ elasticsearch['conf']['cluster_name'] }} -h fqdn -p 9300 -nhnv"
  args:
    chdir: "/usr/share/elasticsearch/"
  sudo: yes
```

* "**Ansible Playbookları**" dokümanında detaylı anlatımı bulunan, sunucu üzerinde gerekli sıkılaştırma işlemleri ve Elasticsearch kurulumu yapacak olan "**elasticsearch.yml**" playbook’u çalıştırılır.

```
ansible-playbook playbooks/elasticsearch.yml
```
* Elasticsearch  playbook'u çalıştırıldığında "**searchguard konfigurasyonu yeniden yukleniyor**" başlığı altında hatalar gelecektir. Bu hataların sebebi searchguard konfigurasyonu için gerekli anahtarlar oluşturulmadığından dolayıdır. Kibana kurulumundan sonra "**Anahtarların Hazırlanması**" başlığı altında gerekli anahtarlar oluşturulmaktadır. 

###Kibana Kurulumu

* **NOT:** Dökümanda yapılması istenilen değişiklikler gitlab arayüzü yerine terminal üzerinden yapılması durumunda playbook oynatılmadan önce yapılan değişiklikler git'e push edilmelidir.

```
$ cd /etc/ansible
git status komutu ile yapılan değişiklikler gözlemlenir.
$ git status  
$ git add --all
$ git commit -m "yapılan değişiklik commiti yazılır"
$ git push origin master
```
**NOT:** Kurulacak sistem, SIEM yapısına dahil edilmek isteniyorsa, kurulum sonrasında Siber Olay, Açıklık, Risk İzleme ve Yönetim Sistemi Kurulumu sayfasında bulunan [LMYS Clientlarında Ossec Agent Dağıtımı](siem-kurulum.md) başlığı incelenmelidir.

* Tercih ettiğimiz metin düzenleyicisini kullanarak hosts dosyasını düzenliyoruz. Aşağıdaki örnekte vi kullanılır. Açılan dosyada [kiibana] kısmı altına kibana makinesinin tam ismi (FQDN) girilir.

```
$ cd /etc/ansible/
$ sudo vi hosts
[kibana]
es01.gdys.local
```

* Ansible makinesinin kibana makinesine erişmesi için “roles/base/vars/host.yml” dosyası içerisine kibana makinesinin bilgileri aşağıdaki gibi yazılır.

```
$ vi /etc/ansible/roles/base/vars/host.yml
    serverX:
        ip: "10.112.2.19"
        fqdn: "es01.gdys.local"
        hostname: "es01"
```

* "**/etc/ansible/roles/kibana/vars**" dizininde Kibana değişkenlerinin bulunduğu "**kibana.yml**" dosyası içerisindeki "**server.port**" bölümüne kibananın çalışacağı port bilgisi, "**elasticsearch.url**" bölümüne ise elasticsearch'ün çalıştığı url bilgisi portu ile girilmelidir.

```
# Kibana'in degiskenlerini iceren dosyadir
kibana:
    default:
        source: "kibana.j2"
        destination: "/etc/default/kibana"
        owner: "root"
        group: "root"
        mode: "0644"
    user: "kibana"
    group: "root"
    chroot: "/"
    chdir: "/"
    nice: ""
    service:
        name: "kibana"
        state: "started"
        enabled: "yes"
    yml:
        source: "kibana.yml.j2"
        destination: "/opt/kibana/config/kibana.yml"
        owner: "root"
        group: "root"
        mode: "0644"
    server.port: "5601"
    server.host: "0.0.0.0"
    server.maxPayloadBytes: "1048576"
    elasticsearch.url: "http://172.16.16.86:9200"
    kibana.index: ".kibana"
    kibana.defaultAppId: "discover"
    pid.file: "/var/run/kibana.pid"
    logging.verbose: "false"
    logging.dest: "stdout"
```
*  "**/etc/ansible/roles/kibana/vars**" dizininde nginx değişkenlerinin bulunduğu "**nginx.yml**" dosyası içerisindeki "**server_name**" satırına kibana arayüzünün çalışacağı url bilgisi girilmelidir.

```
---
# Nginx'in degiskenlerini iceren dosyadir
nginx:
    conf: 
        source: "kibana_nginx.conf.j2" 
        destination: "/etc/nginx/conf.d/kibana.conf"
        owner: "root"
        group: "root"
        mode: "0644" 
    service: 
        name: "nginx"
        state: "started" 
        enabled: "yes"
    default: 
        path: "/etc/nginx/sites-available/default"
        state: "absent"
    certificate: 
        source: "kibana.crt.j2" 
        destination: "/etc/nginx/ssl/kibana.crt" 
        owner: "root"
        group: "root" 
        mode: "0644" 
    key: 
        source: "kibana.key.j2" 
        destination: "/etc/nginx/ssl/kibana.key" 
        owner: "root"
        group: "root" 
        mode: "0644"
    ssldir:
        path: "/etc/nginx/ssl"
        owner: "root"
        group: "root"
        mode: "0755"
        state: "directory" 
    listen: "443" 
    server_name: "es01.gdys.local"
```

* "**Ansible Playbookları**" dokümanında detaylı anlatımı bulunan, sunucu üzerinde gerekli sıkılaştırma işlemleri ve Kibana kurulumu yapacak olan "**kibana.yml**" playbook’u çalıştırılır.

```
ansible-playbook playbooks/kibana.yml
```

###Logstash Kurulumu

* Logstash rsyslog playbook'u ile kurulmaktadır.

* Logstash rsyslog ile ossimcik ve ossimlerden alınan logları elasticsearch içerisine göndermek için kullanılmaktadır. Rsyslog makinasının rsyslog.conf dosyasında gelen logların yazılacağı dizin bilgileri logstash "**00-input.conf**" dosyası içerisinde belirtilmelidir.

```
$ vi /etc/ansible/roles/logstash/templates/configuration/00-input.conf.j2
## Bu dosya ansible tarafindan yonetilmektedir!
## Burada yapilan degisikliklerin uzerine yazilir!!
{{ ansible_managed }}

input {

  file {
    path => '/data/log/raw_location01.log'
    start_position => 'beginning'
    type => 'raw_location01'	
  }
  
  file {
    path => '/data/log/alert_location01.log'
    start_position => 'beginning'
    type => 'alert_location01'	
  }
  
  file {
    path => '/data/log/raw_location02.log'
    start_position => 'beginning'
    type => 'raw_location02'	
  }
  
  file {
    path => '/data/log/alert_location02.log'
    start_position => 'beginning'
    type => 'alert_location02'	
  }
}
```

* Dosya içerisinde belirlenen her log dosyası için elasticsearch içerisinde yeni bir index oluşturulacaktır. Oluşturulan indexlerin birbirinden ayrılabilmesi için input dosyası içerisinde type'lar belirlenmelidir. Belirlenen typelara göre output dosyası düzenlenir.

```
$ vi /etc/ansible/roles/logstash/templates/configuration/02-output.conf.j2 
## Bu dosya ansible tarafindan yonetilmektedir!
## Burada yapilan degisikliklerin uzerine yazilir!!
{{ ansible_managed }}

output{

  if [type] == "raw_location01" {

    elasticsearch {
      hosts => [{% for key,value in elasticsearch_servers.iteritems() %}"{{ value.fqdn }}"{% if not loop.last %},{% endif %}{% endfor %}]
      index => "raw-location01-%{+YYYY.MM.dd}"
      ssl => "true"
      ssl_certificate_verification => "true"
      user => "logstashraw"
      password => "logstashrawpass"
      truststore => "/etc/logstash/truststore.jks"
      truststore_password => "TRUSTPASS"
    }

  } else if [type] == "raw_location02" {

    elasticsearch {
      hosts => [{% for key,value in elasticsearch_servers.iteritems() %}"{{ value.fqdn }}"{% if not loop.last %},{% endif %}{% endfor %}]
      index => "raw-location02-%{+YYYY.MM.dd}"
      ssl => "true"
      ssl_certificate_verification => "true"
      user => "logstashraw"
      password => "logstashrawpass"
      truststore => "/etc/logstash/truststore.jks"
      truststore_password => "TRUSTPASS"
    }

  } else if [type] == "alert_location01" {

    elasticsearch {
      hosts => [{% for key,value in elasticsearch_servers.iteritems() %}"{{ value.fqdn }}"{% if not loop.last %},{% endif %}{% endfor %}]
      index => "alert-location01-%{+YYYY.MM.dd}"
      ssl => "true"
      ssl_certificate_verification => "true"
      user => "logstashalert"
      password => "logstashalertpass"
      truststore => "/etc/logstash/truststore.jks"
      truststore_password => "TRUSTPASS"
    }

  } else if [type] == "alert_location02" {

    elasticsearch {
      hosts => [{% for key,value in elasticsearch_servers.iteritems() %}"{{ value.fqdn }}"{% if not loop.last %},{% endif %}{% endfor %}]
      index => "alert-location02-%{+YYYY.MM.dd}"
      ssl => "true"
      ssl_certificate_verification => "true"
      user => "logstashalert"
      password => "logstashalertpass"
      truststore => "/etc/logstash/truststore.jks"
      truststore_password => "TRUSTPASS"
    }

}
```

* Output dosyası içerisinde type parametresi için input dosyası içerisinde her log dosyası için belirlenen type, index parametresi için elasticsearch içerisinde log dosyaları için oluşturulması istenilen index ismi girilir.

* "**Ansible Playbookları**" dokümanında detaylı anlatımı bulunan, sunucu üzerinde gerekli sıkılaştırma işlemleri ve Logstash kurulumu yapacak olan "**rsyslog.yml**" playbook’u çalıştırılır.

```
ansible-playbook playbooks/rsyslog.yml
```

### Anahtarların Hazırlanması

* Anahtar imzalamak üzere kullanılan CA makinası üzerinde anahtar oluşturma işlemleri yapılır.
* CA anahtarları için CA makinası üzerinde "**/etc/pki/sg/etc**" dizini oluşturulur.

```
mkdir /etc/pki/   
mkdir /etc/pki/sg/
mkdir /etc/pki/sg/etc/
```

* Pardus git reposundan  "**https://git.pardus.org.tr/ahtapot/SOLARIS/tree/development/AhtapotSIEM/SearchGuard_key**" "**SearchGuard_key**" içerisinden imzalama için gerekli dosyalar "**gen_root_ca.sh**", "**root-ca.conf**"" ve "**signing-ca.conf**" CA makinesine kopyalanır.

* "**gen_root_ca.sh**" betiği CA makinesinde "**/etc/pki/sg/**" içerisine "**root-ca.conf**"" ve "**signing-ca.conf**" dosyaları "**/etc/pki/sg/etc/**" içerisine kopyalanmalıdır.

* "**root-ca.conf**"" ve "**signing-ca.conf**" dosyaları içerisinde **DomainName** değişkenleri kurulan sistemde kullanıma göre değiştirilmelidir

```
[ ca_dn ]
0.domainComponent       = "local"
1.domainComponent       = "gdys"
organizationName        = "ulakbim"
organizationalUnitName  = "ulakbim Root CA"
commonName              = "ulakbim Root CA"
```

* İmzalama işlemi öncesinde gerekli olan paketler yüklenir.
```
# apt-get install openjdk-7-jre openssl
```

* CA sertifikasını yaratmak için aşağıdaki betik çalıştırılır.
NOTE: Bu komut çalıştırılırken CA ve Truststore password istemektedir. Default olarak dökümanın içerisinde anahtarların oluşturulmasında **CA password:CAPASS**, **Truststore password:TRUSTPASS** olarak kullanılmaktadır. Password'lerın değiştirilmesi durumunda aşağıda verilen komutlar içerisinde CAPASS yerine yeni kullanılacak password kullanılmalıdır. Trust password değiştirilmesi durumunda elasticsearch playbook içerisinde "**/etc/ansible/roles/elasticsearch/templates/elasticsearch.yml.j2**" ve "**/etc/ansible/roles/elasticsearch/handlers/searchguard.yml**" dosyalarında **TRUSTPASS** yerine yeni girilen password ile değiştirilmelidir.
```
# bash /etc/pki/sg/gen_root_ca.sh
```
* "**Elastic Search**" makinası üzerinde anahtar oluşturmak için elasticsearch makinelerine bağlanılır.
* Anahtar oluşturmak için "**/etc/elasticsearch**" dizinine gidilir.
```
# cd /etc/elasticsearch/
```
* Aşağıdaki komutlar kullanılarak gerekli anahtarlar oluşturulur. İlgili komutlarda "**alias**" kısmında sunucunun kısa adı, "**keystore**" bölümünde "**nodename-keystore.jks**" "**dname**" bölümünde sunucuya ait LDAP bilgileri "**ext**" kısmında ise sunucunun fqdn adı ve IP bilgileri girlir.
```
# keytool -genkey -alias elk01 -keystore es01-keystore.jks -keyalg RSA -keysize 2048 -validity 712 -sigalg SHA256withRSA -keypass KEYPASS -storepass KEYPASS -dname "CN=elk01.gdys.local, OU=SSL, O=Test, L=Test, C=TR" -ext san=dns:elk01.gdys.local,ip:10.20.30.204,oid:1.2.3.4.5.5 

# keytool -certreq -alias elk01 -keystore es01-keystore.jks -file es01.csr -keyalg rsa -keypass KEYPASS -storepass KEYPASS -dname "CN=elk01.gdys.local, OU=SSL, O=Test, L=Test, C=TR" -ext san=dns:elk01.gdys.local,ip:10.20.30.204,oid:1.2.3.4.5.5
```
* "**Elastic Search**" sunucusu üzerinde oluşturulan anahtarlar "**CA**" sunucusuna kopyalanır.
* Aşağıdaki komut kullanılarak anahtarlar imzalanır.
```
# openssl ca -in es01.csr -notext -out es01-signed.pem -config /etc/pki/sg/etc/signing-ca.conf -extensions v3_req -batch -passin pass:CAPASS -extensions server_ext
```
* Tüm sertifikalar için chain oluşturularak, "**Elastic Search**" makinasına geri gönderilir.
```
# cat ./ca/chain-ca.pem es01-signed.pem > all01.pem
```
* Oluşturulan "**all01.pem**", "**truststore.jks**" ve "**/etc/pki/sg/ca/root-ca.crt**" sertifikaları “**Elastic Search**” makinasine gönderilir. "**all01.pem**" ve "**truststore.jks**" sertifikaları "**/etc/elasticsearch**" dizini içerisine "**root-ca.crt**" sertifikası "**/usr/local/share/ca-certificates/**" dizini içerisine kopyalanır.
NOTE: "**truststore.jks**" sertifikası ayrıca rsyslog makinasında "**/etc/logstash**" dizini içerisine kopyalanarak elasticsearch ile logstash arasında iletişim için gerekli key logstash'e belirtilmiş olur.
```
# cat all01.pem | keytool -importcert -keystore es01-keystore.jks -storepass KEYPASS -noprompt -alias elk01

# keytool -importkeystore -srckeystore es01-keystore.jks -srcstorepass KEYPASS -srcstoretype JKS -deststoretype PKCS12 -deststorepass KEYPASS -destkeystore es01-keystore.p12
```
* CA sunucusundan alınan  "**root-ca.crt**" dosyası elasticsearch makinesinde “ca-certificates” arasına eklenir.
```
# cat /usr/local/share/ca-certificates/root-ca.crt
# update-ca-certificates
```

* Elasticsearch playbook yeniden çalıştırılarak konfigurasyonlar tamamlanır.
```
ansible-playbook playbooks/elasticsearch.yml
``` 
**Sayfanın PDF versiyonuna erişmek için [buraya](elk-kurulum.pdf) tıklayınız.**
