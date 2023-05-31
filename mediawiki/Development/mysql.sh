echo "mysql DB setup started"
source=common.sh
component=mysqld
mysql_password=$1
if [ -z "$mysql_password" ]; then
  echo "mysql_password is missing"
  exit 1
fi

yum module disable mysql -y &>> ${log_name}
status_check $?
cp /home/centos/learn-shell/mediawiki/Development/mysql.repo /etc/yum.repos.d/mysql.repo &>> ${log_name}
status_check $?
yum install mysql-community-server -y &>> ${log_name}
status_check $?
systemctl enable mysqld
systemctl start mysqld
status_check $?
mysql_secure_installation --set-root-pass $mysql_password &>> ${log_name}
status_check $?
#mysql -uroot -pRoboShop@1
echo "mysql process completed"