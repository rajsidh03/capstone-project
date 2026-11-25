# Incident Notes: Manual Chaos Test (Project 24)

**Date:** 2026-11-25 (UTC)
**Service:** p24-web (demo web service on 127.0.0.1:8080, managed by systemd)
**Type:** Planned chaos test (service stopped on purpose)

## Summary
The web service was stopped manually to test detection and recovery. It was restarted and verified healthy. Total outage: 2 seconds.

## Timeline (UTC)
| Time | Event |
|---|---|
| 07:49:17 | Baseline: service=active, HTTP 200 |
| 07:49:17 | Service stopped (systemctl --user stop p24-web) |
| 07:49:18 | Outage confirmed: service=inactive, HTTP 000 (no response) |
| 07:49:18 | Recovery started (systemctl --user start p24-web) |
| 07:49:19 | Service verified: service=active, HTTP 200 |

## Impact
The website did not answer requests for about 2 seconds. No data was lost, because the service only serves a static page.

## Detection
A curl check returned HTTP 000 (no answer) and systemctl reported the service as "inactive".

## Root cause
The service was stopped manually as part of a planned chaos test.

## Recovery and verification
The service was restarted with systemctl. A curl check then returned HTTP 200 and systemctl reported "active".

## Lessons and prevention
- Add Restart=on-failure to the systemd unit so a crashed service restarts by itself.
- Add monitoring (for example a CloudWatch alarm or a health check) so an outage is detected without a manual check.
- Keep the restart command and a verification command (curl) in a runbook.
