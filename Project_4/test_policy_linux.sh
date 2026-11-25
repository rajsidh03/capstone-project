#!/bin/bash
# Proves what the IAM user can and cannot do, using the IAM policy simulator
# on the user's policy document. Run:  bash test_policy_linux.sh 2>&1 | tee test-evidence.txt
cd "$(dirname "$0")" || exit 1
export AWS_PAGER=""
export AWS_DEFAULT_REGION=ap-south-1

BUCKET=$(terraform output -raw bucket_name)
USER_NAME=$(terraform output -raw user_name)
POLICY_ARN=$(terraform output -raw policy_arn)

echo "IAM user:    $USER_NAME"
echo "Test bucket: $BUCKET"
echo "Date:        $(date -u) UTC"

echo
echo "===== 1. The IAM user ====="
aws iam get-user --user-name "$USER_NAME" --query "User.[UserName,Arn]" --output table

echo
echo "===== 2. Policy attached to the user ====="
aws iam list-attached-user-policies --user-name "$USER_NAME" --output table

echo
echo "===== 3. Policy document (built from the s3_read_actions variable) ====="
VER=$(aws iam get-policy --policy-arn "$POLICY_ARN" --query Policy.DefaultVersionId --output text)
POLICY=$(aws iam get-policy-version --policy-arn "$POLICY_ARN" --version-id "$VER" \
  --query PolicyVersion.Document --output json | python3 -c 'import sys,json; print(json.dumps(json.load(sys.stdin)))')
echo "$POLICY" | python3 -m json.tool

echo
echo "===== 4. Policy simulator: what may this user do? ====="
printf "%-24s %-50s %-12s %s\n" "ACTION" "RESOURCE" "EXPECTED" "RESULT"

sim() {   # $1 = action, $2 = resource, $3 = expected
  r=$(aws iam simulate-custom-policy --policy-input-list "$POLICY" \
        --action-names "$1" --resource-arns "$2" \
        --query "EvaluationResults[0].EvalDecision" --output text 2>&1)
  printf "%-24s %-50s %-12s %s\n" "$1" "$2" "$3" "$r"
}

sim s3:GetObject          "arn:aws:s3:::$BUCKET/hello.txt"        allowed
sim s3:ListBucket         "arn:aws:s3:::$BUCKET"                  allowed
sim s3:PutObject          "arn:aws:s3:::$BUCKET/upload-test.txt"  implicitDeny
sim s3:DeleteObject       "arn:aws:s3:::$BUCKET/hello.txt"        implicitDeny
sim s3:ListAllMyBuckets   "*"                                     implicitDeny
sim ec2:DescribeInstances "*"                                     implicitDeny

echo
echo "Done. 'allowed' = permitted by the policy. 'implicitDeny' = not permitted."
