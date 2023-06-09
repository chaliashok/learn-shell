curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
useradd roboshop
mkdir /app
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip

cd /app
npm install

cp /home/centos/learn-shell/mediawiki/Development/catalogue.service /etc/systemd/system/catalogue.service
systemctl daemon-reload

systemctl enable catalogue
systemctl start catalogue

cp /home/centos/learn-shell/mediawiki/Development/mongo.repo /etc/yum.repos.d/mongo.repo

yum install mongodb-org-shell -y

mongo --host mongodb-dev.devopsawschinni.online </app/schema/catalogue.js