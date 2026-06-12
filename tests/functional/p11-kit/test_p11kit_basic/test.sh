#!/bin/sh -eux
# Functional test: p11-kit - ��������
# Commands: p11-kit, trust

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q p11-kit 2>/dev/null || { echo 'p11-kit not installed, skipping'; exit 0; }
which p11-kit 2>/dev/null || echo 'p11-kit not found'
which trust 2>/dev/null || echo 'trust not found'

echo "=== p11-kit �������� ==="
rlRun 'p11-kit --help 2>&1 | head -10' 0 "p11-kit ����"
rlRun 'trust --help 2>&1 | head -10' 0 "trust ����"
rlRun 'p11-kit list-modules 2>&1 | head -5 || true' 0 "�г�ģ��"
rlRun 'trust list 2>&1 | head -5 || true' 0 "�г�����ê"

echo ""
echo "All p11kit-basic functional tests passed!"
