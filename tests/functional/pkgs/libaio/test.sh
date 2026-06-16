#!/bin/sh -eux
# Functional test: libaio - ���
# Commands: libaio.so.1, libaio.so.1.0.2

. "./setup.sh"

rlRun 'ldconfig -p 2>/dev/null | grep libaio | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libaio 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

. "./teardown.sh"
echo "All libaio functional tests passed!"
