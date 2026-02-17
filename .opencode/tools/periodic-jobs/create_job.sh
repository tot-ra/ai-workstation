#!/bin/bash
# Create a systemd timer job for opencode-scheduler
# Usage: ./create_job.sh <job_name> <schedule_cron> <prompt>

set -e

JOB_NAME="$1"
SCHEDULE="$2"
PROMPT="$3"

if [ -z "$JOB_NAME" ] || [ -z "$SCHEDULE" ] || [ -z "$PROMPT" ]; then
    echo "Usage: $0 <job_name> <schedule_cron> <prompt>"
    echo "Example: $0 daily-backup '0 9 * * *' 'Run backup script'"
    exit 1
fi

# Convert cron schedule to systemd OnCalendar format
# This is a simplified conversion - assumes standard cron format
MINUTE=$(echo "$SCHEDULE" | awk '{print $1}')
HOUR=$(echo "$SCHEDULE" | awk '{print $2}')
DAY=$(echo "$SCHEDULE" | awk '{print $3}')
MONTH=$(echo "$SCHEDULE" | awk '{print $4}')
DOW=$(echo "$SCHEDULE" | awk '{print $5}')

# Build OnCalendar string
ON_CALENDAR=""
[ "$DAY" != "*" ] && ON_CALENDAR="$DAY-"
[ "$MONTH" != "*" ] && ON_CALENDAR="${ON_CALENDAR}$MONTH-"
ON_CALENDAR="*-*-*"  # Default to daily
ON_CALENDAR="$ON_CALENDAR $HOUR:$MINUTE:00"

# Create directories
mkdir -p ~/.config/systemd/user
mkdir -p ~/.config/opencode/logs

# Create service file
cat > ~/.config/systemd/user/opencode-job-${JOB_NAME}.service << EOF
[Unit]
Description=OpenCode Job: ${JOB_NAME}

[Service]
Type=oneshot
WorkingDirectory=%h/git/ai-workstation
ExecStart=/bin/bash -c '%h/.local/bin/opencode run -- "${PROMPT}"'
StandardOutput=append:%h/.config/opencode/logs/${JOB_NAME}.log
StandardError=append:%h/.config/opencode/logs/${JOB_NAME}.log

[Install]
WantedBy=default.target
EOF

# Create timer file
cat > ~/.config/systemd/user/opencode-job-${JOB_NAME}.timer << EOF
[Unit]
Description=Timer for: ${JOB_NAME}

[Timer]
OnCalendar=${ON_CALENDAR}
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Reload and enable
systemctl --user daemon-reload
systemctl --user enable opencode-job-${JOB_NAME}.timer
systemctl --user start opencode-job-${JOB_NAME}.timer

echo "Job '${JOB_NAME}' created and started!"
echo "View status: systemctl --user status opencode-job-${JOB_NAME}.timer"
echo "View logs: journalctl --user -u opencode-job-${JOB_NAME}.service -f"
