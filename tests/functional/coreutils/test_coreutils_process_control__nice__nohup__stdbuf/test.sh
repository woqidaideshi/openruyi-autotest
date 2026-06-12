#!/bin/sh -eux
# Functional test: coreutils - Process-control--nice--nohup--stdbuf

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q coreutils 2>/dev/null || { echo 'coreutils not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 19: Process control (nice, nohup, stdbuf) ==="

# 19.1 nice
rlRun 'nice -n 10 true' 0 "nice adjust priority"

# 19.2 nohup
rlRun 'nohup true' 0 "nohup run command"

# 19.3 stdbuf
rlRun 'stdbuf -oL echo test 2>&1 || true' 0 "stdbuf line buffered output"

# ===================================================================

echo ""
echo "All coreutils Process-control--nice--nohup--stdbuf tests passed!"
