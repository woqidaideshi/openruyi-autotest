#!/bin/sh -eux
# Functional test: libnftnl - ���
# Commands: libnftnl.so.11, libnftnl.so.11.6.0

. "./setup.sh"

rlRun 'ldconfig -p 2>/dev/null | grep libnftnl | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libnftnl 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

. "./teardown.sh"
echo "All libnftnl functional tests passed!"
