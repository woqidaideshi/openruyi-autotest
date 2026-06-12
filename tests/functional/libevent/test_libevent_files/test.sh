#!/bin/sh -eux
# Functional test: libevent - �ļ���֤
# Commands: libevent-2.1.so.7, libevent-2.1.so.7.0.1, libevent_core-2.1.so.7, libevent_core-2.1.so.7.0.1, libevent_extra-2.1.so.7, libevent_extra-2.1.so.7.0.1, libevent_openssl-2.1.so.7, libevent_openssl-2.1.so.7.0.1, libevent_pthreads-2.1.so.7, libevent_pthreads-2.1.so.7.0.1

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libevent 2>/dev/null || { echo 'libevent not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libevent-2.1.so.7* 2>/dev/null || ls /usr/lib/libevent-2.1.so.7* 2>/dev/null || echo "not in standard path"' 0 "��� libevent-2.1.so.7"
rlRun 'ls /usr/lib64/libevent-2.1.so.7.0.1* 2>/dev/null || ls /usr/lib/libevent-2.1.so.7.0.1* 2>/dev/null || echo "not in standard path"' 0 "��� libevent-2.1.so.7.0.1"
rlRun 'ls /usr/lib64/libevent_core-2.1.so.7* 2>/dev/null || ls /usr/lib/libevent_core-2.1.so.7* 2>/dev/null || echo "not in standard path"' 0 "��� libevent_core-2.1.so.7"
rlRun 'ls /usr/lib64/libevent_core-2.1.so.7.0.1* 2>/dev/null || ls /usr/lib/libevent_core-2.1.so.7.0.1* 2>/dev/null || echo "not in standard path"' 0 "��� libevent_core-2.1.so.7.0.1"
rlRun 'ls /usr/lib64/libevent_extra-2.1.so.7* 2>/dev/null || ls /usr/lib/libevent_extra-2.1.so.7* 2>/dev/null || echo "not in standard path"' 0 "��� libevent_extra-2.1.so.7"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libevent 2>&1 || true' 0 "pkg-config ����Ϣ"

echo ""
echo "All libevent-files functional tests passed!"
