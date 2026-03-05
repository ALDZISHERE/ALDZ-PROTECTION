#!/bin/bash
# ALDZ Anti Deface Watcher - Real-time file integrity monitor

MONITOR_DIRS="/var/www /etc/nginx /etc/apache2 /home"
LOG_FILE="/var/log/aldz-defender.log"
ALERT_EMAIL="root@localhost"

# Buat database hash awal jika belum ada
if [[ ! -f /var/lib/aldz/hashes.db ]]; then
    mkdir -p /var/lib/aldz
    find $MONITOR_DIRS -type f -exec sha256sum {} \; > /var/lib/aldz/hashes.db 2>/dev/null
fi

# Fungsi verifikasi
verify_files() {
    find $MONITOR_DIRS -type f -exec sha256sum {} \; > /tmp/current.db 2>/dev/null
    diff /var/lib/aldz/hashes.db /tmp/current.db | grep "^<" | while read line; do
        FILE=$(echo $line | awk '{print $2}')
        echo "$(date): PERUBAHAN TERDETEKSI: $FILE" >> $LOG_FILE
        
        # Restore dari backup jika ada
        if [[ -f "/backup$FILE" ]]; then
            cp "/backup$FILE" "$FILE"
            echo "$(date): RESTORE OTOMATIS: $FILE" >> $LOG_FILE
        fi
        
        # Kirim alert
        logger -p auth.alert "ALDZ DEFACE: $FILE dimodifikasi!"
    done
    mv /tmp/current.db /var/lib/aldz/hashes.db
}

# Monitoring loop
while true; do
    verify_files
    inotifywait -r -e modify,create,delete,move $MONITOR_DIRS 2>/dev/null
    sleep 2
done