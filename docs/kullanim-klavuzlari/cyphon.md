# Cyphon Kullanımı
Bu dökümanda olay yönetimi yazılımı Cyphon'un kullanımı anlatılmıştır.
Kullandığınız herhangi bir internet tarayıcısı üzerinden cyphon'a erişim yapılır.
http://cyphon_ip_address

![cyphonlogin](../img/cyphon_login.png)

## Dashboard(Pano)
Sisteme giriş yapıldıktan sonra aşağıdaki gibi **pano** ekranı görüntülenir.
![cyphonlogin](../img/cyphon_dashboard.png)

Bu ekranda gelen uyarılara ait istatistiksel veriler yer alır. Bu ekranda **gün**, **hafta** ve **ay**  filtreleri kullanılarak ekrandaki verileri geçmişteki durumları görüntülenebilir.
>**Not:** Harita kullanımı için aşağıdaki siteye üye olunması gerekmektedir. Site'nin vermiş olduğu APIKEY'i kurulum sırasında tanımlanmış olmalıdır. Harita uygulaması online olarak çalışmaktadır. Site belli sayıdaki sorguları ücretsiz olarak servis etmektedir. 
>Daha fazla bilgi için: [https://www.mapbox.com/pricing/](https://www.mapbox.com/pricing/)

## Alerts(Uyarılar)
Bu ekranında oluşan bütün uyarılar görüntülenir.
![cyphonlogin](../img/cyphon_alert.png)

Bu ekran **Filtre bölümü, Uyar bölümü, Uyarı düzenleme bölümü** olmak üzere 3 bölümden oluşur.

### Filtre Bölümü
Bu alanda olay kayıtları **kategori, seviye, olay kaynağı, zaman ve ilgili kullanıcı** filtreleri kullanarak filtre yapılabilir.

### Uyarı Bölümü
Bu alanda uygulanan filtre'ye göre uyarılar görüntülenenir. İstenirse üst bar üzerindeki arama alanı kullanılarak uyarılar içinde arama yapılabilir.

### Uyarı düzenleme bölümü
Uyarı üzerine tıklanarak uyarı düzenleme alanı açılır. Bu ekranda uyarının **seviyesi, hangi kullanıcıya atanacağı** gibi alanlar yer alır. Ayrıca uyarıya ilişkin not yazılabilir ve uyarının detayları görüntülenebilir.

Bu ekranın sağ üst köşesindeki butona basılarak uyarı detaylarına ulaşılabilir.
![cyphonlogin](../img/cyphon_alert_detail.png)

**IP addressses** sekmesinde IP ile ilgili bilgi edinmek için araçlar bulunur.
![cyphonlogin](../img/cyphon_alert_ip_detail.png)

## Search (Arama)
Geçmiş uyarıları aramak için bu menü kullanılır. 
Arama alanına sol tarafta yer alan ve olay kaydına ilişkin **Fields**'lar görüntülenir. Bu anahtar kelimeler kullanılarak arama yapılabilir. 

![cyphonlogin](../img/cyphon_search.png)
Sağ tarafta bulunan **last weak, past hour** gibi ismi olan butona basılır. Tarih filtresi açılır.
![cyphonlogin](../img/cyphon_search_date_filter.png)

>**Not:** Admin paneli kullanımı için uyarı oluşturma dökümanında **cyphon** bölümüne [bakınız.](../kullanim-klavuzlari)


**Ahtapot Projesi**
Fatih USTA
fatihusta@labrisnetworks.com
