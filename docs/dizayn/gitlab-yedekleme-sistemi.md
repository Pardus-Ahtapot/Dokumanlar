![ULAKBIM](../img/ulakbim.jpg)
#Gitlab Yedekleme Sistemi
------

Bu betik Merkezi Yönetim Sisteminin yedeğini almaya ve ikinci bir makineye aktarılıp yüklenmesine yarar.
Betik crontab’da belirtilen süre aralığında otomatik olarak çalışarak işlemleri gerçekleştirir. Betiğin sorunsuz 
çalışabilmesi için her iki makinedeki Merkezi Yönetim Sistemi yazılımlarının sürümleri aynı olmak zorundadır.

[TOC]

------

####Betik Çalışma Prensibi

Merkezi Yönetim Sisteminin sürekli yedeklenmesini sağlamak için, yapılan herhangi bir değişiklikte yedeğinin alınmasını sağlamak için GDYS-GUI’de yapılan herhangi bir işlemden sonra yedekleme işleminin gerçekleştirilmesi amacıyla aşağıdaki yöntemler uygulanmıştır.

------

####Betik Çalıştırılmadan Önce Yapılması Gerekenler 

Betiğin çalışabilmesi için öncelikle ana sunucuda “git” kullanıcısının yedeklenecek sunucuya bağlanabilmesi için yetki gerekmektedir. Ana makinenin yedek makinesine erişebilmesi için ssh anahtarının merkezi anahtar otoritesi tarafından imzalanması gerekmektedir. Bunun için :

- 1) Ana makinede ssh anahtarının üretilmesi gerekmektedir. Bunun için aşağıdaki komutlar çalıştırılır.

```
# su - git
$ ssh-keygen
```

- 2) Yukarıdaki komut ile oluşturulan anahtarlardan public olanı, merkezi anahtar otorite makinesine taşınarak anahtar imzalama dokümanındaki işlemler uygulanarak, “git” kullanıcısının ana makineden yedek makineye erişebilmek için gerekli seçenekler kullanılarak imzalanmalıdır.
- 3) İmzalanan anahtarın sertifika dosyası “id_rsa-cert.pub” , “git” kullanıcısının anahtarlarının yanına taşınır.


------

####Önemli Notlar

Custom Hookslar git uygulamasına özel bir şey olduğundan dolayı, GitLab’da yapılan değişikliklerden sonra tetiklenmez, sadece git depo’su üzerinde yapılan değişikliklerden sonra tetiklenir. Bu sebepten dolayı :

- 1) GDYS-GUI arayüzünden değişiklikler yaptıktan sonra, onaya göndermeden kaydedip çıkılır ise hook tetiklenmeyecektir. Onaya gönderme işlemi yapıldığında yani depo’ya push işlemi gerçekleştiğinde hook tetiklenecektir.
- 2) Eğer onay mekanizması kapalıysa, işlemler gönderildikten sonra otomatik yedekleme işlemi yapılacaktır. Ancak onay mekanizması açık ise, Hook sadece onaya gönderilen işlemlerden sonra tetiklendiğinden merge request oluştuktan sonra tetiklenmeyecektir. Ancak GitLab arayüzünden “Merge Request” onaylanır veya reddedilirse depo üzerinde değişiklik oluşacağından yine hook tetiklenerek yedekleme işlemi otomatik yapılacaktır.

**Sayfanın PDF versiyonuna erişmek için [buraya](gitlab-yedekleme-sistemi.pdf) tıklayınız.**
