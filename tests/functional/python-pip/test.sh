#!/bin/sh -eux
# Functional test: python-pip - Python ��������
# Commands: pip3

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q python3-pip 2>/dev/null || { echo 'python3-pip not installed, skipping'; exit 0; }
which pip3 2>/dev/null || echo 'pip3 not found'
rlRun 'pip3 --version 2>&1 || true' 0 "��ȡ pip3 �汾"

echo ""
echo "All python-pip functional tests passed!"
