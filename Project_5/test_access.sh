#!/bin/bash
# Project 5 - tests allowed and denied access for each user.
# Run:  bash test_access.sh 2>&1 | tee test-results.txt
cd / || exit 1

BASE=/srv/company
PASS=0
FAIL=0

check() {   # $1 = user, $2 = description, $3 = expected (ALLOW|DENY), $4 = command
  local user=$1 desc=$2 expected=$3 cmd=$4 out rc actual verdict
  out=$(sudo -n -u "$user" -H bash -c "$cmd" 2>&1)
  rc=$?
  if [ "$rc" -eq 0 ]; then actual=ALLOW; else actual=DENY; fi
  if [ "$actual" = "$expected" ]; then verdict=PASS; PASS=$((PASS + 1)); else verdict=FAIL; FAIL=$((FAIL + 1)); fi
  printf "[%s] %-6s %-30s expected %-5s got %-5s\n" "$verdict" "$user" "$desc" "$expected" "$actual"
  if [ "$actual" = "DENY" ] && [ -n "$out" ]; then echo "         -> $out"; fi
}

echo "Access tests - $(date)"
echo

echo "--- alice (developers) ---"
check alice "read dev notes"        ALLOW "cat $BASE/dev/app-notes.txt"
check alice "write in dev folder"   ALLOW "touch $BASE/dev/alice-test.txt"
check alice "read public file"      ALLOW "cat $BASE/public/welcome.txt"
check alice "read audit log"        DENY  "cat $BASE/audit-logs/audit-2026.log"
check alice "browse bob's home"     DENY  "ls /home/bob"
check alice "run sudo"              DENY  "sudo -n true"

echo
echo "--- bob (developers) ---"
check bob "read dev notes"          ALLOW "cat $BASE/dev/app-notes.txt"
check bob "write in dev folder"     ALLOW "touch $BASE/dev/bob-test.txt"
check bob "read audit log"          DENY  "cat $BASE/audit-logs/audit-2026.log"

echo
echo "--- carol (auditors) ---"
check carol "read audit log"        ALLOW "cat $BASE/audit-logs/audit-2026.log"
check carol "write in audit-logs"   DENY  "touch $BASE/audit-logs/carol-test.txt"
check carol "list dev folder"       DENY  "ls $BASE/dev"
check carol "write in dev folder"   DENY  "touch $BASE/dev/carol-test.txt"

echo
echo "--- eve (no group) ---"
check eve "read public file"        ALLOW "cat $BASE/public/welcome.txt"
check eve "write in public folder"  DENY  "touch $BASE/public/eve-test.txt"
check eve "list dev folder"         DENY  "ls $BASE/dev"
check eve "read audit log"          DENY  "cat $BASE/audit-logs/audit-2026.log"

# remove the files the tests created
sudo rm -f "$BASE/dev/alice-test.txt" "$BASE/dev/bob-test.txt"

echo
echo "Result: $PASS passed, $FAIL failed (total $((PASS + FAIL)))"
[ "$FAIL" -eq 0 ]
