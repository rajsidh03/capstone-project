#!/bin/bash
# Creates a CPU spike for 2 minutes every 5 minutes so the dashboard has data to show
set -euxo pipefail

cat > /etc/systemd/system/p21-load.service <<'UNIT'
[Unit]
Description=P21 CPU load

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'timeout 120 sha1sum /dev/zero || true'
UNIT

cat > /etc/systemd/system/p21-load.timer <<'UNIT'
[Unit]
Description=Run P21 CPU load every 5 minutes

[Timer]
OnBootSec=60
OnUnitActiveSec=300

[Install]
WantedBy=timers.target
UNIT

systemctl daemon-reload
systemctl enable --now p21-load.timer
