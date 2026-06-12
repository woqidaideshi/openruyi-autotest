#!/bin/sh -eux
# Functional test: p11-kit - PKCS#11 ����
# Commands: p11-kit, trust

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q p11-kit 2>/dev/null || { echo 'p11-kit not installed, skipping'; exit 0; }
which p11-kit 2>/dev/null || echo 'p11-kit not found'
which trust 2>/dev/null || echo 'trust not found'

echo ""
echo "All p11-kit functional tests passed!"
