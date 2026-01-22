# 🛠️ Eternal Scripts

## 1. Setup Rclone
Before running backups, you must configure `rclone` to talk to Cloudflare R2.

1.  **Install Rclone**:
    ```bash
    curl https://rclone.org/install.sh | sudo bash
    ```

2.  **Configure**:
    ```bash
    rclone config
    ```
    *   **New remote**: `n`
    *   **Name**: `eternal-r2`
    *   **Storage**: `s3` (Amazon S3 Compliant Storage)
    *   **Provider**: `Cloudflare`
    *   **Access Key ID**: (Get this from R2 Dashboard)
    *   **Secret Access Key**: (Get this from R2 Dashboard)
    *   **Endpoint**: `https://<ACCOUNT_ID>.r2.cloudflarestorage.com`
    *   **ACL**: `private` (default)

## 2. Run Backup
```bash
chmod +x scripts/backup.sh
./scripts/backup.sh
```

## 3. Automation (Cron)
Add this to your crontab (`crontab -e`) to run daily at 3 AM:
```bash
0 3 * * * /path/to/eternalvps/scripts/backup.sh >> /var/log/eternal_backup.log 2>&1
```
