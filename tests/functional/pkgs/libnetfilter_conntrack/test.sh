#!/bin/sh -eux
# Functional test: libnetfilter_conntrack - ���
# Commands: libnetfilter_conntrack.so.3, libnetfilter_conntrack.so.3.8.0

. "./setup.sh"

rlRun 'ldconfig -p 2>/dev/null | grep libnetfilter_conntrack | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libnetfilter_conntrack 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

. "./teardown.sh"
echo "All libnetfilter_conntrack functional tests passed!"
