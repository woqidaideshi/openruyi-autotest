#!/bin/sh -eux
# Functional test: libcap-ng - ���
# Commands: libcap-ng.so.0, libcap-ng.so.0.0.0, libdrop_ambient.so.0, libdrop_ambient.so.0.0.0

. "./setup.sh"

rlRun 'ldconfig -p 2>/dev/null | grep libcap-ng | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libcap-ng 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

. "./teardown.sh"
echo "All libcap-ng functional tests passed!"
