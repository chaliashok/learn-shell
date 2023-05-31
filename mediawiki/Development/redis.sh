source common.sh
component=redis
echo "Redis service setup started"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> ${log_name}
status_check $?
yum module enable $component:remi-6.2 -y &>> ${log_name}
status_check $?
yum install $component -y &>> ${log_name}
status_check $?
sed -i "s/127.0.0.1/0.0.0.0/" /etc/$component.conf /etc/$component/$component.conf &>> ${log_name}
status_check $?
systemctl enable $component &>> ${log_name}
systemctl start $component &>> ${log_name}
status_check $?
echo "Process completed"