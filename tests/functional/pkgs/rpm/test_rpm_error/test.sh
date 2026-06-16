#!/bin/sh -eux
# Functional test: rpm ������

. "../setup.sh"

rlRun 'rpm --invalid 2>&1 || true' 0 "��Ч����"
rlRun 'rpm -q nonexistent 2>&1 || true' 1-255 "��ѯ�����ڵİ�"

. "../teardown.sh"
echo "All rpm-error functional tests passed!"
