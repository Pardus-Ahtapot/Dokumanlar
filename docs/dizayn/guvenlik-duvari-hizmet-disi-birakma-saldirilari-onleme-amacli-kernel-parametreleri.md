![ULAKBIM](../img/ulakbim.jpg)
#Güvenlik Duvarı Hizmet Dışı Bırakma Saldırıları Önleme Amaçlı Kernel Parametreleri
------

Bu dokümanda, Ahtapot Güvenlik Duvarı Yönetim Sisteminde hizmet dışı bırakma saldırılarını önlemek amacı ile Ansible Playbook tarafından düzenlenen Kernel Parametreleri anlatılıyor.

[TOC]

------


Güvenlik Duvarı Yönetim Sistemi kurulumu sırasında çalıştırılan “firewall.yml” playbooku ile birlikte, Kernel seviyesinde güvenlik duvarı sıkılaştırmaları yapılmaktadır. İlgili playbook ile gerçekleştirilen sıkılaştırmaların anlamları aşağıda belirtilmiş olup, dokümanın sonunda yer alan tablo ile işletim sistemi kurulumu sonrasında ön tanımlı gelen değerler ve ne şekilde değiştirildiği gösterilmektedir.


####Değişiklik Yapılan Parametreler

- **$SYSCTL_CONNTRACK**

Bu değer aynı anda çekirdek hafızasındaki güvenlik duvarı tarafından işlenebilecek bağlantı sayısıdır. Değerin çok büyük olması gereksiz yere hafızanın tüketilmesine neden olurken, çok düşük olması da tüm ya da kimi bağlantıların red edilmesine neden olabilir.


- **$SYSCTL_LOGMARTIANS**

Bu Sysctl (Sistem kontrol) seçeneği, kaynağı belirsiz/imkansız olan adreslerden oluşan tüm ağ trafiğini kaydedecektir. Bu seçenek sayesinde, kullanılmadığında farkına varılmayacak olan ağ üzerindeki sorun ya da saldırılar tespit edilebilir.

- **$SYSCTL_ECN**

Bu sistem denetim seçeneği ECN desteğini kontrol etme özelliğini sağlar. Bu özellik, ağdaki tıkanıklık için geliştirilmiş olup gönderim paketlerini sıradan çıkarmak (drop) yerine daha sonra göndermek üzere işaretlemesidir. 

- **$SYSCTL_SYNCOOKIES**

Bu sistem denetim seçeneği SynCookies özelliğinin kullanımını sağlar. Bu özellik SYN backlog için kullanılan soketin çok yoğun olduğu zamanlarda SYN çerezi oluşturulmasını sağlar. Bu çerez (cookie), gönderen sunucu ile karşılatırılmak üzere, SYN iletişimlerini hash’lenmiş bir sıra numarasıyla keser. Hash gönderen host adresi, paket bayrakları gibi detaylardan oluşturulur ve eğer gönderen sunucu hash’i onaylayamazsa TCP-Handshake kapatılır. Kısacası SYN-Flood saldırılarını azaltmak için kullanılır.

- **$SYSCTL_OVERFLOW**

Bu seçenek Abort_On_Overflows özelliğini kullanılmasını sağlar. Bu özellik dinleyici servisinin yeni bağlantıları çok yavaş kabul ettiğindeki birikmeyi, yoğunluğu en aza indirir. Bu seçenek SynCookies özelliğinin alternatifidir ve bu iki özellik aynı anda asla kullanılmamalıdır. 

**NOT: Bu özellik sistemine ulaşan istemcilerde soruna neden olabilir. Sadece Dinleyici servisinin daha fazla bağlantı kabul edebileceği ayarların yapılamadığı zamanlarda kullanılmadır.**

- **$SYSCTL_TCP**

Bu sistem denetim özelliği TCP kimi değişkenlerinin değiştirilmesini engeller, böylece hızlı verimlilik ya da güvenirlik için değiştirilen diğer TCP parametreleri yüzünden etkilenmeleri engellenir.

- **$SYSCTL_SYN**

Bu seçenek SYN retry, synbacklog ve SYN timeout değerlerini düşürerek SYN-Flood ataklarını azaltmak için kullanılır.

