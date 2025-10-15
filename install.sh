#!/bin/bash

set -e

echo "=== Installing Process Monitoring ==="

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

echo "Copying monitoring script..."
cp monitoring.sh /usr/local/bin/monitoring.sh
chmod +x /usr/local/bin/monitoring.sh

echo "Copying systemd unit files..."
cp monitoring.service /etc/systemd/system/
cp monitoring.timer /etc/systemd/system/

echo "Creating log file..."
touch /var/log/monitoring.log
chmod 644 /var/log/monitoring.log

echo "Reloading systemd..."
systemctl daemon-reload

echo "Enabling and starting monitoring timer..."
systemctl enable monitoring.timer
systemctl start monitoring.timer

echo "=== Installation completed successfully! ==="
echo ""
echo "To check status: systemctl status monitoring.timer"
echo "To view logs: tail -f /var/log/monitoring.log"
echo "To check timer: systemctl list-timers monitoring.timer"