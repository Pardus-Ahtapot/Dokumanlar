# PBNJ Port Scanner Yazilimi Kullanimi

Port scanner yazılımı aşağıdaki komut ile kurulur.

```
apt-get install pbnj 
```

>SQLite modülü ile anlatılacağı diğer veritabanı sürücü yazılımları kurulmamıştır.
>Diğer veritabanı yazılımları için aşağıdaki paketler tercih edilebilir.
>**Mysql:** ```apt install libdbd-mysql-perl```
>**Postgresql:** ```apt install libdbd-pg-perl```
> **Not:** Mysql aşağıdaki şekilde kullanıcı ve database oluşturulur. Postgresql için benzer bir şekilde internetten bakılabilarak veritabanı ve kullanıcı oluşturulabilir.

 ```
CREATE USER pbnj@'%' IDENTIFIED BY  'ahtapot';
CREATE DATABASE pbnj;
GRANT ALL PRIVILEGES ON  pbnj.* TO pbnj@'%';
 ```

## Ayarlar

> **Not:** Eğer sql,csv gibi bir alanda tarama sonuçları saklanmayacak ise bu ayarlara gerek olmadan da pbnj kullanılabilir.

Kullanıcıya özel ayar dizini oluşturulur. 

```
mkdir -p ~/.pbnj-2.0/
```

SQLite hazır yapılandırma dosyası kopyalanır.

```
cp /usr/share/doc/pbnj/examples/sqlite3.yaml ~/.pbnj-2.0/config.yaml
```

## Port Tarama
pbnj ile aşağıdaki örnekteki gibi port tarama yapılabilir.
```
scanpbnj -m 80 -a '-sS' 10.34.12.254
```
Parametrelerin anlamları:

**-m:** standart portlar dışında port belirtmek için kullanılır. Örn: 8080 veya 3306,5900

> Port aralığı vermek için **--range** parametresi kullanılır. Örn: **--range** 80-100
> Default: 1-1025

**-a:** Bu parametreye '-sS' olarak verilen diğer parametreler nmap tarama aracına gönderilir. Bu sayede taramanız nmap aracına göre daha kapsamplı yapılabilir.
> Nmap parametreleri için nmap --help komutundan yardım alınabilir.
 
**IP:** 10.34.12.254 hedef adresi olarak belirlendi. 

**Hedef adres tanımları:** microsoft.com, 192.168.0.1, 192.168.1.1/24, 10.0.0.1-254

> **--iplist** parametresi ile ip listesi dosyası verilebilir.

## Tarama Sonuçları
Yapılan taramaları; tarama yapılan dizinde **data.dbl** sqlite dosyasına kayıt eder.

Son taramalara ilişkin sonuçları görmek için aşağıdaki komut çalıştırılabilir.

**Sorgu**

```
outputpbnj -q latestinfo
```
**-q:**  ile hazır sql sorguları çalıştırılır.

> outputpbnj'nin diğer hazır sorgularını görmek için aşağıdaki dosyaya bakılabilir. Istenirse bu dosyaya yeni sorgular eklenebilir.
> **Hazır SQL Sorguları:** ```.pbnj-2.0/query.yaml```

**Sonuçlar**

```
Tue Dec 4 18:01:27 2018 _gateway domain up unknown version tcp  
Tue Dec 4 18:01:27 2018 _gateway http up unknown version tcp  
Tue Dec 4 18:01:27 2018 _gateway https up unknown version tcp
```



 **SQLite** kullanarak verilere aşağıdaki gibi bakılabilir.

 **Makinalar**

Sorgu
```
sqlite3 data.dbl 'select * from machines'
```

Sonuç
```
1|10.34.12.254|_gateway|0|unknown os|1543935687|Tue Dec 4 18:01:27 2018
```

**Servisler**

Sorgu

```
sqlite3 data.dbl 'select * from services'
```

Sonuç
```
1|domain|up|53|tcp|unknown version|unknown product|1543935687|Tue Dec 4 18:01:27 2018  
1|http|up|80|tcp|unknown version|unknown product|1543935687|Tue Dec 4 18:01:27 2018  
1|https|up|443|tcp|unknown version|unknown product|1543935687|Tue Dec 4 18:01:27 2018
```

**Basic syntax scanpbnj**

```
$ scanpbnj [Options] {target specification}

Target Specification

Can pass hostnames, IP addresses, networks, etc.

Ex: microsoft.com, 192.168.0.1, 192.168.1.1/24, 10.0.0.1-254

-i --iplist <iplist>
    Scan using a list of IPs from a file
-x --xml <xml-file>
    Parse scan/info from Nmap XML file

Scan Options

-a --args <args>
    Execute Nmap with args (needs quotes)
-e --extraargs <args>
    Add args to the default args (needs quotes)
--inter <interface>
    Perform Nmap Scan using non default interface
-m --moreports <ports>
    Add ports to scan ex: 8080 or 3306,5900
-n --nmap <path>
    Path to Nmap executable
-p --pingscan
    Ping Target then scan the host(s) that are alive
--udp
    Add UDP to the scan arguments
--rpc
    Add RPC to the scan arguments
-r --range <ports>
    Ports for scan [def 1-1025]
--diffbanner
    Parse changes of the banner

Config Options

-d --dbconfig <config>
    Config for results database [def config.yaml]
--configdir <dir>
    Directory for the database config file
--data <file>
    SQLite Database override [def data.dbl]
--dir <dir>
    Directory for SQLite or CSV file [def . ]

General Options

--nocolors
    Don't Print Colors
--test <level>
    Testing information
--debug <level>
    Debug information
-v --version
    Display version
-h --help
    Display this information
```

**Basic syntax outputpbnj**

```
$ outputpbnj [Query Options] [Config Options] [General Options]

Query Options

-q --query <name>
    Perform sql query
-t --type <type>
    Output Type [csv,tab,html]
-f --file <filename>
    Store the result in file otherwise stdout
--both
    Print results and store them in a file
--dir <dir>
    Store the result in this directory [def .]
-l --lookup <name>
    Lookup descrition based on name
--list
    List of names and descriptions
-n --name
    Lookup all the names
-d --desc
    Lookup all the descriptions
-s --sql
    Lookup all the sql queries

Config Options

--qconfig <file>
    Config of sql queries [def query.yaml]
--dbconfig <file>
    Config for accessing database [def config.yaml]
--configdir <dir>
    Directory for the database config file
--data <file>
    SQLite Database override [def data.dbl]

General Options

--test <level>
    Testing information
--debug <level>
    Debug information
-v --version
    Display version
-h --help
    Display this information
```

**Basic syntax genlist**
```
$ genlist -s <target> [options]

Options

-s, --scan <target>
    Ping Target Range ex: 10.0.0.\*
-n, --nmap <path>
    Path to Nmap executable
--inter <interface>
    Perform Nmap Scan using non default interface
-v, --version
    Display version
-h, --help
    Display this information
```


**Ahtapot Projesi**

Fatih USTA

fatihusta@labrisnetworks.com

