echo "Shipping service setup started"
source common.sh
component=shipping
mysql_password=$1

if [ -z "$mysql_password" ]; then
  echo "mysql_password is missing"
  exit 1
fi

maven

systemctl restart shipping