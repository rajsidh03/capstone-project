# Project 7: CI Validation for Terraform

[![P7 Terraform CI](https://github.com/rajsidh03/capstone-project/actions/workflows/p7-terraform-ci.yml/badge.svg?branch=main)](https://github.com/rajsidh03/capstone-project/actions/workflows/p7-terraform-ci.yml)

A GitHub Actions workflow runs `terraform fmt -check` and `terraform validate`
on every push and pull request that changes this folder.

## Run the same checks locally
    terraform fmt -check -recursive
    terraform init -backend=false
    terraform validate
