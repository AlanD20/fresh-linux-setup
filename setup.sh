#!/bin/bash

#Requires First argument as username

echo "========================================================"
echo "    - Repository path must be /home/fresh-linux-setup/"
echo "    - Pass existing user to the first argument"
echo "    - Make sure you have configured everything in the files directory."
echo "    - You can change the git config in the user's script."
echo "========================================================"

read -p "Continue the installation?"

if [ "${REPLY:0:1}" != "y" ]
then
    exit 0;
fi

if [ -z "$1" ]
then
    echo "Exisitng user is required."
    echo "- First argument is User."
    exit 0;
fi

usr=$1

# Generate locale language
sudo locale-gen

#initial update with curl installation
sudo apt update && sudo apt -y upgrade && sudo apt -y install apt-transport-https ca-certificates curl
#Add repositories
#composer
sudo add-apt-repository -y universe
#php
sudo add-apt-repository -y ppa:ondrej/php
#fonts-powerline
sudo apt-get -y install fonts-powerline

echo "=========================================="
echo "Repositories Added"
echo "=========================================="

#update the repositores
sudo apt update && sudo apt -y upgrade

#update kernal
echo "=========================================="
echo "Updating kernals..."
echo "=========================================="
sudo apt -y install linux-headers-$(uname -r) build-essential dkms
echo "=========================================="
echo "Kernal updated successfully!"
echo "=========================================="

#installation
echo "=========================================="
echo "Installing....."
echo "=========================================="
sudo apt-get -y install build-essential software-properties-common unattended-upgrades php8.1 php8.1-common php8.1-snmp php8.1-xml php8.1-zip php8.1-mbstring php8.1-curl php8.1-cgi php8.1-fpm php8.1-gd php8.1-imagick php8.1-intl php8.1-memcached php8.1-mysql php8.1-opcache php8.1-pgsql php8.1-psr php8.1-redis php-mysql nginx unzip dos2unix zsh

echo "=========================================="
echo "Installation completed!"
echo "=========================================="


echo "=========================================="
echo "Making sure files are in LF mode"
echo "=========================================="

sudo dos2unix /home/fresh-linux-setup/files/*

echo "=========================================="
echo "All files converted to LF"
echo "=========================================="



#install composer
echo "=========================================="
echo "Composer setup..."
echo "=========================================="

cd ~ && curl -sS https://getcomposer.org/installer | php
sudo mv ~/composer.phar /usr/local/bin/composer
sudo chown root:users /usr/local/bin/composer

echo "=========================================="
echo "Composer completed!"
echo "=========================================="


#enable auto updates
sudo dpkg-reconfigure -f noninteractive --priority=low unattended-upgrades


#remove apache2
echo "=========================================="
echo "Uninstalling Apache2..."
echo "=========================================="
sudo systemctl stop apache2
sudo apt remove apache2 --purge
echo "=========================================="
echo "Apache2 uninstalled!"
echo "=========================================="



#Replace php.ini texts
echo "=========================================="
echo 'Fixing php.ini File...'
echo "=========================================="
sed -i 's/;cgi.fix_pathinfo=0/cgi.fix_pathinfo=1/gI' /etc/php/8.1/fpm/php.ini
sed -i 's/;extension=fileinfo/extension=fileinfo/gI' /etc/php/8.1/fpm/php.ini
sed -i 's/;extension=gd/extension=gd/gI' /etc/php/8.1/fpm/php.ini
sed -i 's/;extension=imap/extension=imap/gI' /etc/php/8.1/fpm/php.ini
sed -i 's/;extension=mbstring/extension=mbstring/gI' /etc/php/8.1/fpm/php.ini
sed -i 's/;extension=exif/extension=exif/gI' /etc/php/8.1/fpm/php.ini
sed -i 's/;extension=mysqli/extension=mysqli/gI' /etc/php/8.1/fpm/php.ini
sed -i 's/;extension=openssl/extension=openssl/gI' /etc/php/8.1/fpm/php.ini
sed -i 's/;extension=pdo_mysql/extension=pdo_mysql/gI' /etc/php/8.1/fpm/php.ini
sed -i 's/;extension=sockets/extension=sockets/gI' /etc/php/8.1/fpm/php.ini

#reload php8.1-fpm
sudo systemctl restart php8.1-fpm

echo "=========================================="
echo 'php.ini File fixed!'
echo "=========================================="


echo "=========================================="
echo "Installing oh-my-zsh..."
echo "=========================================="

yes | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

cd ~ && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

echo "=========================================="
echo "oh-my-zsh Customization completed!"
echo "=========================================="


#Copy zsh profile
echo "=========================================="
echo 'Setting up ZSH profile...'
echo "=========================================="


sudo rm /home/$usr/.bash*
sudo rm ~/.bash*

sudo cat /home/fresh-linux-setup/files/zshrc > ~/.zshrc

echo "=========================================="
echo 'ZSH profile finished!'
echo "=========================================="


su $usr -c "zsh /home/fresh-linux-setup/user.sh $usr"

usermod --shell /bin/zsh $usr

#Final steps
sudo systemctl restart php8.1-fpm
sudo systemctl restart nginx
yes | sudo apt autoremove
sudo apt-get -y upgrade


cat<< MANUAL_TASKS
==============================================
            Remaning Manual Tasks....
==============================================

- Change root password, if you want to:
sudo passwd root

- Configure p10k style:
p10k configure

MANUAL_TASKS
