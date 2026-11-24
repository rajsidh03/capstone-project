# Project 12: Terraform Plan in a Pipeline

A GitHub Actions workflow (`.github/workflows/p12-terraform-plan.yml`) runs
`terraform plan` on every push to this folder and uploads the plan as an artifact.
The pipeline uses `ci_mode=true`, so it needs no AWS credentials.
