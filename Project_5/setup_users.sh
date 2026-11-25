#!/bin/bash
# Project 5 - creates users, groups, directories and permissions.
# Run on a Linux server as a user that has sudo rights.
set -euo pipefail

BASE=/srv/company

echo "== Creating groups =="
for g in developers auditors; do
  getent group "$g" >/dev/null || sudo groupadd "$g"
done

echo "== Creating users =="
make_user() {   # $1 = user name, $2 = group ("" = no extra group)
  if ! id "$1" >/dev/null 2>&1; then
    if [ -n "${2:-}" ]; then
      sudo useradd -m -s /bin/bash -G "$2" "$1"
    else
      sudo useradd -m -s /bin/bash "$1"
    fi
  fi
  sudo chmod 700 "/home/$1"      # nobody else can browse this home folder
}
make_user alice developers
make_user bob   developers
make_user carol auditors
make_user eve   ""

echo "== Creating directories =="
sudo mkdir -p "$BASE/dev" "$BASE/audit-logs" "$BASE/public"
sudo chown root:root "$BASE"
sudo chmod 755 "$BASE"

sudo chown root:developers "$BASE/dev"
sudo chmod 2770 "$BASE/dev"            # developers: read/write. Everyone else: nothing
sudo chown root:auditors "$BASE/audit-logs"
sudo chmod 2750 "$BASE/audit-logs"     # auditors: read only. Everyone else: nothing
sudo chown root:root "$BASE/public"
sudo chmod 755 "$BASE/public"          # everyone: read only

echo "== Creating sample files =="
echo "Developer notes: build pipeline runs at 02:00." | sudo tee "$BASE/dev/app-notes.txt" >/dev/null
sudo chown root:developers "$BASE/dev/app-notes.txt"
sudo chmod 660 "$BASE/dev/app-notes.txt"

echo "2026-11-23 audit entry: all systems normal." | sudo tee "$BASE/audit-logs/audit-2026.log" >/dev/null
sudo chown root:auditors "$BASE/audit-logs/audit-2026.log"
sudo chmod 640 "$BASE/audit-logs/audit-2026.log"

echo "Welcome. This folder is readable by everyone." | sudo tee "$BASE/public/welcome.txt" >/dev/null
sudo chown root:root "$BASE/public/welcome.txt"
sudo chmod 644 "$BASE/public/welcome.txt"

echo
echo "== Result: users and their groups =="
for u in alice bob carol eve; do id "$u"; done

echo
echo "== Result: folder and file permissions =="
sudo ls -lR "$BASE"

echo
echo "== Result: home folder permissions =="
ls -ld /home/alice /home/bob /home/carol /home/eve
