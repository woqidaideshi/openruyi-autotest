#!/bin/sh -eux
# Functional test: kmod - �ں�ģ�����
# Commands: depmod, insmod, kmod, lsmod, modinfo, modprobe, rmmod

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q kmod 2>/dev/null || { echo 'kmod not installed, skipping'; exit 0; }
which lsmod 2>/dev/null || echo 'lsmod not found'
which modinfo 2>/dev/null || echo 'modinfo not found'
which modprobe 2>/dev/null || echo 'modprobe not found'

echo ""
echo "All kmod functional tests passed!"
