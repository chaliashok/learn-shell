echo "Payment service setup started"

source common.sh
component=payment
roboshop_password=$1
if [ -z "$roboshop_password" ]; then
  echo roboshop_password is missing
  exit 1
fi
python
echo "Process completed"