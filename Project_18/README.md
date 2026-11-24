# Project 18: GitOps Infra Deployment

A GitHub Actions pipeline that deploys infrastructure when a Pull Request is
merged to `main`.

## Flow
1. **Pull request:** runs `terraform fmt`, `validate` and `plan`.
2. **Merge to main:** runs `plan` again and saves the plan as an artifact.
3. **Approval:** the `apply` job waits for a reviewer on the protected
   `production` environment.
4. **Apply:** after approval, it runs `terraform apply` with the saved plan.

Workflow file: `.github/workflows/p18-gitops-apply.yml`

## Notes
The demo resource (`terraform_data`) needs no cloud credentials, so no secrets
are stored in GitHub. A production setup would use remote state (for example an
S3 backend) and an OIDC role for AWS access.

## Screenshots
