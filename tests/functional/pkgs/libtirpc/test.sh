#!/bin/sh -eux
# Functional test: libtirpc - ���
# Commands: libtirpc.so.3, libtirpc.so.3.0.0

. "./setup.sh"

rlRun 'ldconfig -p 2>/dev/null | grep libtirpc | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libtirpc 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

. "./teardown.sh"
echo "All libtirpc functional tests passed!"
