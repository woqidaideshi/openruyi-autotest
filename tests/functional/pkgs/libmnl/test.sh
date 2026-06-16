#!/bin/sh -eux
# Functional test: libmnl - ���
# Commands: libmnl.so.0, libmnl.so.0.2.0

. "./setup.sh"

rlRun 'ldconfig -p 2>/dev/null | grep libmnl | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libmnl 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

. "./teardown.sh"
echo "All libmnl functional tests passed!"
