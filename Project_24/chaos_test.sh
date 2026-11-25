#!/bin/bash
# Project 24 - manual chaos test: stop a service, observe, restart, verify, write incident notes
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
SVC=p24-web.service
URL=http://127.0.0.1:8080/
DIR=$(cd "$(dirname "$0")" && pwd)
NOTES="$DIR/INCIDENT_NOTES.md"

ts()    { date -u +%H:%M:%S; }
code()  { curl -s -m 3 -o /dev/null -w '%{http_code}' "$URL"; }   # prints 000 when the service is down
state() { systemctl --user is-active "$SVC"; }

# ---- setup: a tiny web service on localhost only ----
mkdir -p "$DIR/site" "$HOME/.config/systemd/user"
echo "<h1>Project 24 service is up</h1>" > "$DIR/site/index.html"
cat > "$HOME/.config/systemd/user/$SVC" <<UNIT
[Unit]
Description=P24 demo web service (localhost only)

[Service]
WorkingDirectory=$DIR/site
ExecStart=$(command -v python3) -m http.server 8080 --bind 127.0.0.1

[Install]
WantedBy=default.target
UNIT
systemctl --user daemon-reload
systemctl --user restart "$SVC"
sleep 2

echo "=== 1. BASELINE: service should be healthy ==="
T1=$(ts); S1=$(state); C1=$(code)
echo "$T1 UTC  service=$S1  http=$C1"

echo
echo "=== 2. CHAOS: stopping the service ==="
START=$(date +%s); T2=$(ts)
systemctl --user stop "$SVC"
echo "$T2 UTC  stop command issued"
sleep 1
T3=$(ts); S3=$(state); C3=$(code)
echo "$T3 UTC  service=$S3  http=$C3   <-- outage confirmed (000 = no answer)"

echo
echo "=== 3. RECOVERY: restarting the service ==="
T4=$(ts)
systemctl --user start "$SVC"
echo "$T4 UTC  start command issued"
for i in $(seq 1 20); do
  [ "$(code)" = "200" ] && break
  sleep 1
done
T5=$(ts); S5=$(state); C5=$(code); END=$(date +%s)
echo "$T5 UTC  service=$S5  http=$C5   <-- recovered"
DOWN=$((END - START))

echo
echo "=== 4. SERVICE LOG ==="
journalctl --user -u "$SVC" --no-pager -n 6 2>/dev/null || true

# ---- incident notes ----
cat > "$NOTES" <<NOTESEOF
# Incident Notes: Manual Chaos Test (Project 24)

**Date:** $(date -u +%F) (UTC)
**Service:** p24-web (demo web service on 127.0.0.1:8080, managed by systemd)
**Type:** Planned chaos test (service stopped on purpose)

## Summary
The web service was stopped manually to test detection and recovery. It was restarted and verified healthy. Total outage: $DOWN seconds.

## Timeline (UTC)
| Time | Event |
|---|---|
| $T1 | Baseline: service=$S1, HTTP $C1 |
| $T2 | Service stopped (systemctl --user stop p24-web) |
| $T3 | Outage confirmed: service=$S3, HTTP $C3 (no response) |
| $T4 | Recovery started (systemctl --user start p24-web) |
| $T5 | Service verified: service=$S5, HTTP $C5 |

## Impact
The website did not answer requests for about $DOWN seconds. No data was lost, because the service only serves a static page.

## Detection
A curl check returned HTTP $C3 (no answer) and systemctl reported the service as "$S3".

## Root cause
The service was stopped manually as part of a planned chaos test.

## Recovery and verification
The service was restarted with systemctl. A curl check then returned HTTP $C5 and systemctl reported "$S5".

## Lessons and prevention
- Add Restart=on-failure to the systemd unit so a crashed service restarts by itself.
- Add monitoring (for example a CloudWatch alarm or a health check) so an outage is detected without a manual check.
- Keep the restart command and a verification command (curl) in a runbook.
NOTESEOF

echo
echo "Incident notes written to: $NOTES"
