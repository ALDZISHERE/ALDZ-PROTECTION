#!/bin/bash
# ALDZ Anti Hijack Monitor - Process injection detection

LOG_FILE="/var/log/aldz-hijack.log"
KNOWN_GOOD_PROCESSES="init systemd bash sshd nginx apache2 mysql php-fpm"

# Daftar proses yang mencurigakan
check_hijack() {
    # Cek proses dengan library aneh
    for pid in $(ls /proc | grep -E '^[0-9]+$'); do
        if [[ -f /proc/$pid/maps ]]; then
            # Cek shared library yang tidak biasa
            if grep -q "memfd:" /proc/$pid/maps 2>/dev/null; then
                echo "$(date): HIJACK DETECTED - PID $pid menggunakan memfd" >> $LOG_FILE
                kill -9 $pid 2>/dev/null
            fi
            
            # Cek proses yang menyamar
            PROC_NAME=$(cat /proc/$pid/comm 2>/dev/null)
            if [[ -n "$PROC_NAME" ]]; then
                # Cek apakah proses penting tapi path-nya aneh
                if [[ "$PROC_NAME" == "sshd" ]] && [[ ! "$(readlink /proc/$pid/exe 2>/dev/null)" == "/usr/sbin/sshd" ]]; then
                    echo "$(date): FAKE SSHD DETECTED - PID $pid" >> $LOG_FILE
                    kill -9 $pid
                fi
            fi
        fi
    done
    
    # Cek proses yang menggunakan banyak CPU secara mencurigakan
    ps aux --sort=-%cpu | head -20 | tail -15 | while read line; do
        CPU=$(echo $line | awk '{print $3}')
        CMD=$(echo $line | awk '{for(i=11;i<=NF;i++) printf "%s ", $i; print ""}')
        if (( $(echo "$CPU > 70.0" | bc -l) )); then
            if [[ ! "$KNOWN_GOOD_PROCESSES" =~ $(echo $CMD | awk '{print $1}') ]]; then
                echo "$(date): HIGH CPU ALERT - $CMD ($CPU%)" >> $LOG_FILE
            fi
        fi
    done
}

check_hijack