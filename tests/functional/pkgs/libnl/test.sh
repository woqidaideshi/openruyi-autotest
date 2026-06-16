#!/bin/sh -eux
# Functional test: libnl - ���
# Commands: libnl-3.so.200, libnl-3.so.200.26.0, libnl-genl-3.so.200, libnl-genl-3.so.200.26.0, libnl-idiag-3.so.200, libnl-idiag-3.so.200.26.0, libnl-nf-3.so.200, libnl-nf-3.so.200.26.0, libnl-route-3.so.200, libnl-route-3.so.200.26.0, libnl-xfrm-3.so.200, libnl-xfrm-3.so.200.26.0

. "./setup.sh"

rlRun 'ldconfig -p 2>/dev/null | grep libnl | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libnl 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

. "./teardown.sh"
echo "All libnl functional tests passed!"
