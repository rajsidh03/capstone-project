# Project 5: Linux Permissions

I created the group `devs` and two users: `alice` (in `devs`) and `bob` (not in `devs`).
The folder `/srv/project` is owned by `root:devs` with mode 770, so only the group has access.

Tests: alice can write to and read the folder (allowed). bob gets "Permission denied" for both (denied).
