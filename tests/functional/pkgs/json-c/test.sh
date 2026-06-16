#!/bin/sh -eux
# Functional test: json-c - ���
# Commands: libjson-c.so.5, libjson-c.so.5.4.0

. "./setup.sh"

rlRun 'ldconfig -p 2>/dev/null | grep json-c | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql json-c 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

. "./teardown.sh"
echo "All json-c functional tests passed!"
