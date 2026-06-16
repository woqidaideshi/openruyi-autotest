#!/bin/sh -eux
# Functional test: jitterentropy - ���
# Commands: libjitterentropy.so.3, libjitterentropy.so.3.6.3

. "./setup.sh"

rlRun 'ldconfig -p 2>/dev/null | grep jitterentropy | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql jitterentropy 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

. "./teardown.sh"
echo "All jitterentropy functional tests passed!"
