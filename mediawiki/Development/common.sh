log_name="/tmp/robo_shop.log"
app_dir="/app"

status_check()
{
  if [ "$1" -eq 0 ];
   then
    echo success
   else echo Failure
   exit 1
  fi
}

user_check()
{
id roboshop &>> ${log_name}
if [ $? -eq 1 ]; then
  useradd roboshop &>> ${log_name}
  echo "success"
  else
    echo "user already exists"
fi
    }
status_check $?

services_restart()
 {
echo "copying Service file"
cp /home/centos/learn-shell/mediawiki/Development/$component.service /etc/systemd/system/$component.service &>> ${log_name}
#sed -i -e 's/roboshop_password/$roboshop_password/'  /etc/systemd/system/$component.service
status_check $?
echo "Loading the service"
 systemctl daemon-reload &>> ${log_name}
 echo "enabling and starting the service"
 systemctl enable $component &>> ${log_name}
 systemctl start  $component &>> ${log_name}
 status_check $?
 }

Application_setup()
 {
  rm -rf  $app_dir &>> ${log_name}
  mkdir $app_dir &>> ${log_name}
  status_check $?
  echo "Downloading $component files"
  curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>> ${log_name}
 status_check $?
  cd $app_dir
  echo "Extracting $component files"
  unzip -o /tmp/$component.zip &>> ${log_name}
status_check $?
  }

nodejs() {
echo "application setup"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> ${log_name}
status_check $?
echo "Install nodejs"
yum install nodejs -y &>> ${log_name}
status_check $?
user_check
status_check $?
Application_setup
status_check $?
cd /app
echo "Downloading dependencies"
npm install &>> ${log_name}
status_check $?
echo "Copying service files"
services_restart
}

mongodb_setup() {
  echo "Copying repo file"
  cp /home/centos/learn-shell/mediawiki/Development/mongo.repo /etc/yum.repos.d/mongo.repo &>> ${log_name}
  status_check $?
  echo "Installing mongodb client"
  yum install mongodb-org-shell -y &>> ${log_name}
  status_check $?
  echo "Loading Schema data"
  mongo --host mongodb-dev.devopsawschinni.online </$app_dir/schema/$component.js &>> ${log_name}
  status_check $?
}

mysql_setup() {
  echo "Mysql schem setup"
  yum install mysql -y &>> ${log_name}
  status_check $?
  echo "Data loading"
  mysql -h mysql-dev.devopsawschinni.online -uroot -p${mysql_password} < $app_dir/schema/$component.sql &>> ${log_name}
 status_check $?
}
maven() {
  yum install maven -y  &>> ${log_name}
  status_check $?
  user_check
  status_check $?
  Application_setup
  cd $app_dir
  mvn clean package  &>> ${log_name}
  mv target/shipping-1.0.jar shipping.jar  &>> ${log_name}
  services_restart
  mysql_setup
}

python() {
  echo "Python installation started"
  yum install python36 gcc python3-devel -y &>> ${log_name}
  status_check $?
  user_check &>> ${log_name}
  status_check $?
  echo "Application setup"
  Application_setup &>> ${log_name}
  status_check $?
  echo "install python requirements"
  cd $app_dir
  pip3.6 install -r requirements.txt &>> ${log_name}
  status_check $?
services_restart
status_check $?
}

golang() {

  echo "golang installtion started"
  yum install golang -y &>> ${log_name}
  status_check $?
  echo "golang user check"
  user_check &>> ${log_name}
  status_check $?
  echo "App setup"
 Application_setup &>> ${log_name}
  status_check $?
  cd $app_dir
  echo "mod init process"
  go mod init dispatch &>> ${log_name}
  status_check $?
  echo "golang get "
  go get &>> ${log_name}
  status_check $?
  echo "golang build"
  go build &>> ${log_name}
  status_check $?
  services_restart &>> ${log_name}
  status_check $?
  echo "Process completed"
}