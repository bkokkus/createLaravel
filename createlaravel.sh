#!/bin/bash


echo -e "\e[5m"
echo -e "\e[31mOKU BUNU"


echo -e "\e[0m"
echo *****Merhaba, 
echo *****Öncelikle bu script proje adı alıyor :
echo ***** apache2 için sites-available dosyasına conf dosyası oluşturuyor.
echo ***** oluşturduğu dosyayı a2ensite ile aktif ediyor. 
echo ***** modrewrite modülünü aktif ediyor.
echo ***** host dosyasına yeni bir host yazıyor.(127.0.0.1 example.tld)
echo ***** apache2 servisini restart ediyor.
echo ***** Daha sonra proje klasöründe laravel komutu ile yeni bir laravel projesi oluşturuyor.
echo ***** Çok basit bir şekilde oluşturulan bu script kullanılabilmesi için :
echo ***** web server olarak apache2 kullanıktadır.
echo ***** composer ve laravel yüklü olmalıdır.
echo ***** Son olarak user yazan yerlere kendi işletim sistemi kullanıcı adınızı yazmalısınız.
echo ***** Kullanıcı anadizininde project adında bir klasör oluşturmuş olmanız gerekir.


echo -e "\e[0m"
echo Conf dosyasının adını belirtin. 
echo Özel karakter ve noktalama işareti kullanmayınız!

echo Proje adınızı belirtin
read -p 'Project name : ' projectName

documentRoot="/home/user/project/$projectName/public"
serverName="$projectName.test"

echo 
conf="<VirtualHost *:80>\n 
			ServerAdmin admin@example.com\n
			DocumentRoot $documentRoot\n
			ServerName $serverName\n
	     						\n
     	<Directory $documentRoot>\n
        	Options +FollowSymlinks\n
	        AllowOverride All\n 
	        Require all granted\n 
     	</Directory>\n 
     				\n	
	     	ErrorLog ${APACHE_LOG_DIR}/error.log\n 
	     	CustomLog ${APACHE_LOG_DIR}/access.log combined\n
		</VirtualHost>"

if [ "$(whoami)" != "root" ]; then
	echo "Root değilsın git yetki al !!!"
	exit 2
fi

echo -e $conf > /etc/apache2/sites-available/$serverName.conf
echo "konfigürasyon dosyası yazıldı"

a2ensite $serverName
echo  
a2enmod rewrite

echo -e "127.0.0.1 $serverName" >> /etc/hosts

/etc/init.d/apache2 restart
echo Başarılı!

cd /home/user/project/
/home/user/.composer/vendor/bin/laravel new $projectName

chmod -R 777 /home/user/project/$projectName
date