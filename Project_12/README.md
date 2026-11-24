# Project 12: Terraform Plan in a Pipeline

A GitHub Actions workflow (`.github/workflows/p12-terraform-plan.yml`) runs
`terraform plan` on every push to this folder and uploads the plan as an artifact.
The pipeline uses `ci_mode=true`, so it needs no AWS credentials.
<img width="1915" height="948" alt="image" src="https://github.com/user-attachments/assets/8062a059-d992-4869-b0db-d787d273e70e" />
