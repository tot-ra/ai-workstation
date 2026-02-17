#!/bin/bash
#
# OpenCode Unified Task Scheduler (hourly-thinking)
# This script simply delegates the scheduling logic to the OpenCode agent using a single MD file.

# Binary path
OPCODE_BIN="$HOME/.local/bin/opencode"

# MD file containing the scheduling logic
SCHEDULER_FILE="$HOME/git/mind/agent/jobs/unified-scheduler.md"

echo "[$(date +%Y-%m-%dT%H:%M:%S)] Starting unified scheduler. Delegating to agent with $SCHEDULER_FILE."

# Execute the agent with the scheduler file.
# The agent will determine which sub-task to run (or self-reflect) based on the time.
# The final result of this run should be a successful execution of a sub-task or self-reflection.
$OPCODE_BIN run "$(cat $SCHEDULER_FILE)"

echo "[$(date +%Y-%m-%dT%H:%M:%S)] Unified scheduler run finished."
