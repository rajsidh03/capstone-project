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
<img width="1885" height="808" alt="Screenshot 2026-11-23 181356" src="https://github.com/user-attachments/assets/55ba88cd-fffc-407f-8c55-47631fc7c6e2" />
<img width="1889" height="752" alt="Screenshot 2026-11-23 181505" src="https://github.com/user-attachments/assets/64eee90e-7e53-428b-9385-6059fe309ff7" />

