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
![Dashboard](<img width="1912" height="877" alt="Screenshot 2026-11-24 195822" src="https://github.com/user-attachments/assets/a8f01860-8cae-4305-b700-25fa7300b590" />
)
![Logs](<img width="1905" height="889" alt="Screenshot 2026-11-24 195953" src="https://github.com/user-attachments/assets/c4aaea3f-0ced-4ad7-865c-7498aa2dfc70" />
)

## Note
The console login cannot run Logs Insights queries, so the dashboard uses
metric filters and the raw logs are shown from the AWS CLI.
