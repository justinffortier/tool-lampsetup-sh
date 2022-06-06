echo 'Updating Yum'
sleep 2
sudo yum update -y

echo 'Installing extras'
sleep 2
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2

echo 'Installing apache and mysql'
sleep 2
sudo yum install -y httpd mariadb-server

echo 'Starting Apache and enabling start on reboot'
sleep 2
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl is-enabled httpd
echo 'Adding user to apache group'
sleep 2
sudo usermod -a -G apache ec2-user

echo "Setting permissions on www folder"
sleep 2
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;

echo "Creating PHP info file"
sleep 2
echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php

echo "Setting up Mysql"
sleep 2
sudo systemctl start mariadb
sudo mysql_secure_installation
sudo systemctl stop mariadb
sudo systemctl enable mariadb

echo "Installing wordpress"
wget http://wordpress.org/latest.tar.gz
tar xfz latest.tar.gz
mv wordpress/* ./
rm -rf wordpress

echo "Installing wordpress CLI"
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

exit