# Project 19: Scheduled S3 Backup

Terraform creates a private S3 bucket and an EC2 server with a cron job that
compresses its logs and uploads them to the bucket every minute. The server's
IAM role can only write to that one bucket.

## Usage
    terraform init
    terraform apply
    aws s3 ls s3://<bucket>/backups/ --recursive --human-readable --summarize
    terraform destroy

## Cron job
    * * * * * root /usr/local/bin/p19-backup.sh

Use `0 2 * * *` for a daily 02:00 backup.

## Screenshots
![Backup files in S3](screenshots/backup-listing.png)
![Cron job](screenshots/cron-job.png)

## Note
The console login cannot list the bucket, so the backup files are shown from
the AWS CLI.
