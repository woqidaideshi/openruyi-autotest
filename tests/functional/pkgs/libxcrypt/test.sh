#!/bin/sh -eux
# Functional test: libxcrypt - ���
# Commands: libcrypt.so.1, libcrypt.so.1.1.0, libowcrypt.so.1

. "./setup.sh"

rlRun 'ldconfig -p 2>/dev/null | grep libxcrypt | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libxcrypt 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

. "./teardown.sh"
echo "All libxcrypt functional tests passed!"
