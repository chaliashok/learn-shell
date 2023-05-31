source common.sh
component=frontend
echo "Frontend Server setup started"
echo "Installing nginx server"
yum install nginx -y &>> ${log_name}
status_check $?
echo "Enabling services"
systemctl enable nginx
systemctl start nginx
status_check $?
echo "Downloading Application files"
rm -rf /usr/share/nginx/html/* &>> ${log_name}
status_check $?
curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>${log_name}
status_check $?
echo "Extracting Files"
cd /usr/share/nginx/html
unzip /tmp/$component.zip &>>${log_name}
status_check $?
cp /home/centos/learn-shell/mediawiki/Development/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_name}
status_check $?
systemctl restart nginx
echo "Process completed"