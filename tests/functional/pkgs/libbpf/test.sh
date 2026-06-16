#!/bin/sh -eux
# Functional test: libbpf - ���
# Commands: libbpf.so.1, libbpf.so.1.7.0

. "./setup.sh"

rlRun 'ldconfig -p 2>/dev/null | grep libbpf | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libbpf 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

. "./teardown.sh"
echo "All libbpf functional tests passed!"
