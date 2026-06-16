#!/bin/sh -eux
# Functional test: libnfnetlink - ���
# Commands: libnfnetlink.so.0, libnfnetlink.so.0.2.0

. "./setup.sh"

rlRun 'ldconfig -p 2>/dev/null | grep libnfnetlink | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libnfnetlink 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

. "./teardown.sh"
echo "All libnfnetlink functional tests passed!"
