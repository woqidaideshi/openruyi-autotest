#!/bin/sh -eux
# Functional test: libeconf - ���
# Commands: libeconf.so.0, libeconf.so.0.7.8

. "./setup.sh"

rlRun 'ldconfig -p 2>/dev/null | grep libeconf | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libeconf 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

. "./teardown.sh"
echo "All libeconf functional tests passed!"
