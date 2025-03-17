# KeePassXC Conflict Resolver

## Overview

If you use **KeePassXC** with **Nextcloud** and possibly **KeeShare**, you might frequently encounter **conflicted database files**. These conflicts often arise due to minor synchronization issues but usually contain no real changes. Manually resolving these conflicts is tedious and error-prone.

This script automates the resolution process by:
- Identifying the most recent **conflicted copy** of your database.
- Performing a **dry-run merge** to check for differences.
- If no real changes are detected, **automatically deleting the conflicted copy**.
- If changes exist, prompting you to confirm a merge.

## Why Use This Script?

- **Saves time** – No need to manually inspect and merge duplicate databases.
- **Prevents clutter** – Removes unnecessary conflict files automatically.
- **Ensures data integrity** – Uses `keepassxc-cli merge` for safe database merging.
- **Secure** – Requires password input only when needed and does not store it persistently.

## How It Works

1. The script scans the directory for KeePass databases with conflicted copies.
2. It performs a **dry-run merge** to check if the conflict file contains actual changes.
3. If no modifications are detected, it automatically **deletes the conflicted file**.
4. If modifications exist, it prompts the user to confirm merging before deletion.
5. The process repeats until all conflicts are resolved.

## Installation

You can download and install the script using either `curl` or `wget`:

### Using `curl`:
```bash
curl -o resolve_keepass_conflicts.sh https://raw.githubusercontent.com/tomfun/keepassxc-nextcloud-autoresolve/refs/heads/main/resolve.sh
chmod +x resolve_keepass_conflicts.sh
```

### Using `wget`:
```bash
wget -O resolve_keepass_conflicts.sh https://raw.githubusercontent.com/tomfun/keepassxc-nextcloud-autoresolve/refs/heads/main/resolve.sh
chmod +x resolve_keepass_conflicts.sh
```

## Usage

Run the script with the KeePass database file as an argument:
```bash
./resolve_keepass_conflicts.sh my_database.kdbx
```

If a conflict is found, the script will:
- Display the detected conflict files.
- Show potential merge changes.
- Prompt for deletion if the database was modified.

### Example Output
```
No conflicted files found for my_database.kdbx
other conflicts:
 - my_database (conflicted copy 2024-03-09).kdbx
 - my_database (conflicted copy 2024-03-08).kdbx

Dry run. Showing potential merge changes:
Database was not modified by merge operation
Deleting file my_database (conflicted copy 2024-03-09).kdbx without confirmation
```

## Requirements

- **KeePassXC** with CLI support (`keepassxc-cli`)
- **Bash** (for running the script)
- **Nextcloud** (optional, but relevant for conflict issues)

## Security Considerations

- The script requests your **KeePass password** only when necessary.
- Password is **not stored** but reused within the same execution.
- Uses **secure shell scripting** practices to avoid leaking sensitive data.

## Notes

- If the script detects **real changes**, it will not delete the conflict automatically.
- You can manually verify differences by checking `last_resolve.txt`.
- Useful for users synchronizing KeePass databases between multiple devices via **Nextcloud**.

---

### Screenshot Example
![enable sync to relative folder](https://github.com/user-attachments/assets/386b0698-4a62-4f4b-8eed-ff01d7491cb3)

![run the script in the folder](https://github.com/user-attachments/assets/458eda21-b8a7-4237-91da-d985d784c32d)
![run the script in action](https://github.com/user-attachments/assets/7a4feb83-b619-45b2-9ef6-8424c850c393)
![run the script in action after](https://github.com/user-attachments/assets/58205801-3fe6-4ccd-bf82-9e53b17efefc)



## License
This script is actually provided "as-is". Use at your own discretion!
PR and forks are welcome
