sudo apt-get -y update
sudo apt-get -y install git
sudo git clone https://github.com/abe8591/postgres.git
sudo apt-get -y install nodejs
sudo apt-get -y install npm
cd postgres
npm -y install

sudo touch /usr/bin/startDb.sh
echo "exec /usr/bin/nodejs /home/ubuntu/postgres/src/app.js &> /tmp/postgres.log &" >> /usr/bin/startDb.sh
echo "IPVAR=`curl icanhazip.com`"
echo "export IPVAR"
chmod +x /usr/bin/startDb.sh
echo "/usr/bin/startDb.sh &" > /etc/rc.local
echo "exit 0" >> /etc/rc.local

sudo apt-get -y update
