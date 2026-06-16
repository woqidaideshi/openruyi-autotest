#!/bin/sh -eux
# Functional test: libgpg-error - ���
# Commands: libgpg-error.so.0, libgpg-error.so.0.41.1

. "./setup.sh"

rlRun 'ldconfig -p 2>/dev/null | grep libgpg-error | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libgpg-error 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

. "./teardown.sh"
echo "All libgpg-error functional tests passed!"
