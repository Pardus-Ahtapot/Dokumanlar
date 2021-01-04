![ULAKBIM](../img/ulakbim.jpg)
# Güvenlik Duvarı Yönetim Sistemi Kullanımı
------

Bu dokümanda, Ahtapot Güvenlik Duvarı Yönetim Sisteminde güvenlik duvarı yönetimi anlatılıyor.

Gereken : GYDS Entegrasyonu yapılmış Ansible, Gitlab, GDYS2 sunucuları Pardus Temel ISO’ dan kurulumu tamamlanmış bir sunucu / sunucular

#### GDYS Web Yöneticisi üzerinden Güvenlik Duvarı Yönetim Sistemi kullanımı

- Konfigürasyonu yapılmış olan GDYS2 uygulamasında belirtilen host ve port bilgileri kullanılarak tarayıcı üzerinden GDYS2 Web Portalına erişim sağlanır.
![LOGIN](../img/gdys2/login.png)

- Gelen ekranda konfigürasyon sırasında belirlenene kullanıcı adı şifre değerleri girilerek (Varsayılan: kullanıcı adı: admin, şifre: LA123) ana ekrana erişim sağlanır.
![LOGIN](../img/gdys2/home.png)

- Ardından ekranda bulunan **Yeni güvenlik duvarı ekle** butonuna basılarak yeni bir güvenlik duvarı eklenilir. Burada Sırasıyla gelen;
  - **Firewall Adı** kısmına firewall'a ait fqdn bilgisi (örn: fw1.ahtapot.org)
  - **Haberleşme arabirimi adı** firewall ile haberleşmede kullanılacak interface bilgisi (örn: eth0)
  - **Haberleşme arabirimi adresi** kısmına haberleşme interfaceine ait ip adresi subnet'i **/32** olacak şekilde yazılır. (örn: 192.168.1.1/32)
![NEW_FW](../img/gdys2/new_fw.png)

- Yeni güvenlik duvarı oluşturulduktan sonra eğer güvenlik duvarı üzerine farklı interface ve ip tanımlamaları yapılmak isteniyorsa, güvenlik duvarı kartının sol üst tarafında bulunan üç noktaya tıklanır ardından **Ayarlar** sekmesine gidilir.
![NEW_FW](../img/gdys2/fw_settings_button.png)

- Bu ekranda daha önce eklemiş olduğunuz arabirim bilgileri ve bu arabirimlere ait adres tanımlamaları yer almaktadır. Arabirim kartı üzerindeki **> (Adres Adeti) Adres** butonuna basılarak arabirim üzerinde bulunan adreslere ait bilgilere görüntülenebilir. Bu adresler dilenirse yanlarında bulunan "**Güncelle**" butonu ile güncellenebilir. Dilenirse yanında bulunan **Sil** butonu ile silinebilir.
![IFACE_INFO](../img/gdys2/iface_info.png)

- Eğer Güvenlik Duvarı üzerine yeni arabirim eklenmek isteniyorsa en altta bulunan **Yeni interface ekle** butonuna basılır.
![IFACE_INFO](../img/gdys2/new_iface_button.png)

- Açılan pencerede arabirime ait bilgiler girilerek kaydet tuşuna basılır. Bu ekrandaki;
  - **Interface ismi** yerine arabirimi ait isim bilgisi girilir. (örn: enp0s1)
  - **Interface Tipi** kısmından eklenen interface'in tipi seçilir.
  - **Yapılandırma arayüzü** bu kısım eğer bu arabirim yapılandırma arabirimi olarak seçilmek isteniyorsa **evet** konumuna getirilmelidir. Bu durum da daha önce **Yapılandırma arayüzü** olarak seçilen arabirimden bu rol kaldırılarak yeni eklenen arabirim üzerine atanacaktır. Eğer yapılandırma arabirimi değiştirilmek istenmiyorsa burası **hayır** konumunda bırakılmalıdır.
![NEW_IFACE](../img/gdys2/new_iface.png)  

- Yeni eklenen arabirim üzerine yeni bir adres eklenmek isteniyorsa; aşağıdaki adımlar takip edilerek **yeni adres ekle** butonuna tıklanır.
![ADD_ADDR_TO_IFACE_BUTTON](../img/gdys2/add_addr_to_iface_button.png) 

- Daha sonra açılan pencerede eklenecek olan adres için;
  - **Adres İsmi** girilir. (örn: WAN)
  - **Adres** değeri subnet'i **/32** olacak şekilde girilir. Ardından kaydet tuşuna basılır.
![ADD_ADDR_TO_IFACE](../img/gdys2/add_addr_to_iface.png) 

- Bu işlemler ardından güvenlik duvarı GDYS sistemi üzerine eklenmiş olacaktır. Yapılan değişikliklerin güvenlik duvarı üzerine gönderilebilmesi için uygulanması gerekmektedir.

### Değişikliklerin Uygulanması
- Yapılan değişikliklerin uygulanabilmesi için yukarıda bulunan **Uygula** butonuna basılır.
![APPLY_BUTTON](../img/gdys2/apply_button.png) 

- Açılan pencerede yapılan değişiklikler incelenir. Eğer değişiklikler uygulanmak isteniyorsa aşağıda bulunan **Uygula** eğer geri alınmak yani discard edilmek isteniyorsa **Eski haline çevir** butonuna basılır.
![APPLY_MODAL](../img/gdys2/apply_modal.png)

- Ardından değişiklikler bütün firewall scriptlerini yeniden oluşturacak şekilde onaylanmak isteniyorsa;
  - **Uygulanacak Firewallar** kısmı hepsi olarak seçilmelidir. Eğer belirli firewallar üzerinde uygulanmak isteniyorsa liste açılarak istenilen firewallar seçilmelidir.
  - **Onaylama Mesajı** kısmına ise yapılan değişikliklerin açıklaması özet haline yazılarak **Uygula** butonuna basılır.
  - Böylelikle yapılan değişiklikler seçili firewallar üzerinde uygulanır ve git sunucusuna kaydedilir.
  ![APPLY_MODAL_LAST](../img/gdys2/apply_modal_last.png)
  
### Adres Tanımlamaları
 - Sol taraftaki menü üzerinden **Adresler** sekmesine tıklanır.
 ![ADDRESSES_BUTTON](../img/gdys2/addresses_button.png)
 
 - Açılan ekranda daha önce eklenmiş olan adresler listelenmektedir.
 ![ADDRESSES_TABLE](../img/gdys2/addresses_table.png)
 
 - Yeni bir adres eklenmek isteniyorsa yukarıda bulunan **Yeni adres ekle** butonuna basılır.
 ![NEW_ADDR_BUTTON](../img/gdys2/new_addr_button.png)
 
 - Ardından açılan ekranda;
   - Adres tanımlamasına ait isim girilir.
   - Eklenen adresin Tür'ü girilir. 
   - Ardından istenilen değerler doldurulur ve **Kaydet** butonuna tıklanır.
 ![ADD_NEW_ADDR](../img/gdys2/add_new_addr.png)
 
 - Eğer bir adres bilgisi güncellenmek veya silinmek istenirse adres kaydına ait satırın sonunda bulunan üç noktaya basılarak istenilen işlem gerçekleştirilir.
 * Not: Eğer Tekil bir makineye ait adres eklenmek isteniyorsa **Tür: Netmask** seçilerek **Subnet** değeri **32** olarak seçilir.
 
### Servis Tanımlamaları
