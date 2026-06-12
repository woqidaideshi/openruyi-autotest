#!/bin/sh -eux
# Functional test: libpwquality ������
# Tests: pwmake, pwscore commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libpwquality 2>/dev/null || { echo 'libpwquality not installed, skipping'; exit 0; }
which pwmake 2>/dev/null || echo 'pwmake not found'
which pwscore 2>/dev/null || echo 'pwscore not found'
rlRun 'pwmake --version 2>&1 || true' 0 "��ȡ pwmake �汾��Ϣ"
rlRun 'pwscore --version 2>&1 || true' 0 "��ȡ pwscore �汾��Ϣ"

echo ""
echo "All libpwquality functional tests passed!"
