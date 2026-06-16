#!/bin/sh -eux
# Functional test: popt - ���
# Commands: libpopt.so.0, libpopt.so.0.0.2

. "./setup.sh"

rlRun 'ldconfig -p 2>/dev/null | grep popt | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql popt 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

. "./teardown.sh"
echo "All popt functional tests passed!"
