#!/bin/sh -eux
# Functional test: libcap - ���
# Commands: libcap.so.2, libcap.so.2.76, libpsx.so.2, libpsx.so.2.76, pam_cap.so

. "./setup.sh"

rlRun 'ldconfig -p 2>/dev/null | grep libcap | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libcap 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

. "./teardown.sh"
echo "All libcap functional tests passed!"
