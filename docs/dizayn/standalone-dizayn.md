![ULAKBIM](../img/ulakbim.jpg)
#Standalone Rolü ve Dizaynı
------

Standalone rolü uç sistemlerin yapılandırma değişiklerini git sunucu üzerinden çekmesi ve kendi üzerinde çalıştırması ya da MYS cihazının değişiklileri otomatik bir şekilde uç birimlere aktarabilmesi için kullanılmaktadır.

Bu dökümanda bu rolün dizaynı anlatılmıştır. 

------

* Kurulum dökümanında anlatıldığı gibi bir host standalone olarak eklendiginde ve playbook calistirildiginda, uç makinaya ansible kurulur. Cron yapılandırması yapılarak makinanın belirli zamanlarda yapılandırma değişiklikleri kontrol edilir. Cron zamanı vars dosyasından ayarlanabilir. 

* Bu yapılandırmanın MYS tarafında her push tarafından tetiklenmesi isteniyorsa aşağıdaki gibi alias tanımlanmalıdır. 

$ **git config alias.xpush '!git push $1 $2 && ansible-playbook/etc/ansible/playbooks/standalone.yml'**


* Son olarak herhangi bir yapılandırmanın her bir commit sonrası uygulanması için post-commit hookuna aşağıdaki komut eklenir. Bu script MYS cihazına standalone playbooku tarafından yuklenmektedir.

**/usr/sbin/ahtapot_standalone.py --push** 

* Bu komut playbook tarafından cron a eklenmektedir. İstenildiği taktirde manual olarak da çalıştırılabilir. 


* Standalone playbooku çalıştırıldıtan sonra makinalar aşağıdaki şemaya uygun çalışır. 


![standalone](../img/standalone.png)



**Sayfanın PDF versiyonuna erişmek için [buraya](standalone-dizayn.pdf) tıklayınız.**
