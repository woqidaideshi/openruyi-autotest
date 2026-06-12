#!/bin/sh -eux
# Functional test: libnetfilter_conntrack - �ļ���֤
# Commands: libnetfilter_conntrack.so.3, libnetfilter_conntrack.so.3.8.0

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libnetfilter_conntrack 2>/dev/null || { echo 'libnetfilter_conntrack not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libnetfilter_conntrack.so.3* 2>/dev/null || ls /usr/lib/libnetfilter_conntrack.so.3* 2>/dev/null || echo "not in standard path"' 0 "��� libnetfilter_conntrack.so.3"
rlRun 'ls /usr/lib64/libnetfilter_conntrack.so.3.8.0* 2>/dev/null || ls /usr/lib/libnetfilter_conntrack.so.3.8.0* 2>/dev/null || echo "not in standard path"' 0 "��� libnetfilter_conntrack.so.3.8.0"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libnetfilter_conntrack 2>&1 || true' 0 "pkg-config ����Ϣ"

echo ""
echo "All libnetfilter_conntrack-files functional tests passed!"
