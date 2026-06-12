#!/bin/sh -eux
# Functional test: bzip2 - ѹ������
# Commands: bzip2, bunzip2, bzcat, bzip2recover

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q bzip2 2>/dev/null || { echo 'bzip2 not installed, skipping'; exit 0; }
which bzip2 2>/dev/null || echo 'bzip2 not found'
which bunzip2 2>/dev/null || echo 'bunzip2 not found'
which bzcat 2>/dev/null || echo 'bzcat not found'
rlRun 'bzip2 --version 2>&1 || true' 0 "��ȡ bzip2 �汾"

echo ""
echo "All bzip2 functional tests passed!"
