![ULAKBIM](../img/ulakbim.jpg)
# Yedekleme Betiğinin Kurulumu
------

[TOC]

------

Bu dökümanda Merkezi Yönetim Sistemlerinde yedeklenmesi gereken dosyalar ve yedekleme için kullanılacak betiğin yapılandırılması anlatılmaktadır.

####Yedekleme Betiğinin Kurulumu

* Ahtapot projesi kapsamında oluşturulmuş betik ile, yedeklenmesi gereken dosyalar "**Ansible**" makinası üzerinde toplanarak, "**Rsyslog**" makinasına aktarılırak 3 gün bu sunucu üzerinde saklanmaktadır. İhtiyaç doğrultusunda, bu yedekler hali hazırda kullanılan yedekleme programı ile sistem dışına bir kopyası taşınabilir.

* Tüm bileşenler için yedeği alınması gereken dosyalar aşağıdaki gidibidir;
	
	* Network yapılandırmasını yedeklemek üzere tüm MYS bileşenlerinde bulunan, /etc/network/interfaces dosyası

	* Ansible playbookları yedeklemek üzere Ansible makinasında bulunan, /etc/ansible klasörü

	* Firewalllar için kullanılan GDYS reposunu yedeklemek üzere Ansible makinasında bulunan, /etc/fw klasörü

	* OSSIM yapılandırmasını yedeklemek üzere OSSIM makinalarında bulunan, /var/lib/ossim/backup ve /var/alienvault/backup klasörleri

	* Proxy sunucusu üzerinde yapılmış local listeleri yedeklemek üzere Proxy makinalarında bulunan, /etc/dansguardian/lists/*_local dosyaları 

*  Ansible sunucusu üzerinde istenilen bir dizinde "**backup.sh**" isimli bir dosya düzenlenebilecek bir şekilde açılır.
```	
ahtapotops@:~$ vi /script/backup.sh
```

* Oluşturulan "**backup.sh**" dosyasının içerisine aşağıda bulunan betik kopyalanarak; "**SSH_PORT**" ibaresi bulunan yerlere MYS yapısında kullanılan ssh port bilgisi, "**OSSIM01_SUNUCUSU_FQDN**", "**OSSIM02_SUNUCUSU_FQDN**" ve "**OSSIMCORE_SUNUCUSU_FQDN**" ibareleri bulunan yerlere OSSIM suncularının FQDN bilgileri, "**RSYSLOG_SUNUCUSU_FQDN:**" ibaresi bulunan yerlere ise Rsyslog sunucusunun FQDN bilgileri girilmelidir.

**NOT:** Sistemde herhangi bir bileşen bulunmaması ya da daha az sayıda bulunması durumunda ilgili satır betik içinde "**#**" kullanılarak yorum satırı haline getirilebilir.
```	
ahtapotops@:~$ cat /script/backup.sh
#!/bin/bash

tarih=$(date +"%Y%m%d")
interfaces="/etc/network/interfaces"
ansibledir="/etc/ansible"
backupdir=/backup
gdysdir=/etc/fw

#for j in `grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' /etc/hosts`;\
#for j in `tail -n+8 /etc/hosts |awk '{print $2}'`
#do
#    if
#      ping -c 1  `echo $j` &> /dev/null
#    then
#      echo `echo $j`| tee -a /backup/host.txt
#    else
#      echo `echo $tarih $j` >> /backup/ulasilamayan_sunucular.txt
#    fi;
#done


####network config dosyasini al

for c in `tail -n+8 /etc/hosts |awk '{print $2}'`
do
    sudo /usr/bin/rsync -a -e "ssh -p SSH_PORT -i /home/ahtapotops/.ssh/id_rsa" --rsync-path="/usr/bin/sudo /usr/bin/rsync" ahtapotops@`echo $c`:/etc/network/interfaces /backup/interfaces/`echo $c`-interfaces-$tarih
done

#####ansible playbooklari arsivle

sudo tar cvzf $backupdir/ansible/$tarih-ansible-playbooks.tgz --exclude='*.tgz' -C $ansibledir .

###gdys fw ve fwb dosyalarini arsivle

sudo tar cvzf $backupdir/gdys/$tarih-gdys.tgz --exclude='*.tgz' -C $gdysdir .

###ossim  sql yedeklerini al


sudo /usr/bin/rsync -a -e "ssh -i /home/ahtapotops/.ssh/id_rsa" --rsync-path="/usr/bin/sudo /usr/bin/rsync" ahtapotops@OSSIM01_SUNUCUSU_FQDN:/var/lib/ossim/backup/ /backup/d/sql/
sudo /usr/bin/rsync -a -e "ssh -i /home/ahtapotops/.ssh/id_rsa" --rsync-path="/usr/bin/sudo /usr/bin/rsync" ahtapotops@OSSIM02_SUNUCUSU_FQDN:/var/lib/ossim/backup/ /backup/d/sql/
sudo /usr/bin/rsync -a -e "ssh -i /home/ahtapotops/.ssh/id_rsa" --rsync-path="/usr/bin/sudo /usr/bin/rsync" ahtapotops@OSSIMCORE_SUNUCUSU_FQDN:/var/lib/ossim/backup/ /backup/d/sql/


###ossim  configuration  yedeklerini al


sudo /usr/bin/rsync -a -e "ssh -i /home/ahtapotops/.ssh/id_rsa" --rsync-path="/usr/bin/sudo /usr/bin/rsync" ahtapotops@OSSIM01_SUNUCUSU_FQDN:/var/alienvault/backup/ /backup/d/configuration/
sudo /usr/bin/rsync -a -e "ssh -i /home/ahtapotops/.ssh/id_rsa" --rsync-path="/usr/bin/sudo /usr/bin/rsync" ahtapotops@OSSIM02_SUNUCUSU_FQDN:/var/alienvault/backup/ /backup/d/configuration/
sudo /usr/bin/rsync -a -e "ssh -i /home/ahtapotops/.ssh/id_rsa" --rsync-path="/usr/bin/sudo /usr/bin/rsync" ahtapotops@OSSIMCORE_SUNUCUSU_FQDN:/var/alienvault/backup/ /backup/d/configuration/


###proxy liste yedekleri

for t in `awk '/\[proxy\]/,/\[pwlm\]/' /etc/ansible/hosts |egrep -v "proxy|pwlm"`; do

sudo /usr/bin/rsync -a -e "ssh -p SSH_PORT -i /home/ahtapotops/.ssh/id_rsa" --rsync-path="/usr/bin/sudo /usr/bin/rsync" ahtapotops@`echo $t`:/etc/dansguardian/lists/*_local /backup/proxy/`echo $t`-lists-$tarih
done

###backup dosyasini rsyslog sunucusuna gönder

sudo /usr/bin/rsync -a -e "ssh -p SSH_PORT -i /home/ahtapotops/.ssh/id_rsa" --rsync-path="/usr/bin/sudo /usr/bin/rsync" /backup ahtapotops@RSYSLOG_SUNUCUSU_FQDN:/backup/backup-$tarih

###hosts.txt yi sil
#sudo /bin/rm /scripts/host.txt


#rsysloga gonderilen backuplari ansible sunucudan sil
sudo find /backup/* -type f -exec rm  {} \;

###rsyslog sunucuda 3 gunden eski backuplari sil

ssh ahtapotops@RSYSLOG_SUNUCUSU_FQDN -pSSH_PORT 'sudo find /backup/backup-* -mtime +5 -exec rm -r {} \;'
```

* Betik oluşturulduktan sonra ansible sunucusu üzerinde Crontab'a ihtiyaç doğrultusunda çalışacak aralık belirlenerek eklenir.
```	
ahtapotops@:~$ crontab -e

00 03 * * * sudo /bin/bash -X /scripts/backup.sh
```

**Sayfanın PDF versiyonuna erişmek için [buraya](yedekleme.pdf) tıklayınız.**
