# Project 5: Secure Linux Server Permissions

Creates users and groups, restricts folder access with Linux permissions,
and tests allowed and denied access for each user.

## Usage
    bash setup_users.sh
    bash test_access.sh 2>&1 | tee test-results.txt
    bash cleanup.sh        # when finished

## Design
| User  | Groups     | dev (rw) | audit-logs (r) | public (r) |
|-------|------------|----------|----------------|------------|
| alice | developers | yes      | no             | yes        |
| bob   | developers | yes      | no             | yes        |
| carol | auditors   | no       | yes            | yes        |
| eve   | none       | no       | no             | yes        |
