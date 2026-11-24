# Project 7: CI Validation for Terraform

[![P7 Terraform CI](https://github.com/rajsidh03/capstone-project/actions/workflows/p7-terraform-ci.yml/badge.svg?branch=main)](https://github.com/rajsidh03/capstone-project/actions/workflows/p7-terraform-ci.yml)

A GitHub Actions workflow runs `terraform fmt -check` and `terraform validate`
on every push and pull request that changes this folder.

## Run the same checks locally
    terraform fmt -check -recursive
    terraform init -backend=false
    terraform validate

<img width="1898" height="791" alt="Screenshot 2026-11-24 091527" src="https://github.com/user-attachments/assets/fd4ff0e4-4afc-4036-9a1a-eb337bd90ecc" />

<img width="1904" height="790" alt="Screenshot 2026-11-24 091618" src="https://github.com/user-attachments/assets/b135fd50-300a-4882-892a-c9da59f73fbd" />

