# Process Monitoring System

This system monitors the `test` process and reports to a monitoring server.

## Files

- `monitoring.sh` - Main monitoring script
- `monitoring.service` - Systemd service file
- `monitoring.timer` - Systemd timer (runs every minute)
- `install.sh` - Installation script
- `uninstall.sh` - Uninstallation script

## Installation

1. Clone the repository:
```bash
git clone https://github.com/Ye2312/monitoring-task.git
cd monitoring-task
sudo ./install.sh