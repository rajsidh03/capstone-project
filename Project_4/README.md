# Project 4: IAM User Automation with Terraform

Creates an IAM user whose only permission is read-only access to one test
S3 bucket. The allowed actions are stored in the variable `s3_read_actions`.

## Usage
    terraform init
    terraform fmt && terraform validate
    terraform plan
    terraform apply
    bash test_policy.sh 2>&1 | tee test-evidence.txt
    terraform destroy

## Evidence
test-evidence.txt shows the attached policy, the policy JSON, and IAM policy
simulator results (S3 read allowed; write, delete and other services denied).

## Note on access keys
`create_access_key` defaults to false because the organisation's service
control policy blocks iam:CreateAccessKey. The policy is therefore tested with
the IAM policy simulator instead of a live login. If your account allows keys,
set `create_access_key = true`; the secret is then stored in the git-ignored
state file, so run `terraform destroy` when finished.
<img width="1918" height="986" alt="Screenshot 2026-11-25 133450" src="https://github.com/user-attachments/assets/f1ff075c-5349-4575-ab5c-03c74e842eac" />
<img width="1919" height="991" alt="Screenshot 2026-11-25 133339" src="https://github.com/user-attachments/assets/5dac417e-c0f1-4837-b53a-8b2995d15573" />


