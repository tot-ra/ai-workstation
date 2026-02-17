#!/bin/bash
# Create a systemd timer job with a custom script for opencode-scheduler
# Usage: ./create_job_with_script.sh <job_name> <schedule_cron> <work_dir> <file_pattern>

set -e

JOB_NAME="$1"
SCHEDULE="$2"
WORK_DIR="$3"
FILE_PATTERN="$4"

if [ -z "$JOB_NAME" ] || [ -z "$SCHEDULE" ] || [ -z "$WORK_DIR" ] || [ -z "$FILE_PATTERN" ]; then
    echo "Usage: $0 <job_name> <schedule_cron> <work_dir> <file_pattern>"
    echo "Example: $0 analyze-md '0 9 * * *' ~/project '*.md'"
    exit 1
fi

# Convert cron schedule (simplified)
MINUTE=$(echo "$SCHEDULE" | awk '{print $1}')
HOUR=$(echo "$SCHEDULE" | awk '{print $2}')
ON_CALENDAR="*-*-* $HOUR:$MINUTE:00"

# Create directories
mkdir -p ~/.config/opencode/jobs
mkdir -p ~/.config/systemd/user
mkdir -p ~/.config/opencode/logs

# Create the script
cat > ~/.config/opencode/jobs/${JOB_NAME}.sh << SCRIPT
#!/bin/bash
# Auto-generated job: ${JOB_NAME}

WORK_DIR="${WORK_DIR}"
cd "\$WORK_DIR"

# Чтение файлов с пробелами в именах
FILES=\$(find "\$WORK_DIR" -name "${FILE_PATTERN}" -type f 2>/dev/null | head -5)
CONTENT=""
while IFS= read -r file; do
    CONTENT+="\\n\\n--- \$(basename "\$file") ---\\n"
    CONTENT+=\$(cat "\$file")
done <<< "\$FILES"

# Формирование промпта через heredoc
PROMPT=\$(cat <<EOF
Проанализируй файлы:
\${CONTENT}

Сделай выводы.
EOF
)

\$HOME/.local/bin/opencode run -- "\$PROMPT"
SCRIPT

chmod +x ~/.config/opencode/jobs/${JOB_NAME}.sh

# Create service file
cat > ~/.config/systemd/user/opencode-job-${JOB_NAME}.service << EOF
[Unit]
Description=OpenCode Job: ${JOB_NAME}

[Service]
Type=oneshot
ExecStart=%h/.config/opencode/jobs/${JOB_NAME}.sh
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
echo "Script: ~/.config/opencode/jobs/${JOB_NAME}.sh"
echo "View status: systemctl --user status opencode-job-${JOB_NAME}.timer"
echo "View logs: journalctl --user -u opencode-job-${JOB_NAME}.service -f"
