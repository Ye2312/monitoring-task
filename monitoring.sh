#!/bin/bash

PROCESS_NAME="test"
MONITORING_URL="https://test.com/monitoring/test/api"
LOG_FILE="/var/log/monitoring.log"
PID_FILE="/var/run/monitoring_test.pid"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

check_server() {
    local response_code
    response_code=$(curl -s -o /dev/null -w "%{http_code}" -H "Cache-Control: no-cache" "$MONITORING_URL")
    
    if [ "$response_code" -ne 200 ]; then
        log_message "ERROR: Monitoring server unavailable. HTTP Code: $response_code"
        return 1
    fi
    return 0
}

check_process() {
    local current_pid
    local previous_pid
    

    current_pid=$(pgrep -x "$PROCESS_NAME")
    
    
    if [ -z "$current_pid" ]; then

        if [ -f "$PID_FILE" ]; then
            rm -f "$PID_FILE"
        fi
        return 1
    fi
   
    if [ -f "$PID_FILE" ]; then
        previous_pid=$(cat "$PID_FILE")
        if [ "$current_pid" != "$previous_pid" ]; then
            log_message "INFO: Process $PROCESS_NAME was restarted. Old PID: $previous_pid, New PID: $current_pid"
        fi
    else
     
        log_message "INFO: Process $PROCESS_NAME started with PID: $current_pid"
    fi
    
    echo "$current_pid" > "$PID_FILE"
    
    return 0
}

main() {
    if check_process; then
        if ! check_server; then
            exit 1
        fi
    fi
}

main "$@"