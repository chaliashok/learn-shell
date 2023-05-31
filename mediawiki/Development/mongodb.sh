echo "Process Started"
source common.sh
component=mongod

echo "Copying repo files"
cp /home/centos/learn-shell/mediawiki/Development/mongo.repo /etc/yum.repos.d/mongo.repo &>> $log_name
status_check $?
echo "Installing mongodb"
yum install mongodb-org -y &>> $log_name
status_check $?
echo "Modifying ip number"
sed -i "s/127.0.0.1/0.0.0.0/" /etc/mongod.conf &>> $log_name
status_check $?
echo "Mongodb service restart"
systemctl enable mongod
systemctl start mongod
status_check $?

echo "Process completed"