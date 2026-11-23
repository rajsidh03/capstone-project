#!/bin/bash
# Installs Apache and publishes a simple webpage (Amazon Linux 2023)
set -euxo pipefail

dnf update -y
dnf install -y httpd

TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 300")
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/placement/availability-zone)

cat > /var/www/html/index.html <<HTML
<!DOCTYPE html>
<html>
<head><title>Project 1 - Terraform EC2</title></head>
<body style="font-family:sans-serif;text-align:center;margin-top:80px">
  <h1>Hello from Terraform on AWS!</h1>
  <p>Instance: ${INSTANCE_ID}</p>
  <p>Availability Zone: ${AZ}</p>
</body>
</html>
HTML

systemctl enable --now httpd
