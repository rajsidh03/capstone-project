#!/bin/bash
# Proves what the IAM user can and cannot do, using the IAM policy simulator.
# Run from the project folder:  bash test_policy.sh 2>&1 | tee test-evidence.txt
cd "$(dirname "$0")" || exit 1

export MSYS_NO_PATHCONV=1
export AWS_PAGER=""

BUCKET=$(terraform output -raw bucket_name)
USER_NAME=$(terraform output -raw user_name)
USER_ARN=$(terraform output -raw user_arn)
POLICY_ARN=$(terraform output -raw policy_arn)

echo "IAM user:    $USER_NAME"
echo "User ARN:    $USER_ARN"
echo "Test bucket: $BUCKET"
echo "Date:        $(date)"

echo
echo "===== 1. Policies attached to the user ====="
aws iam list-attached-user-policies --user-name "$USER_NAME" --output table

echo
echo "===== 2. The policy document ====="
aws iam get-policy-version --policy-arn "$POLICY_ARN" --version-id v1 \
  --query "PolicyVersion.Document" --output json

echo
echo "===== 3. IAM policy simulator: what may this user do? ====="
printf "%-24s %-52s %-13s %s\n" "ACTION" "RESOURCE" "EXPECTED" "RESULT"

sim() {
  # $1 = action, $2 = resource, $3 = expected result
  result=$(aws iam simulate-principal-policy \
    --policy-source-arn "$USER_ARN" \
    --action-names "$1" \
    --resource-arns "$2" \
    --query "EvaluationResults[0].EvalDecision" --output text 2>&1)
  printf "%-24s %-52s %-13s %s\n" "$1" "$2" "$3" "$result"
}

sim s3:GetObject           "arn:aws:s3:::$BUCKET/hello.txt"        allowed
sim s3:ListBucket          "arn:aws:s3:::$BUCKET"                  allowed
sim s3:PutObject           "arn:aws:s3:::$BUCKET/upload-test.txt"  implicitDeny
sim s3:DeleteObject        "arn:aws:s3:::$BUCKET/hello.txt"        implicitDeny
sim s3:ListAllMyBuckets    "*"                                     implicitDeny
sim ec2:DescribeInstances  "*"                                     implicitDeny

echo
echo "Done. 'allowed' = permitted by the policy. 'implicitDeny' = not permitted."
