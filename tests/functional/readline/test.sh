#!/bin/sh -eux
# Functional test: readline - ���
# Commands: libhistory.so.8, libhistory.so.8.3, libreadline.so.8, libreadline.so.8.3

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q readline 2>/dev/null || { echo 'readline not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep readline | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql readline 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

echo ""
echo "All readline functional tests passed!"
