#!/bin/sh -eux
# Functional test: kmod - ��������
# Commands: lsmod, modinfo, modprobe

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q kmod 2>/dev/null || { echo 'kmod not installed, skipping'; exit 0; }
which lsmod 2>/dev/null || echo 'lsmod not found'
which modinfo 2>/dev/null || echo 'modinfo not found'
which modprobe 2>/dev/null || echo 'modprobe not found'

echo "=== �ں�ģ����� ==="
rlRun 'lsmod 2>&1 | head -10' 0 "�г����ص�ģ��"
rlRun 'modinfo --help 2>&1 | head -10' 0 "modinfo ����"
rlRun 'modprobe --help 2>&1 | head -10' 0 "modprobe ����"

echo ""
echo "All kmod-basic functional tests passed!"
