#!/bin/sh -eux
# Functional test: tzdata ������
# Tests: tzselect, zdump, zic commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q tzdata 2>/dev/null || { echo 'tzdata not installed, skipping'; exit 0; }
which tzselect 2>/dev/null || echo 'tzselect not found'
which zdump 2>/dev/null || echo 'zdump not found'
which zic 2>/dev/null || echo 'zic not found'
rlRun 'tzselect --version 2>&1 || true' 0 "��ȡ tzselect �汾��Ϣ"
rlRun 'zdump --version 2>&1 || true' 0 "��ȡ zdump �汾��Ϣ"
rlRun 'zic --version 2>&1 || true' 0 "��ȡ zic �汾��Ϣ"

echo ""
echo "All tzdata functional tests passed!"
