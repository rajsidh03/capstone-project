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
<img width="1911" height="945" alt="Screenshot 2026-11-24 231839" src="https://github.com/user-attachments/assets/48730f32-f0f6-411c-abba-ffe56c5dcbd4" />
<img width="1911" height="935" alt="Screenshot 2026-11-24 231853" src="https://github.com/user-attachments/assets/cb1a9f8c-ff5d-45e9-ba43-d680e16efcc9" />

<img width="1914" height="845" alt="Screenshot 2026-11-24 232141" src="https://github.com/user-attachments/assets/6ea0d628-6019-4840-b98c-39f1f138a1c8" />



<img width="1910" height="839" alt="Screenshot 2026-11-24 232632" src="https://github.com/user-attachments/assets/1629c841-c058-4073-8b3d-6d368de8a3b3" />
