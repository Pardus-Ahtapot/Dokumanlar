![ULAKBIM](../img/ulakbim.jpg)
#Merkezi Güvenlik Duvarı Yönetim Sistemi Kontrol Paneli
------


Bu dokümanda, Ahtapot bütünleşik güvenlik yönetim sisteminde kullanılan Merkezi Güvenlik Duvarı Yönetim Sistemi uygulamasının yapılandırması, arayüz özellikleri ve kullanımı anlatılıyor.

[TOC]

------

####Uygulama Çalışma Prensipleri

Uygulamanın amacı güvenlik duvarı yapılandırmalarında yapılan değişiklikleri merkezi sürüm takip sisteminde takip edilerek, yetkili kişiler tarafından onaylanmasını ve gerekli olduğu durumlarda erişebilmek amacı ile geçmişe yönelik değişikliklerin kayıt altına almaktır. Uygulama Firewall Builder’ın install özelliğinde kullandığı betik sisteminin yerini alarak işlemleri ve özellikleri genişletmektedir. Uygulama açıldığı anda çıkan pencere merkezi sürüm takip sistemi, test makinası katmanlarının ait özelliklerin tek bir yerden yönetilmesini sağlar.
Bu uygulama kullanıldığında her bir install işlemi için sırasıyla aşağıdaki adımlar gerçekleşir.

------

1) Firewall Builder uygulamasının yarattığı kabuk betiğinde bulunan ağ arabirim IP adres yapılandırmaları çıkartılır ve sadece güvenlik duvarı kurallarını betik içinde bırakır.

------

2) Ağ arabirim IP adresi yapılandırmalarının çıkartıldığı kabuk betiği test makinasına scp komutu çalıştırılarak kopyalanır ve kopyalanan betik çalıştırılır. Betikten alınan işlem ve hata çıktıları hata dosyasına kaydedilir. Test makinasında denetleme işlemi başarı ile sonuçlandığında kopyalanan betik dosyaları silinir. Test makinasında denetleme işleminde hata oluşunca Firewall Builder arayüzünde “Hata bulundu : ” çıktısı gözlemlenir. Bu hatalar syslog servisi ve hata kütük dosyasına da gönderilir.

------

3) Test makinasında denetim işlemlerinde sonra sürüm takip sisteminin (git) yerel kopyasını denetler ve hata var ise “Git ile ilgili bir hata mevcut, 'git status' komutu ile kontrol ediniz.” çıktısı ekranda yansır. Hata yok ise yapılan değişiklikler, değişen her bir dosya için, yerel kopyaya commit edildikten sonra merkezi sürüm takip sisteminde onay dalına gönderilerek birleştirme isteği (merge request) an itibariyle kullanıcının ismi ile, yaratılır.

------

4) Bütün bu süreç hatasız tamamlandığında “Hatasız Tamamlandı. Firewall Builder 15 saniye sonra kapanacaktır...” çıktısı ekrana yansır. 

------

####Uygulama Arayüz Öğeleri Açıklamaları

**Yerel Ayarlar ile Çalıştır:** Firewall Builder uygulamasını istemci bilgisayarın çalışma ortamında bulunan yapılandırma (.fwb) dosyası ile çalıştırır. 

**Onaylanmış Ayarlar ile Çalıştır:** Firewall Builder uygulamasını merkezi sürüm takip sisteminde en son onaylanmış kurallar ile çalıştırır ve istemci bilgisayarın yerel yapılandırmaları üstüne kayıt eder. Bu yapılandırmalar onaylandıktan sonra uç noktada bulunan güvenlik duvarı sunucularında etkin ve güncel çalışan kurallardır.

**Onaylanmış Ayarları Göster:** Merkezi sürüm takip sisteminde onaylanmış son kuralları istemci bilgisayarın yerel yapılandırması üzerine yazmadan, Firewall Builder uygulamasını sadece okuma kipinde açar. Bu özellik uç noktada bulunan güvenlik duvarlarında etkin kuralları gözlemleyerek yeni kuralların düzgün ve başarılı girilmesine yardımcı olur.

**Onay Kontrol:** Onay dalına gönderilen birleştirme talebinin durumunu sorgulayıp yeniler. Güvenlik duvarları için yapmış olduğumuz değişikliklerin onay dalındaki durumunu sorgulayıp işin takibini kolaylaştırmayı hedefleyen bir özelliktir.

**Son Onaylanmış Commit ID:** Merkezi sürüm takip sisteminde onaylanmış son commit’in kimliği. Merkezi sürüm takip sistemi, yapılan bütün değişikliklere bir kimlik atar. Bu yöntem geçmişe yönelik yapılacak işlemlerde kolaylık sağlar.

------

####Menü → Düzenle → Yapılandırma Ayaları:

**Kilidi Aç:** Yapılandırmaları düzenleyebilmek için merkezi yönetim sistemi sunucusunda root kullanıcısı yetkilerine parola ile geçiş sağlar. Bu özellikle yapılandırmalarımıza bir güvenlik katmanı eklemiş oluyoruz. Uygulamanın yardımcı yan uygulamalara erişim bilgileri gibi hassas bilgilerin bulunduğu bu alana erişim parola kullanımı ile sağlanmaktadır.

------

####GitLab Yapılandırma:

**GitLab Bağlantı Adresi:** Merkezi Sürüm Takip Sistemi uygulamasına erişmek için, tarayıcınızda da kullanılan bağlantı adresi. Uygulama, GitLab yani Merkezi Sürüm Takip Sistemi’ne HTTP veya HTTPS protokolü üzerinden bağlanarak **Onay Kontrol, Son Onaylanmış Commit ID** gibi özelliklerin çalışmasını sağlar. Bu veri yanlış girildiğinde uygulama çalışmayacaktır.

