#!/bin/bash

# CHeck for needed config in the env
if ! printenv | grep -q MUNGE_KEY
  then echo "[!] Munge key must be set in env!"
  exit 1
fi

# Configure Munge Key
echo $MUNGE_KEY | base64 -d | base64 -d > /etc/munge/munge.key
chown -vR munge: /etc/munge/ /var/log/munge/
chmod -Rv 0700 /etc/munge/ /var/log/munge/

# Start Munged
sudo -u munge  /usr/sbin/munged || exit 1

# Start prometheus exporter
/app/bin/prometheus-slurm-exporter 
