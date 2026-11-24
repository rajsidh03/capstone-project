#!/bin/bash
# Installs Apache and publishes a page that shows which server answered
set -euxo pipefail

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
<head><title>Project 20 - Load Balancer</title></head>
<body style="font-family:sans-serif;text-align:center;margin-top:80px">
  <h1>Hello from the load-balanced app!</h1>
  <p>Served by instance: <b>${INSTANCE_ID}</b></p>
  <p>Availability Zone: <b>${AZ}</b></p>
</body>
</html>
HTML

# Health check target used by the load balancer
echo "OK" > /var/www/html/health

systemctl enable --now httpd
