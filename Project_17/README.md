# Project 17: Log Forwarding to CloudWatch

Terraform creates an EC2 server that runs the CloudWatch agent and forwards
its application log and system log to CloudWatch Logs. A dashboard charts the
log events by level (INFO, WARN, ERROR) using metric filters.

## Usage
    terraform init
    terraform apply
    aws logs tail p17-rajsidh03-app --since 10m --region ap-south-1
    terraform destroy

## Screenshots
<img width="1905" height="889" alt="Screenshot 2026-11-24 195953" src="https://github.com/user-attachments/assets/330c12e1-5d8a-4143-a4f8-38a560c0c70b" />
<img width="1912" height="877" alt="Screenshot 2026-11-24 195822" src="https://github.com/user-attachments/assets/f7a48ebd-2b5e-490d-8a34-ac0df13ccb44" />


## Note
The console login cannot run Logs Insights queries, so the dashboard uses
metric filters and the raw logs are shown from the AWS CLI.
