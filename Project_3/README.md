# Project 3: EC2 Monitoring with a CloudWatch CPU Alarm

Deploys an EC2 instance (default VPC) with detailed monitoring, a CloudWatch
alarm that fires when average CPU is above 70% for 2 minutes, and an optional
SNS email notification. A startup script generates CPU load automatically.

## Usage
    terraform init
    terraform fmt && terraform validate
    terraform plan
    terraform apply
    terraform destroy

## Screenshot
See alarm-screenshot.png
