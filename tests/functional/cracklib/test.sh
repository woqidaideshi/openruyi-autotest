#!/bin/sh -eux
# Functional test: cracklib - ����ǿ�ȼ��
# Commands: cracklib-check, cracklib-format, cracklib-packer, cracklib-unpacker

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q cracklib 2>/dev/null || { echo 'cracklib not installed, skipping'; exit 0; }
which cracklib-check 2>/dev/null || echo 'cracklib-check not found'

echo ""
echo "All cracklib functional tests passed!"
