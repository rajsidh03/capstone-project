# Project 20: Load-Balanced App (2 EC2 + ALB + Health Checks)

Terraform deploys two Apache web servers in different Availability Zones behind an Application Load Balancer, using the default VPC (region `ap-south-1`).

## What it builds
- 2 EC2 instances (Amazon Linux 2023). Each page shows its own instance ID and AZ.
- Application Load Balancer with an HTTP:80 listener that forwards to a target group.
- Health check: `GET /health`, every 10s, healthy/unhealthy threshold 2, expects HTTP 200.
- Security groups: the ALB accepts port 80 from anywhere. The servers accept port 80 only from the ALB. No SSH.

## Run
```bash
terraform init
terraform apply
terraform output alb_url
```
Refresh the URL: the instance ID alternates between the two servers.




