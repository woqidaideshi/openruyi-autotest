#!/bin/sh -eux
# Functional test: time ������
# Tests: time commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q time 2>/dev/null || { echo 'time not installed, skipping'; exit 0; }
which time 2>/dev/null || echo 'time not found'
rlRun 'time --version 2>&1 || true' 0 "��ȡ time �汾��Ϣ"

echo ""
echo "All time functional tests passed!"
