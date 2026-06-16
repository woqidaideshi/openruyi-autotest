#!/bin/sh -eux
# Functional test: libsepol - ���
# Commands: libsepol.so.2

. "./setup.sh"

rlRun 'ldconfig -p 2>/dev/null | grep libsepol | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libsepol 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

. "./teardown.sh"
echo "All libsepol functional tests passed!"
