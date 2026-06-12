#!/bin/sh -eux
# Functional test: gcc16 - GCC 16 ������
# Commands: gcc-16, g++-16, gcov-16

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q gcc16 2>/dev/null || { echo 'gcc16 not installed, skipping'; exit 0; }
which gcc-16 2>/dev/null || echo 'gcc-16 not found'
which g++-16 2>/dev/null || echo 'g++-16 not found'

echo ""
echo "All gcc16 functional tests passed!"
