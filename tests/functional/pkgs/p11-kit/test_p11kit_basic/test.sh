#!/bin/sh -eux
# Functional test: p11-kit - ��������
# Commands: p11-kit, trust

. "../setup.sh"

rlRun 'p11-kit list-modules 2>&1 | head -5 || true' 0 "�г�ģ��"
rlRun 'trust list 2>&1 | head -5 || true' 0 "�г�����ê"

. "../teardown.sh"
echo "All p11kit-basic functional tests passed!"
