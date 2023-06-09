echo "rabbitmq service setup started"
source common.sh
component=rabbitmq
rabbitmq_password=$1
if [ -z "$rabbitmq_password" ]; then
  echo "rabbitmq_password is missing"
  exit 1
fi
echo "repo download"
curl -s https://packagecloud.io/install/repositories/$component/erlang/script.rpm.sh | bash &>> ${log_name}
status_check $?
curl -s https://packagecloud.io/install/repositories/$component/$component-server/script.rpm.sh | bash &>> ${log_name}
echo "$component installation"
yum install $component-server -y &>> ${log_name}
status_check $?
systemctl enable $component-server &>> ${log_name}
systemctl start $component-server &>> ${log_name}
status_check $?
rabbitmqctl add_user roboshop $rabbitmq_password &>> ${log_name}
status_check $?
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> ${log_name}
status_check $?
echo "Process completed"