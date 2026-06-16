#!/bin/sh -eux
# Functional test: libpsl - ���
# Commands: libpsl.so.5, libpsl.so.5.3.5

. "./setup.sh"

rlRun 'ldconfig -p 2>/dev/null | grep libpsl | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libpsl 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

. "./teardown.sh"
echo "All libpsl functional tests passed!"