- **$SYSCTL_ROUTE**

Bu sistem denetim seçenekleri sahte paketlere ve IP/ARP/Route yeniden yönlendirmelerine karşı koruma sağlamaktadır. Eğer NAT/MASQ gibi gelişmiş routing politikaları kullanılıyorsa bu özellik kapatılmalıdır.

- **ip_conntrack_max:** Bağlantı takibi, varsayılan değerlerle belli bir değere kadar aynı zamanlı bağlantılar için yapılabilir. Burada kullanılacak değer sistem üzerindeki maksimum Bellek büyüklüğüne göre ayarlanır.

- **nf_conntrack_max:** Bağlantı takip tablosu büyüklüğü.

- **nf_conntrack_tcp_timeout_time_wait:** Bu değer soketin ağdaki paketlerin kabülünü kaç saniye sonra durduracağını belirler.

- **ip_conntrack_tcp_timeout_established:** Bir bağlantı kurulu durumda iken, FIN paketi herhangi bir yönde geçtiği zaman tablodan çıkmalıdır. Bu parametre ile bağlantıların ne kadar süre ile bu tabloda kalacağı belirlenir.

- **ip_conntrack_tcp_timeout_time_wait:** Bu değer soketin ağdaki paketlerin kabülünü kaç saniye sonra durduracağını belirler.

- **ip_local_port_range:** Bu değer TCP ve UDP trafiğinin yerel ağ kapılarına ulaşacağı aralığı belirler.

- ** icmp_ignore_bogus_error_responses:** Bazı Router’lar ağdaki broadcast’lere karşılık olarak sahte karşılıklar verir. Normalde bu tarz kural dışı durumlar çekirdek kayıt özelliği ile kayıt altına alınır, ama kayıtlar arasında çok sayıda hata mesajı görülmesi istenilmiyorsa bu özelliğin kullanılması faydalı olacaktır. Öte yandan bu şekilde çalışan bir router ile mesafe kısa olursa hiç kayıt tutulmaması disk alanı üzerinde tasarruf sağlayacaktır.

- **icmp_echo_ignore_broadcasts:** Bu değer sadece broadcast ya da multicast adreslere yapılan ICMP mesajlarının engeller.

- **log_martians:** Bu değer çekirdeğe, içeriğinde sahte/yanlış adres bulunduran, tüm paketlerin çekirdeğin kayıt özelliği sayesinde kayıt altına alınmasını saglar.

- ** tcp_ecn:** TCP’nin ECN’i kullanmasına olanak sağlar. ECN sadece TCP hattının iki ucunun da desteklendiği zamanlarda kullanılır. Bu özellik, desteklenen router’larda paketi düşürmeden önce tıkanıklık sinyali göndererek, tıkanıklık nedeniyle kayıpların önüne geçmekte yardımcı olur. 

- **tcp_syncookies:**  Sadece CONFIG_SYN_COOKIES özelliğinin kullanıldığı zaman geçerlidir. SYN backlog’ları soket üzerinde tıkanıklık yaşadığında SYN-Cookies gönderilir. Çok yoğun sunucular üzerinde yasal bağlantı yüzdesini sağlayabilmek için kullanılmamalıdır. SYN-Cookies TCP protokolü ihlal eder, TCP uzantılarıyla birlikte kullanılmamalıdır, aksi takdirde bazı servislerin düzgün çalışmamasına neden olabilir.

- **tcp_abort_on_overflow:** Eğer sınırlamalarda dolayı birikme yaşanıyorsa bağlantıyı tekrar oluşturur.

- **tcp_tw_recycle:** TIME-WAIT soketlerinde hızlı şekilde boşaltım sağlar.

- **tcp_tw_reuse:** Protokol tarafından güvenilir olduğunda TIME-WAIT soketlerinde tekrar bağlantı sağlanmasına izin verir.

- **tcp_window_scaling:** RFC1323’te belirtildiği gibi pencere ebatlandırma yapılmasına izin verir.

- **tcp_timestamps:** RFC1323’te belirtildiği gibi zaman damgası özelliğinin kullanılmasını sağlar.

- **tcp_sack:** Seçilen bildirimlerin (SACKS) kullanılır olmasını sağlar.

