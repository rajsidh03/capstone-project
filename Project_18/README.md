
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
<img width="1911" height="945" alt="Screenshot 2026-11-24 210416" src="https://github.com/user-attachments/assets/288f88ab-31a6-4247-b241-e9b1fb3fd9d1" />
<img width="1912" height="841" alt="Screenshot 2026-11-24 210649" src="https://github.com/user-attachments/assets/db29fc00-cb34-4292-9854-e2b21aabd85a" />
<img width="1910" height="837" alt="Screenshot 2026-11-24 211934" src="https://github.com/user-attachments/assets/db022f32-c346-4085-856c-1f380cdde461" />
<img width="1911" height="833" alt="Screenshot 2026-11-24 212843" src="https://github.com/user-attachments/assets/f1317923-861c-4fa3-91da-d56dc833dc72" />