------

**GitLab Kullanıcı Adı:** Merkezi Sürüm Takip Sistemi uygulamasında oturum açmak için kullanılan API kullanıcı adı. GitLab bağlantı adresi ile birlikte bağlantıda gerçekleşecek kimlik doğrulamasında kullanılacak kullanıcı adıdır. Bu veri yanlış girildiğinde uygulama çalışmayacaktır.

------

**GitLab Kullanıcı Parolası:** Merkezi Sürüm Takip Sistemi uygulamasında oturum açmak için kullanılan kullanıcı parolasıdır. Merkezi sürüm takip sistemine gerçekleşecek bağlantıda kimlik doğrulaması yapılırken kullanılacak parola bilgisinin girildiği yerdir. Bu veri yanlış girildiğinde uygulama çalışmayacaktır.

------

**GitLab Onay Dalı:** Yapılan değişikliklerin üst birim tarafından denetlenip onaylanacağı git deposu dalının adı. Denetleme işlemleri güncellenecek yapılandırmaların uç noktadaki güvenlik duvarı sunucularında sistemin bütünlüğü ve kararlı çalışmasını sağlamak açısından büyük önem taşımaktadır.

------

**GitLab Ana Dal:** Git deposunun ana dalının adı. Değişiklikler onay dalında onaylandıktan sonra ana dalda birleştirilir. Bu birleştirme işleminde sonra değişiklikler uç noktalarda bulunan güvenlik duvarı sunucularında çalıştırılacak şekilde merkezi yapılandırma aracı tarafından işleme alınır.

------

**GitLab Proje Adı:** Merkezi Sürüm Takip Sistemi’nde bulunan deponun adı. Bu depo yapılandırmalarda yapılan değişikliklerin geçmişe yönelik takip edilmesi için sistemde konumlandırılmıştır. Güvenlik duvarı sistemlerinde yapılan her türlü değişiklik bu depoda kayıt altına alınır. Verinin yanlış girilmesi halinde uygulama çalışmayacaktır.

------

####Dizin Yapılandırma:

**Yapılandırma Dosya Adı:** Güvenlik duvarı ayarlarının bulunduğu Firewall Builder yapılandırma dosyası. Firewall Builder uygulamasında yapılan değişiklikler bu dosyaya kaydedilir ve Firewall Builder arayüzünden yapılan Install işlemi ile değişiklikler ilgili uç birimlere göndermek için hazırlanır. Dosyanın uzantısı .fwb olmalıdır. Verinin yanlış girilmesi halinde uygulama çalışmayacaktır

-------

**Test Betikleri Dizini:** Firewall Builder ile oluşturulan kural betikleri, test makinasında iptables kurallarının doğru çalışıp çalışmadığını test etmek için gerekli olmayan fonksiyonları (verify_interfaces, change_interfaces vb.) ayrıştırır ve yeni bir betik dosyası oluşturulur. Bu dosya test makinasına gönderilmeden önce bu dizine konumlandırılır. Bu dizinden de test makinasına kopyalama işlemi yapılır. Test işlemi yapıldıktan sonra, kopya betikler silinir, bu şekilde bir sonraki çalışmalarla çakışmalar önlenir. Bu dizin uygulamanın çalıştığı dosya sistemi üzerindedir. Verinin yanlış girilmesi halinde uygulama çalışmayacaktır..

------

**Hata Bildirim Dizini:** Test makinasına yapılan değişikliklerin denetimi esnasında karşılaşılan hataların yazıldığı dizin. Hataları .stderr ve .stdout son ekine sahip dosyalara yazar. Uygulamada karşılaşılan sorunların geçmişe yönelik araştırılması ve hata giderme süreçleri için bu dosyalar önem taşımaktadır. Verinin yanlış girilmesi halinde uygulama çalışmayacaktır.

------

**Test Makinası IP Adresi:** Bu sunucunun erişilebilir IP adresinin girileceği alandır. Güvenlik duvarlarında yapılan değişikliklerin ağ arabirim ile ilgili bölümleri devre dışı bırakarak önceden kurulmuş ve yapılandırılmış bir sunucuya gönderilir ve ilgili sunucuda test edilir. Bu aşama değişen güvenlik duvarı kurallarının onaydan önce test edilmesi açısından önemlidir. Bu sunucu altyapıda bulunmadığı ve verilerinin yanlış girilmesi halinde uygulama çalışmayacaktır. 

------

**Test Makinası Kullanıcı Adı:** Test makinasına erişim kimlik doğrulamasında sağlanacak kullanıcı adı. Bu veri girilmediyse uygulama çalışmayacaktır.

------

**Test Makinası Betik Dizini:** Yapılan değişiklikler sonucu yaratılan betik dosyasının test makinasında konumlanacağı dizin. İlgili sunucuda bu dizin oluşturulup dizin hakları doğru verilmediyse uygulama çalışmayacaktır.

------

**Onay Mekanizması:** Açık olduğunda yapılan değişiklikler Merkezi Sürüm Takip Sistemi’ne (GitLab) onay alınması için deponun onay dalından ana dala birleştirme isteği gönderilir; kapalı olduğunda onay dalını atlayarak ana dala direk birleşir. Ana dala birleşen değişiklik Merkezi Yapılandırma Sistemi tarafından işleme alınır.

------

####Menü → Yardım →

Açıklamalar: Etkin penceredeki öğeler hakkında detaylı bilgi verir.
Hakkında: Uygulama hakkında kısa bilgi verir.


**Sayfanın PDF versiyonuna erişmek için [buraya](merkezi-guvenlik-duvari-yonetim-sistemi-kontrol-paneli.pdf) tıklayınız.**

