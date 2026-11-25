# Incident Notes: Manual Chaos Test

**Service:** cron (Ubuntu 24.04)
**Date:** 2026-11-25

## What happened
I stopped the cron service on purpose to test failure and recovery.

## Timeline (UTC)
- 20:49:12  cron running (active)
- 20:49:12  cron stopped (inactive), outage confirmed with systemctl is-active
- 20:49:12  cron started again (active), recovery verified

## Impact
Scheduled jobs would not have run while cron was stopped (a few seconds here).

## Recovery
Ran "sudo systemctl start cron". systemctl is-active then returned "active".

## Prevention
Monitor the service and enable automatic restart (Restart=on-failure) so a crash recovers by itself.
