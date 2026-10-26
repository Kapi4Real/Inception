# Secrets

Place runtime secret files here on your local machine. Do NOT commit real secrets.

Examples:
- `db_root_password.txt` — MariaDB root password
- `db_password.txt` — MariaDB app user password
- `wp_admin_password.txt` — WordPress admin password

You can reference these files from scripts or compose if you implement `_FILE` patterns.
