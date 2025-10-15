#!/bin/bash

# Configuration
LOG_FILE="/var/log/monitoring.log"
PID_FILE="/var/run/monitoring_test.pid"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" >> "$LOG_FILE"
}

# Function to check if process was restarted
check_process_restart() {
    local current_pids
    current_pids=$(pgrep "test" | sort | tr '\n' ' ' | xargs)
    
    # Read previous PIDs
    local previous_pids=""
    if [[ -f "$PID_FILE" ]]; then
        previous_pids=$(cat "$PID_FILE" | xargs)
    fi
    
    if [[ -n "$current_pids" ]]; then
        # Process is running
        if [[ -n "$previous_pids" ]] && [[ "$previous_pids" != "$current_pids" ]]; then
            log_message "Процесс test был перезапущен. Было: [$previous_pids], стало: [$current_pids]"
        fi
        
        # Save current PIDs
        echo "$current_pids" > "$PID_FILE"
        return 0
    else
        # Process is not running - remove PID file
        if [[ -f "$PID_FILE" ]]; then
            rm -f "$PID_FILE"
        fi
        return 1
    fi
}

# Function to check monitoring server
check_monitoring_server() {
    local response
    local curl_output
    
    curl_output=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 10 --max-time 30 "https://test.com/monitoring/test/api" 2>&1)
    local curl_exit_code=$?
    
    if [[ $curl_exit_code -ne 0 ]]; then
        log_message "Сервер мониторинга не доступен (ошибка curl: $curl_exit_code)"
        return 1
    fi
    
    if [[ "$curl_output" =~ ^2[0-9][0-9]$ ]]; then
        return 0
    else
        log_message "Сервер мониторинга вернул ошибку: HTTP $curl_output"
        return 1
    fi
}

# Main logic
main() {
    # Create log file if it doesn't exist
    touch "$LOG_FILE"
    
    # Check if process is running
    if check_process_restart; then
        # Process is running - check monitoring server
        check_monitoring_server
    fi
    # Else: process not running - do nothing (as per requirements)
}

# Run main function
main