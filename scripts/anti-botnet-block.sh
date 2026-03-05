#!/bin/bash
# ALDZ Anti Botnet Blocker - Update dan blokir IP botnet

LOG_FILE="/var/log/aldz-botblock.log"
BLOCKLIST_URLS=(
    "https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_level1.netset"
    "https://rules.emergingthreats.net/blockrules/compromised-ips.txt"
    "https://lists.blocklist.de/lists/all.txt"
)

IPTABLES_CHAIN="BOTNET_BLOCK"

# Buat chain jika belum ada
iptables -N $IPTABLES_CHAIN 2>/dev/null
iptables -C INPUT -j $IPTABLES_CHAIN 2>/dev/null || iptables -I INPUT -j $IPTABLES_CHAIN

# Flush chain
iptables -F $IPTABLES_CHAIN

# Download dan blokir
for url in "${BLOCKLIST_URLS[@]}"; do
    echo "$(date): Mengambil $url" >> $LOG_FILE
    curl -s $url | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | while read ip; do
        iptables -A $IPTABLES_CHAIN -s $ip -j DROP
    done
done

# Simpan rules
iptables-save > /etc/iptables/rules.v4
echo "$(date): Total $(iptables -L $IPTABLES_CHAIN -n | grep -c DROP) IP diblokir" >> $LOG_FILE