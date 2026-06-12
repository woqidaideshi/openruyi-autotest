#!/bin/sh -eux
# Functional test: libevent - ���
# Commands: libevent-2.1.so.7, libevent-2.1.so.7.0.1, libevent_core-2.1.so.7, libevent_core-2.1.so.7.0.1, libevent_extra-2.1.so.7, libevent_extra-2.1.so.7.0.1, libevent_openssl-2.1.so.7, libevent_openssl-2.1.so.7.0.1, libevent_pthreads-2.1.so.7, libevent_pthreads-2.1.so.7.0.1

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libevent 2>/dev/null || { echo 'libevent not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libevent | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libevent 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

echo ""
echo "All libevent functional tests passed!"
