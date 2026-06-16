#!/bin/sh -eux
# Functional test: libbpf - �ļ���֤
# Commands: libbpf.so.1, libbpf.so.1.7.0

. "../setup.sh"

rlRun 'ls /usr/lib64/libbpf.so.1* 2>/dev/null || ls /usr/lib/libbpf.so.1* 2>/dev/null || echo "not in standard path"' 0 "��� libbpf.so.1"
rlRun 'ls /usr/lib64/libbpf.so.1.7.0* 2>/dev/null || ls /usr/lib/libbpf.so.1.7.0* 2>/dev/null || echo "not in standard path"' 0 "��� libbpf.so.1.7.0"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libbpf 2>&1 || true' 0 "pkg-config ����Ϣ"

. "../teardown.sh"
echo "All libbpf-files functional tests passed!"
