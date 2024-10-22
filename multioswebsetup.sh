#!/bin/bash
# Installing Dependencies


#PACKAGE="httpd wget unzip epel-release"
URL="$1"
#SVC="httpd"
TMPDIR="/tmp/webfiles"
ARTNAME="$2"

echo "########################################"
echo "Installing Packages"
echo "#######################################"
echo
yum --help &> /dev/null

if [[ $? -eq 0 ]]
then
        SVC="httpd"
        PACKAGE="httpd wget unzip epel-release"
        echo "Running setup on CentOS"
        sudo yum install $PACKAGE -y > /dev/null
        # Start and Enabling HTTPD
        echo "#######################################"
        echo "Starting and Enabling HTTPD Service"
        echo

        sudo systemctl start $SVC
        sudo systemctl enable $SVC
        echo
        # Creating TMP Directory
        echo "#########################################"
        mkdir -p $TMPDIR
        cd $TMPDIR
        echo
        # Downloading the HTML Webpages
        echo "##########################################"
        wget $URL
        unzip $ARTNAME.zip
        sudo cp -r $ARTNAME/* /var/www/html
        echo
        # Restarting HTTPD Service
        echo "###########################################"
        echo "Restart HTTPD Service"
        systemctl restart $SVC
        rm -rf $TMPDIR
        echo
        #IP address of server
        echo "###########################################"
        echo "IP address of web server"
        ip addr show | grep 192*
else
        SVC="apache2"
        PACKAGE="apache2 wget unzip epel-release"
        echo "Running setup on CentOS"
        sudo apt update
        sudo yum install $PACKAGE -y > /dev/null
        # Start and Enabling HTTPD
        echo "#######################################"
        echo "Starting and Enabling HTTPD Service"
        echo

        sudo systemctl start $SVC
        sudo systemctl enable $SVC
        echo
        # Creating TMP Directory
        echo "#########################################"
        mkdir -p $TMPDIR
        cd $TMPDIR
        echo
        # Downloading the HTML Webpages
        echo "##########################################"
        wget $URL
        unzip $ARTNAME.zip
        sudo cp -r $ARTNAME/* /var/www/html
        echo
        # Restarting HTTPD Service
        echo "###########################################"
        echo "Restart HTTPD Service"
        systemctl restart $SVC
        rm -rf $TMPDIR
        echo
        #IP address of server
        echo "###########################################"
        echo "IP address of web server"
        ip addr show | grep 192*
fi
