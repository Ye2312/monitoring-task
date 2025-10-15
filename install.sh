#!/bin/bash

set -e

echo "Installing monitoring system..."

# Copy script to /usr/local/bin
echo "Copying monitoring script..."
cp monitoring.sh /usr/local/bin/monitoring.sh
chmod +x /usr/local/bin/monitoring.sh

# Copy systemd files
echo "Copying systemd files..."
cp monitoring.service /etc/systemd/system/
cp monitoring.timer /etc/systemd/system/

# Reload systemd
echo "Reloading systemd..."
systemctl daemon-reload

# Enable and start timer
echo "Enabling and starting timer..."
systemctl enable monitoring.timer
systemctl start monitoring.timer

# Create log file with proper permissions
touch /var/log/monitoring.log
chmod 644 /var/log/monitoring.log

echo "Installation completed successfully!"
echo "Timer status: systemctl status monitoring.timer"
echo "Log file: /var/log/monitoring.log"