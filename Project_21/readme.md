# Project 21: CloudWatch Monitoring Dashboard

Terraform deploys one EC2 server and a CloudWatch dashboard that graphs its health (region `ap-south-1`, default VPC).

## What it builds
- 1 EC2 instance (Amazon Linux 2023) with 1-minute detailed monitoring. No inbound ports, no SSH.
- A systemd timer that runs a 2-minute CPU load every 5 minutes, so the graphs show activity.
- Dashboard `p21-rajsidh03-monitoring` with 4 widgets:
  - CPU utilization
  - Network in/out
  - Status checks
  - Disk read/write

## Run
```bash
terraform init
terraform apply
terraform output dashboard_url
```
