
# Gitlab Container Kurulum Yönergesi

Bu dokümanda, Ahtapot projesi kapsamında gitlab yazılımının Ansible (MYS) makinesi üzerinde container içerisinde merkezi yönetim sisteminin ihtiyaçlarına cevap verecek şekilde nasıl kurulacağı anlatılmaktadır.

### Gitlab Container Sistemi Kurulum İşlemleri

#### Ön Hazırlıklar

- Gitlab container sistemi Ansible makinesi üzerinde GitLab yazılımını bir LXC container olarak kurularak oluşturulur. Bu noktada lxc network modu MACVLAN olarak kullanılmaktadır. Bundan dolayıdır ki sunucu üzerinde minimum **2** adet **ağ arabirimi (NIC)** bulunmalıdır. Bunlardan bir tanesi MYS makinesinin diğer bileşenler ile haberleşmesi için kullanılırken diğer NIC container içerisindeki GitLab bileşeninin diğer bileşenler ile haberleşmesi için kullanılacaktır.

* Örnek yapılandırma:  

| **Arabirim Adı**  | **Ip Adresi** |
| ------------- | ------------- |
| ens192        | 192.168.1.1/24   |
| ens224        | 192.168.1.2/24  |

- İlk olarak continerlar için tahsis edilen interface (örn ens224) aşağıdaki komut ile "**up**" konuma getirilmelidir: 
``` 
sudo ip link set dev ens224 up
```
- Daha sonra boot sırasında bu interface'in up duruma gelmesi için "**/etc/network/interfaces**" dosyasına aşağıdaki konfigürasyon eklenmelidir:  
```  
auto ens224   
iface ens224 inet manual   
up ip link set ens224 up  
```  
* **NOT**
  > Gitlab-container rolü otomatik olarak "**/etc/ansible/hosts**" dosyasında bulunan **[ansible]** tagi altındaki sunucu üzerinde çalıştırılır. 

- Bu işlemlerin ardından aşağıdaki komut ile gitlab-container rolüne ait değişkenleri içeren dosya açılır.
```
vim /etc/ansible/roles/gitlab-container/vars/main.yml
```

- Bu dosya içerisindeki değişkenlerin görevleri şu şekildedir:
  - **gitlab_fqdn** değişkeni gitlab sunucusuna web üzerinden erişilecek fqdn adresinin tanımlandığı değişkendir.
  - **use_self_signed_cert** Eğer;
    - https bağlantı için mevcut bir ssl sertifika kullanılmak istenmiyorsa bu değişken **true** olarak set edilmelidir. Böylelikle kurulum sırasında otomatik olarak self-signed bir sertifika oluşturularak sisteme yüklenir.
    - Eğer mevcut bir ssl sertifikası kullanılmak isteniyorsa bu değişken **false** olarak set edilmelidir. Ardından **/etc/ansible/roles/gitlab-container/templates** dizini altında bulunan **ssl-crt.j2** ve **ssl-key.j2** dosyalarının yerine size ait ssl sertifika ve key dosyasını AYNI İSİMDE olacak şekilde koymanız gerekmektedir.
  - **backup** Eğer gitlab yedekli kurulmayacaksa **enabled: no** olması yeterlidir başka bir düzenlemeye gerek yoktur. Eğer gitlab yedekli kurulacak ise;
    - **enabled** yes olarak düzenlenmelidir.
    - **Server** yedek sunucunun adresi buraya girilmelidir.
    - **Port** yedek sunucunun bağlantı portu buraya girilmelidir.
  - **ansible** MYS yani ansible sunusuna ait bilgilerin bulunduğu kısımdır:
    - **Server** MYS sunucusuna ait IP bilgisinin girilmesi gerekmektedir. FQDN bilgisi kabul *_edilmemektedir_*.
    - **Port** MYS sunucusuna ait SSH port bilgisidir.

- Son adım olarak daha önceden gitlab için oluşturulmuş anahtarların olduğu dizine gidilerek aşağıdaki komutlar yardımı ile gerekli anahtarlar ilgili dizine taşınır:
```
cd /path/to/anahtarlar
cp gdyshook /etc/ansible/roles/gitlab-container/templates/gdyshook
cp gdyshook.pub /etc/ansible/roles/gitlab-container/templates/gdyshook.pub
cp gdyshook-cert.pub /etc/ansible/roles/gitlab-container/templates/gdyshook-cert.pub
cp myshook /etc/ansible/roles/gitlab-container/templates/myshook
cp myshook.pub /etc/ansible/roles/gitlab-container/templates/myshook.pub
cp myshook-cert.pub /etc/ansible/roles/gitlab-container/templates/myshook-cert.pub
```

- Bütün işlemler tamamlandıktan sonra aşağıdaki komut ile playbook çalıştırılır:
```
cd /etc/ansible
ansible-playbook playbooks/gitlab-contianer.yml
```
