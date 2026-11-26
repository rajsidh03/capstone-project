# Project 5: Linux Permissions

I created the group `devs` and two users: `alice` (in `devs`) and `bob` (not in `devs`).
The folder `/srv/project` is owned by `root:devs` with mode 770, so only the group has access.

Tests: alice can write to and read the folder (allowed). bob gets "Permission denied" for both (denied).

<img width="1909" height="441" alt="Screenshot 2026-11-26 021328" src="https://github.com/user-attachments/assets/b3e6124d-0994-4274-a7b3-e502741c1612" />
