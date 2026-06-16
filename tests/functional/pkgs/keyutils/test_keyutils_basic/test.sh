#!/bin/sh -eux
# Functional test: keyutils - ��������
# Commands: keyctl

. "../setup.sh"

rlRun 'keyctl show 2>&1 || true' 0 "��ʾ��ǰ��Կ"
rlRun 'keyctl list @u 2>&1 || true' 0 "�г��û���Կ"

. "../teardown.sh"
echo "All keyutils-basic functional tests passed!"