- **tcp_dsack:** TCP’nin birden fazla aynı SACK göndermesini sağlar.

- **tcp_fack:** Geri iletimlerde FACK tıkanıklarını göz ardı eder.

- **tcp_keepalive_time:** Keepalive özelliğinin kullanıldığı durumlarda TCP’nin ne kadar süre aralıklarla keepalive mesajı göndereceğini belirler.

- **tcp_fin_timeout:** Sahipsiz bir bağlantının yerel uçta iptal edimeden önce FIN_WAIT_2 durumunda ne kadar kalacağını belirler.

- **tcp_retries1:** Bu değer RTO onaylanmamış geri iletimlerinden oluşan hata durumlarında ağ katmanına sorun olduğunu belirtmeden bekleyeceği süreyi belirtir.

- **tcp_synack_retries:** Pasif bir TCP baglantısı için SYNACK’lerin kaç kere iletileceğini belirler.

- **tcp_syn_retries:** Aktif TCP bağlantıları için SYN’lerin kaç kere iletilceğini belirler

- **tcp_max_syn_backlog:** Bağlantı kuran sunucudan onay alamamış bağlantı taleplerinin kaç tanesinin kayıt altında saklancağını belirler.

- **rp_filter:** Bu paramtere belirlenen bir arabirim üzerinde RP süzgeci oluşturur. Route tablosundaki paket bilgileri doğrultusunda gerçek kaynak adres bilgisini kontrol edip, belirlenen kaynak erişim adresi üzerinden gelen paket isteklerini yine aynı arabirim tarafından cevaplanmasını sağlar.

- **accept_source_route:** Bu özellik kaynaktan route edilmiş paketlerin kabul edip edilmeyeceğini belirler.

- **bootp_relay:** bootp_relay değişkeni 0.b.c.d kaynak adresi ile ilgili sunucuya yerel paket olarak hedeflenmeden gelen paketleri kabul etmekle yükümlüdür. Böylece BOOTP relay daemon’ı bu paketleri yakalar ve doğru hedefe gönderecektir. 

- **ip_forward:** Ip_forward sunucu üzerinde paketlerin route etmesini kapatır ya da açar.

- **secure_redirects:** Bu özellik güvenli yönlendirmeleri mümkün kılar. Eğer kapatılırsa Linux çekirdeği herhangi bir sunucudan ya da yerden gelen yönlendirilmiş tüm ICMP’leri kabul eder.

- **send_redirects:** Send_redirect opsiyonu Linux çekirdeğine  yönlendirilmiş ICMP paketlerini diğer sunuculara da göndermesini sağlar. Bu özellik sadece sunucu router gibi bir özellikle çalışacak şekilde çalışıyorsa kullanılmalıdır.

- **proxy_arp:** Bu değişken kernel belirgin aygıtlar için Proxy ARP’ı açar ve kapatır. Proxy ARP başka sunucular için ARP sorgularını yanıtlayan otomatik sistemdir, örnek verecek olursak diğer ağ segmentlerinde iletişimde bulunan sunucular geçerlidir. Bu seçenek diğer router’ların diğer ağ ve sunuculara nasıl bağlanacaklarını bilemediği belirli durumlar için gerekli olabilir. Linux güvenlik duvarı ve router’ları bu seçenekle ARP sorgularını diğer sunuculara vekilen cevaplayacaktır. 

####Kernel Parametrelerin Karşılaştırılması

