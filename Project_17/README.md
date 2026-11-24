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
![Dashboard](screenshots/dashboard.png)
![Logs](screenshots/logs-cli.png)

## Note
The console login cannot run Logs Insights queries, so the dashboard uses
metric filters and the raw logs are shown from the AWS CLI.
