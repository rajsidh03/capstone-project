#!/bin/bash
# Removes everything created by setup_users.sh
for u in alice bob carol eve; do
  id "$u" >/dev/null 2>&1 && sudo userdel -r "$u"
done
for g in developers auditors; do
  getent group "$g" >/dev/null && sudo groupdel "$g"
done
sudo rm -rf /srv/company
echo "Cleanup done."
