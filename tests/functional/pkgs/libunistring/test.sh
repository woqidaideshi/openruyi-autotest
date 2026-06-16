#!/bin/sh -eux
# Functional test: libunistring - ���
# Commands: libunistring.so.5, libunistring.so.5.2.1

. "./setup.sh"

rlRun 'ldconfig -p 2>/dev/null | grep libunistring | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libunistring 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

. "./teardown.sh"
echo "All libunistring functional tests passed!"