| Parametre                                                             | Öntanımlı Değer                  | Tavsiye Edilen Değer                                |
| --------------------------------------------------------------------- | -------------------------------- | --------------------------------------------------- |
| /proc/sys/net/ipv4/ip_conntrack_max                                   | 65536                            | 65536                                               |
| /proc/sys/net/nf_conntrack_max                                        | nf_conntrack_buckets value * 4   | 65536                                               |
| /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_established          | 432000                           | 600                                                 |
| /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_time_wait            | 120                              | 90                                                  |
| /proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_timeout_established     | 432000                           | 600                                                 |
| /proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_timeout_time_wait       | 120                              | 90                                                  |
| /proc/sys/net/ipv4/ip_local_port_range                                | 32768 - 61000                    | 24576 - 65534                                       |
| /proc/sys/net/ipv4/icmp_ignore_bogus_error_responses                  | 0                                | 1                                                   |
| /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts                        | 0                                | 1                                                   |
| /proc/sys/net/ipv4/conf/$IFACE_IN/log_martians                        | 0                                | SYSCTL_LOGMARTINS=1 -> 1 SYSCTL_LOGMARTINS=0 -> 0   |
| /proc/sys/net/ipv4/conf/$IFACE_OUT/log_martians                       | 0                                | SYSCTL_LOGMARTINS=1 -> 1 SYSCTL_LOGMARTINS=0 -> 0   |
| /proc/sys/net/ipv4/tcp_ecn                                            | 2                                | SYSCTL_ECN=1 -> 1 SYSCTL_ECN=0 -> 0                 |
| /proc/sys/net/ipv4/tcp_syncookies                                     | 0                                | SYSCTL_SYNCOOKIES=1 -> 1 SYSCTL_SYNCOOKIES=0 -> 0   |
| /proc/sys/net/ipv4/tcp_abort_on_overflow                              | 0                                | SYSCTL_OVERFLOW=1 -> 1 SYSCTL_OVERFLOW=0 -> 0       |
| /proc/sys/net/ipv4.tcp_tw_recycle                                     | 0                                | SYSCTL_TCP=1 -> 0                                   |
| /proc/sys/net/ipv4.tcp_tw_reuse                                       | 0                                | SYSCTL_TCP=1 -> 1                                   |
| /proc/sys/net/ipv4/tcp_window_scaling                                 | 1                                | SYSCTL_TCP=1 -> 1                                   |
| /proc/sys/net/ipv4/tcp_timestamps                                     | 1                                | SYSCTL_TCP=1 -> 0                                   |
| /proc/sys/net/ipv4/tcp_sack                                           | 1                                | SYSCTL_TCP=1 -> 1                                   |
| /proc/sys/net/ipv4/tcp_dsack                                          | 1                                | SYSCTL_TCP=1 -> 1                                   |
| /proc/sys/net/ipv4/tcp_fack                                           | 0                                | SYSCTL_TCP=1 -> 1                                   |
| /proc/sys/net/ipv4/tcp_keepalive_time                                 | 7200                             | SYSCTL_TCP=1 -> 1200                                |
| /proc/sys/net/ipv4/tcp_fin_timeout                                    | 60                               | SYSCTL_TCP=1 -> 20                                  |
| /proc/sys/net/ipv4/tcp_retries1                                       | 3                                | SYSCTL_TCP=1 -> 3                                   |
| /proc/sys/net/ipv4/tcp_synack_retries                                 | 5                                | SYSCTL_SYN=1 -> 2                                   |
| /proc/sys/net/ipv4/tcp_syn_retries                                    | 6                                | SYSCTL_SYN=1 -> 3                                   |
| /proc/sys/net/ipv4/tcp_max_syn_backlog                                | Min Value=128                    | SYSCTL_SYN=1 -> 4096                                |
| /proc/sys/net/ipv4/conf/$IFACE_IN/rp_filter                           | 0                                | SYSCTL_ROUTE=1 -> 1 SYSCRL_ROUTE=0 -> 0             |
| /proc/sys/net/ipv4/conf/$IFACE_OUT/rp_filter                          | 0                                | SYSCTL_ROUTE=1 -> 1 SYSCRL_ROUTE=0 -> 0             |
| /proc/sys/net/ipv4/conf/$IFACE_IN/accept_source_route                 | 1                                | SYSCTL_ROUTE=1 -> 0                                 |
| /proc/sys/net/ipv4/conf/$IFACE_OUT/accept_source_route                | 1                                | SYSCTL_ROUTE=1 -> 0                                 |
| /proc/sys/net/ipv4/conf/all/bootp_relay                               | 0                                | SYSCTL_ROUTE=1 -> 0 SYSCRL_ROUTE=0 -> 1             |
|                                                                       |                                  |                                                     |

**Sayfanın PDF versiyonuna erişmek için [buraya](guvenlik-duvari-hizmet-disi-birakma-saldirilari-onleme-amacli-kernel-parametreleri.pdf) tıklayınız.**
