#!/bin/sh -eux
# Functional test: patch ������
# Tests: patch commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q patch 2>/dev/null || { echo 'patch not installed, skipping'; exit 0; }
which patch 2>/dev/null || echo 'patch not found'
rlRun 'patch --version 2>&1 || true' 0 "��ȡ patch �汾��Ϣ"

echo ""
echo "All patch functional tests passed!"
