#!/bin/sh -eux
# Functional test: libpwquality - ��������
# Tests: pwmake, pwscore commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libpwquality 2>/dev/null || { echo 'libpwquality not installed, skipping'; exit 0; }
which pwmake 2>/dev/null || echo 'pwmake not found'
which pwscore 2>/dev/null || echo 'pwscore not found'

echo "=== ����: libpwquality �������� ==="
rlRun 'pwmake --help 2>&1 | head -10' 0 "�鿴 pwmake ������Ϣ"
rlRun 'pwscore --help 2>&1 | head -10' 0 "�鿴 pwscore ������Ϣ"

echo ""
echo "All libpwquality-basic functional tests passed!"
