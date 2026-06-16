#!/bin/sh -eux
# Functional test: coreutils - Flow-control--sleep--timeout--yes

. "../setup.sh"

echo "=== Test 18: Flow control (sleep, timeout, yes) ==="

# 18.1 sleep
rlRun 'sleep 0.1' 0 "sleep delay"

# 18.2 timeout
rlRun 'timeout 2 sleep 0.1' 0 "timeout: command finishes in time"
rlRun 'timeout 2 sleep 0.1 && echo ok' 0 "timeout: successful completion"
rlRun 'timeout 0.1 sleep 5' 124 "timeout: kills slow command" || true

# 18.3 yes
rlRun 'yes | head -5' 0 "yes repeated output"
rlRun 'yes hello | head -3' 0 "yes custom string"

# ===================================================================

. "../teardown.sh"
echo "All coreutils Flow-control--sleep--timeout--yes tests passed!"
